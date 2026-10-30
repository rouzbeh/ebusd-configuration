import "@ebusd/ebus-typespec";
import "../_templates.tsp";

using Ebus;
using Ebus.Num;
using Ebus.Dtm;
using Ebus.Str;

namespace Wolf;
alias MF = 0x50; // Ebus.Id.Values_manufacturers.Kromschröder

/** temperature */
@unit("°C")
@divisor(10)
scalar temp10 extends UIN;

/** percent */
@unit("%")
scalar percent extends UIN;

/** minutes */
@unit("min")
scalar minutes extends UIN;

/** hours */
@unit("h")
scalar hours extends UIN;

@unit("U/sec")
scalar speed extends UIN;

/** signed temperature */
@unit("°C")
@divisor(10)
scalar stemp10 extends SIN;

/** default *r for register */
@base(MF, 0x22, 0x00) // todo 0x00 should rather be crc8 of following bytes, see https://github.com/john30/ebusd/issues/167
model regr {}

/** default *w for register */
@write(true)
@base(MF, 0x23, 0x00)
model regw {}

/** read/write register */
@inherit(regr, regw) //todo first byte of ext always 0x0 on write
model Register<T, suffixValue extends valueof string = "9d010000"> {
  value: T;

  @maxLength(4)
  @out(true)
  @constValue(suffixValue)
  suffix: HEX;
}

/** read only register */
@inherit(regr)
model ReadonlyRegister<T> {
  value: T;
}

/** default *r for register with check byte */
@base(MF, 0x22)
model regcr {}

/**
 * read only register for devices verifying the check byte (e.g. Weishaupt):
 * the extension is the check byte followed by the register low and high byte,
 * where the check byte is the CRC-8 (polynomial 0x5c, initial value 0) of the register bytes,
 * see https://github.com/john30/ebusd/issues/167
 */
@inherit(regcr)
model CheckedRegister<T> {
  value: T;
}
