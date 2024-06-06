#include "shadowgate64.h"

f32 xPosCopy = 0.0f;
f32 yPosCopy = 0.0f;
f32 zPosCopy = 0.0f;
f32 unkPosRelatedCopy = 0.0f;
f32 yawCopy = 0.0f;

void MainLoop(void) {
    if (pressedButtons & L_JPAD) {
        xPosCopy = xPos;
        yPosCopy = yPos;
        zPosCopy = zPos;
        unkPosRelatedCopy = unkPosRelated;
        yawCopy = yaw;
    } else if (pressedButtons & R_JPAD) {
        xPos = xPosCopy;
        yPos = yPosCopy;
        zPos = zPosCopy;
        unkPosRelated = unkPosRelatedCopy;
        yaw = yawCopy;
    }
}


// can probably hook here for boot (main game loop?)
// 80090090

// xPos: 800EA72C
// yPos: 800EA730
// zPos: 800EA734
// unk: 800EA738
// angle: 800EA73C