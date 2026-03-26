/****************************************************************************
 *
 * (c) 2009-2020 QGROUNDCONTROL PROJECT <http://www.qgroundcontrol.org>
 *
 * QGroundControl is licensed according to the terms in the file
 * COPYING.md in the root of the source code directory.
 *
 ****************************************************************************/

#include "VehicleServoOutputFactGroup.h"
#include "Vehicle.h"

const char* VehicleServoOutputFactGroup::_servo1RawFactName = "servo1Raw";
const char* VehicleServoOutputFactGroup::_servo2RawFactName = "servo2Raw";
const char* VehicleServoOutputFactGroup::_servo3RawFactName = "servo3Raw";
const char* VehicleServoOutputFactGroup::_servo4RawFactName = "servo4Raw";
const char* VehicleServoOutputFactGroup::_servo5RawFactName = "servo5Raw";
const char* VehicleServoOutputFactGroup::_servo6RawFactName = "servo6Raw";
const char* VehicleServoOutputFactGroup::_servo7RawFactName = "servo7Raw";
const char* VehicleServoOutputFactGroup::_servo8RawFactName = "servo8Raw";

VehicleServoOutputFactGroup::VehicleServoOutputFactGroup(QObject* parent)
    : FactGroup         (200, ":/json/Vehicle/EscStatusFactGroup.json", parent)
    , _servo1RawFact    (0, _servo1RawFactName, FactMetaData::valueTypeUint16)
    , _servo2RawFact    (0, _servo2RawFactName, FactMetaData::valueTypeUint16)
    , _servo3RawFact    (0, _servo3RawFactName, FactMetaData::valueTypeUint16)
    , _servo4RawFact    (0, _servo4RawFactName, FactMetaData::valueTypeUint16)
    , _servo5RawFact    (0, _servo5RawFactName, FactMetaData::valueTypeUint16)
    , _servo6RawFact    (0, _servo6RawFactName, FactMetaData::valueTypeUint16)
    , _servo7RawFact    (0, _servo7RawFactName, FactMetaData::valueTypeUint16)
    , _servo8RawFact    (0, _servo8RawFactName, FactMetaData::valueTypeUint16)
{
    _addFact(&_servo1RawFact, _servo1RawFactName);
    _addFact(&_servo2RawFact, _servo2RawFactName);
    _addFact(&_servo3RawFact, _servo3RawFactName);
    _addFact(&_servo4RawFact, _servo4RawFactName);
    _addFact(&_servo5RawFact, _servo5RawFactName);
    _addFact(&_servo6RawFact, _servo6RawFactName);
    _addFact(&_servo7RawFact, _servo7RawFactName);
    _addFact(&_servo8RawFact, _servo8RawFactName);
}

void VehicleServoOutputFactGroup::handleMessage(Vehicle* /* vehicle */, mavlink_message_t& message)
{
    if (message.msgid != MAVLINK_MSG_ID_SERVO_OUTPUT_RAW) {
        return;
    }

    mavlink_servo_output_raw_t content;
    mavlink_msg_servo_output_raw_decode(&message, &content);

    servo1Raw()->setRawValue(content.servo1_raw);
    servo2Raw()->setRawValue(content.servo2_raw);
    servo3Raw()->setRawValue(content.servo3_raw);
    servo4Raw()->setRawValue(content.servo4_raw);
    servo5Raw()->setRawValue(content.servo5_raw);
    servo6Raw()->setRawValue(content.servo6_raw);
    servo7Raw()->setRawValue(content.servo7_raw);
    servo8Raw()->setRawValue(content.servo8_raw);
}