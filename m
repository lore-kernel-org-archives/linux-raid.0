From: Yuri Tikhonov <yur@emcraft.com>
Subject: Re[2]: [PATCH 11/11][v2] ppc440spe-adma: ADMA driver for PPC440SP(e) systems
Date: Fri, 16 Jan 2009 12:03:56 +0300
Message-ID: <13156621.20090116120356@emcraft.com>
References: <200901130343.56020.yur@emcraft.com> <20090113022316.GA3628@yookeroo.seuss>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1251
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090113022316.GA3628@yookeroo.seuss>
Sender: linux-raid-owner@vger.kernel.org
To: David Gibson <david@gibson.dropbear.id.au>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dan.j.williams@intel.com, wd@denx.de, dzu@denx.de, yanok@emcraft.com
List-Id: linux-raid.ids



 Hello David,

 Thanks a lot for review.

 The general note to be made here is that the changes to the DTS file 
made by this patch are necessary for a ppc440spe ADMA driver, which is 
a not-completed arch/powerpc port from the arch/ppc branch, and which 
uses DT (well, incorrectly) just to get interrupts. Otherwise, it's 
just a platform device driver.

 We provided this ADMA driver just as the reference of driver, which 
implements the RAID-6 related low-level stuff. ppc440spe ADMA in its 
current state is far from ready for merging. We'll elaborate on its 
cleaning up then (surely, taking into account all the comments made 
from community). But, even now, the driver works, so we publish this 
so interested people could use and test it.

 Some comments mixed in below.

On Tuesday, January 13, 2009 you wrote:

> On Tue, Jan 13, 2009 at 03:43:55AM +0300, Yuri Tikhonov wrote:
>> Adds the platform device definitions and the architecture specific support
>> routines for the ppc440spe adma driver.
>> 
>> Any board equipped with PPC440SP(e) controller may utilize this driver.
>> 
>> diff --git a/arch/powerpc/boot/dts/katmai.dts b/arch/powerpc/boot/dts/katmai.dts
>> index 077819b..f2f77c8 100644
>> --- a/arch/powerpc/boot/dts/katmai.dts
>> +++ b/arch/powerpc/boot/dts/katmai.dts
>> @@ -16,7 +16,7 @@
>>  
>>  / {
>>       #address-cells = <2>;
>> -     #size-cells = <1>;
>> +     #size-cells = <2>;

> You've changed the root level size-cells, but haven't updated the
> sub-nodes (such as /memory) accordingly.

 Thanks, we'll fix this in the next version of this patch.

>>       model = "amcc,katmai";
>>       compatible = "amcc,katmai";
>>       dcr-parent = <&{/cpus/cpu@0}>;
>> @@ -392,6 +392,30 @@
>>                               0x0 0x0 0x0 0x3 &UIC3 0xa 0x4 /* swizzled int C */
>>                               0x0 0x0 0x0 0x4 &UIC3 0xb 0x4 /* swizzled int D */>;
>>               };
>> +             DMA0: dma0 {

> No 'compatible' property, which seems dubious.

 OK, we'll fix.

>> +                     interrupt-parent = <&DMA0>;
>> +                     interrupts = <0 1>;
>> +                     #interrupt-cells = <1>;
>> +                     #address-cells = <0>;
>> +                     #size-cells = <0>;
>> +                     interrupt-map = <
>> +                             0 &UIC0 0x14 4
>> +                             1 &UIC1 0x16 4>;
>> +             };
>> +             DMA1: dma1 {
>> +                     interrupt-parent = <&DMA1>;
>> +                     interrupts = <0 1>;
>> +                     #interrupt-cells = <1>;
>> +                     #address-cells = <0>;
>> +                     #size-cells = <0>;
>> +                     interrupt-map = <
>> +                             0 &UIC0 0x16 4
>> +                             1 &UIC1 0x16 4>;

> Are these interrupt-maps correct?  The second interrupt from both dma
> controllers is routed to the same line on UIC1?

 The map is correct:

- first interrupts are 'DMAx Command Status FIFO Needs Service';
- second interrupt is 'DMA Error', both DMA engines share common error IRQ.


>> +             };
>> +             xor {
>> +                     interrupt-parent = <&UIC1>;
>> +                     interrupts = <0x1f 4>;

> What the hell is this thing?  No compatible property, nor even a
> meaningful name.

 This is the XOR accelerator, the dedicated DMA engine of ppc440spe 
equipped with the ability to do XOR operations in h/w. I guess, it 
could be named like DMA2.

 Regards, Yuri

 --
 Yuri Tikhonov, Senior Software Engineer
 Emcraft Systems, www.emcraft.com

