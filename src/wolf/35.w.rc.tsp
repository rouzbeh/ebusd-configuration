import "@ebusd/ebus-typespec";
import "./_templates.tsp";
using Ebus;
using Ebus.Num;
using Ebus.Dtm;

namespace Wolf;

// Weishaupt room unit (scan: Kromschroeder;W;8002) as found with a Weishaupt heat pump.
// It answers register reads with a checked register ID and pushes its values to the heat pump (f1) every 30 s.
// Unknown registers are answered with 0x8000.
namespace rc {
  /** absence state */
  @values(Values_absent)
  scalar absent extends UIN;

  enum Values_absent {
    present: 0,
    absent: 1,
  }

  /** program selector */
  @values(Values_programMode)
  scalar programmode extends UIN;

  enum Values_programMode {
    standby: 1,
    normal: 3,
    setback: 4,
    summer: 5,
    program1: 11,
    program2: 12,
    program3: 13,
    standbyWtc: 20,
  }

  /** holiday temperature level */
  @values(Values_holidayLevel)
  scalar holidaylevel extends UIN;

  enum Values_holidayLevel {
    frost: 0,
    setback: 1,
  }

  /** first heating phase of program 1 on a day */
  @inherit(regcr)
  model hcTimer {
    /** end of phase */
    end: TTQ;

    /** start of phase */
    start: TTQ;
  }

  /** room temperature measured by the room unit (0x06a8) */
  @ext(0x92, 0xa8, 0x06)
  model RoomTemp is CheckedRegister<stemp10>;

  /** active room target temperature, drops to the absence temperature while absent (0x06a7) */
  @ext(0x02, 0xa7, 0x06)
  model ActiveTargetTemp is CheckedRegister<stemp10>;

  /** normal room temperature, parameter P112 (0x06bf) */
  @ext(0xea, 0xbf, 0x06)
  model NormalTemp is CheckedRegister<stemp10>;

  /** setback room temperature, also used while absent, parameter P113 (0x06c1) */
  @ext(0xd2, 0xc1, 0x06)
  model SetbackTemp is CheckedRegister<stemp10>;

  /** absence button state (0x006d) */
  @ext(0x6c, 0x6d, 0x00)
  model Absent is CheckedRegister<absent>;

  /** program selector (0x0112) */
  @ext(0x09, 0x12, 0x01)
  model ProgramMode is CheckedRegister<programmode>;

  /** summer/winter changeover temperature, parameter 174 (0x0116) */
  @ext(0x25, 0x16, 0x01)
  model SummerWinterTemp is CheckedRegister<stemp10>;

  /** hot water target temperature (0x06b1) */
  @ext(0x26, 0xb1, 0x06)
  model HwcTempDesired is CheckedRegister<stemp10>;

  /** hot water maximum temperature, parameter 574 (0x0181) */
  @ext(0xad, 0x81, 0x01)
  model HwcTempMax is CheckedRegister<stemp10>;

  /** hot water minimum temperature, parameter 573 (0x028a) */
  @ext(0x12, 0x8a, 0x02)
  model HwcTempMin is CheckedRegister<stemp10>;

  /** holiday start day (0x011b) */
  @ext(0x0d, 0x1b, 0x01)
  model HolidayStartDay is CheckedRegister<UIN>;

  /** holiday start month (0x011c) */
  @ext(0xc5, 0x1c, 0x01)
  model HolidayStartMonth is CheckedRegister<UIN>;

  /** holiday start year, two digits (0x011d) */
  @ext(0x99, 0x1d, 0x01)
  model HolidayStartYear is CheckedRegister<UIN>;

  /** holiday end day (0x011e) */
  @ext(0x7d, 0x1e, 0x01)
  model HolidayEndDay is CheckedRegister<UIN>;

  /** holiday end month (0x011f) */
  @ext(0x21, 0x1f, 0x01)
  model HolidayEndMonth is CheckedRegister<UIN>;

  /** holiday end year, two digits (0x0120) */
  @ext(0x3d, 0x20, 0x01)
  model HolidayEndYear is CheckedRegister<UIN>;

  /** holiday temperature level, parameter P142 (0x013d) */
  @ext(0xa5, 0x3d, 0x01)
  model HolidayLevel is CheckedRegister<holidaylevel>;

  /** last error code, 0 for none (0x0b9b) */
  @ext(0xf7, 0x9b, 0x0b)
  model ErrorCode is CheckedRegister<UIN>;

  /** last error id, 0 for none (0x0b9a) */
  @ext(0xab, 0x9a, 0x0b)
  model ErrorId is CheckedRegister<UIN>;

  /** heating program 1 Monday (0x1410) */
  @ext(0xa4, 0x10, 0x14)
  model HcTimerMonday is hcTimer;

  /** heating program 1 Tuesday (0x1420) */
  @ext(0x28, 0x20, 0x14)
  model HcTimerTuesday is hcTimer;

  /** heating program 1 Wednesday (0x1430) */
  @ext(0x98, 0x30, 0x14)
  model HcTimerWednesday is hcTimer;

  /** heating program 1 Thursday (0x1440) */
  @ext(0x6c, 0x40, 0x14)
  model HcTimerThursday is hcTimer;

  /** heating program 1 Friday (0x1450) */
  @ext(0xdc, 0x50, 0x14)
  model HcTimerFriday is hcTimer;

  /** heating program 1 Saturday (0x1460) */
  @ext(0x50, 0x60, 0x14)
  model HcTimerSaturday is hcTimer;

  /** heating program 1 Sunday (0x1470) */
  @ext(0xe0, 0x70, 0x14)
  model HcTimerSunday is hcTimer;
}
