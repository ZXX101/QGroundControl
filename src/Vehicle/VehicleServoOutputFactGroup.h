/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#pragma once

#include "FactGroup.h"
#include "QGCMAVLink.h"

class Vehicle;

class VehicleServoOutputFactGroup : public FactGroup
{
    Q_OBJECT

public:
    VehicleServoOutputFactGroup(QObject* parent = nullptr);

    Q_PROPERTY(Fact* servo1Raw   READ servo1Raw   CONSTANT)
    Q_PROPERTY(Fact* servo2Raw   READ servo2Raw   CONSTANT)
    Q_PROPERTY(Fact* servo3Raw   READ servo3Raw   CONSTANT)
    Q_PROPERTY(Fact* servo4Raw   READ servo4Raw   CONSTANT)
    Q_PROPERTY(Fact* servo5Raw   READ servo5Raw   CONSTANT)
    Q_PROPERTY(Fact* servo6Raw   READ servo6Raw   CONSTANT)
    Q_PROPERTY(Fact* servo7Raw   READ servo7Raw   CONSTANT)
    Q_PROPERTY(Fact* servo8Raw   READ servo8Raw   CONSTANT)

    Fact* servo1Raw () { return &_servo1RawFact; }
    Fact* servo2Raw () { return &_servo2RawFact; }
    Fact* servo3Raw () { return &_servo3RawFact; }
    Fact* servo4Raw () { return &_servo4RawFact; }
    Fact* servo5Raw () { return &_servo5RawFact; }
    Fact* servo6Raw () { return &_servo6RawFact; }
    Fact* servo7Raw () { return &_servo7RawFact; }
    Fact* servo8Raw () { return &_servo8RawFact; }

    void handleMessage(Vehicle* vehicle, mavlink_message_t& message) override;

    static const char* _servo1RawFactName;
    static const char* _servo2RawFactName;
    static const char* _servo3RawFactName;
    static const char* _servo4RawFactName;
    static const char* _servo5RawFactName;
    static const char* _servo6RawFactName;
    static const char* _servo7RawFactName;
    static const char* _servo8RawFactName;

private:
    Fact _servo1RawFact;
    Fact _servo2RawFact;
    Fact _servo3RawFact;
    Fact _servo4RawFact;
    Fact _servo5RawFact;
    Fact _servo6RawFact;
    Fact _servo7RawFact;
    Fact _servo8RawFact;
};