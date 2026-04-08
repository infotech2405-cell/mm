#!/bin/bash
# SpectraSync Service Manager
# Starts all required backend services

PROJECT_DIR="/home/z/my-project"

echo "=== SpectraSync Service Manager ==="

# Kill existing instances
pkill -f "uvicorn.*3030" 2>/dev/null
pkill -f "bun.*index.ts.*3031" 2>/dev/null
sleep 1

# Start Python Backend (port 3030)
cd "$PROJECT_DIR/mini-services/spectra-sync"
source venv/bin/activate
python -m uvicorn index:app --host 0.0.0.0 --port 3030 &
BACK_PID=$!
echo "✅ Backend (Python/FastAPI) → PID: $BACK_PID Port: 3030"

# Start Chat Service (port 3031)
cd "$PROJECT_DIR/mini-services/chat-service"
bun index.ts &
CHAT_PID=$!
echo "✅ Chat Service (Bun/Node) → PID: $CHAT_PID Port: 3031"

# Wait for services
sleep 3

# Health checks
BACK_OK=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3030/health 2>/dev/null)
CHAT_OK=$(curl -s -o /dev/null -w "%{http_code}" http://localhost:3031/health 2>/dev/null)

echo ""
echo "=== Health Check ==="
echo "Backend (3030):  $([ "$BACK_OK" = "200" ] && echo "✅ UP" || echo "❌ DOWN")"
echo "Chat (3031):    $([ "$CHAT_OK" = "200" ] && echo "✅ UP" || echo "❌ DOWN")"
echo ""
echo "Frontend: http://localhost:3000 (Next.js dev server)"
echo "=== All services ready ==="

wait
