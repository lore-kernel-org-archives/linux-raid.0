From: P Orrifolius <porrifolius@gmail.com>
Subject: Re: LSI 9211 (SAS2008) BIOS problems, invalid PCI slot
Date: Tue, 17 Sep 2013 15:55:57 +1200
Message-ID: <CAC38o7RW1NULs6WhSNTqiTr1Nu38QNy1vQTpHRNRfk4a3fKubw@mail.gmail.com>
References: <CAC38o7Q4R_qXdtfBv86cNkEq6bp-6GrtqYat2m=WW47Tc5D6aw@mail.gmail.com>
	<5237AFC2.7090807@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5237AFC2.7090807@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 17 September 2013 13:26, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 9/15/2013 7:07 PM, P Orrifolius wrote:

The executive summary:

Connected drive now being detected and made available in linux.  But
the PCI Slot is still being listed as 'ff' and boot fails with some
controller settings.

More details below.

>> I can enter the LSI configuration utility during the controller boot
>> process and I see that it has a PCI slot of 'ff' which, according to
>> the utility, indicates an invalid PCI slot.
>
> Invalid in what way?  The motherboard assigns PCI resources to expansion
> boards, not the other way round.  So I'm curious as to what the board is
> saying is invalid about the PCI slot configuration.

If I highlight the 'ff' value for PCI Slot in the configuration
utility and then hit F1 (Help) it says:

PCI Slot
The PCI Slot number assigned by the System BIOS to an adapter.  If the
value displayed is FF it indicates invalid slot number.

I can't find any information about it, other than this comment to a
post: http://www.servethehome.com/howto-flash-supermicro-x8si6f-lsi-sas-2008-controller-lsi-firmware/#comment-30607

> Do the drives show up under the device identifier, such as in this img:
> http://i.imgur.com/weKsd.jpg

No.

> If you have a drive connected and powered up it should show up in the
> LSI BIOS config util as above, and should also be enumerated by the LSI
> boot BIOS during the POST sequence.  If the drive isn't showing up in
> the controller utility then you likely have:
>
> 1.  Bad or not fully connected data or power cable(s)
> 2.  Bad drive
> 3.  Bad HBA

I connected the drive direct to the motherboard and it works fine.

I connected the drive to the controller via different SATA breakouts,
different 8087->4xSATA cables and different ports on the controller...
still no dice.

In every case I could tell by touch that the drive wasn't spinning up.


However...

I changed the controller Boot Support setting to Disabled and the
Drive Spin-up Delay from 2 -> 0 after my failures, without touching
any cabling.

And, lo!  On reboot the drive spun-up immediately and the controller
detected it.  I booted into linux and it appeared as a sd? device.

Weird thing is I set the controller options back as they were yet the
drive still spins-up... I swear I didn't touch the cabling.


So current status is:
 - Controller, and detected connected drive, reports PCI Slot ff which
is, it claims, invalid.

 - When the controller Boot Support is set to 'Enabled BIOS and OS' or
'Enabled BIOS only' the AHCI drive detection on boot takes ages then
eventually outputs 'Warning - something wrong with your hardware!'
Hard reset is then needed.  This prevents linux booting of course.
The connected drive is detected and listed after the controller
initialises. Presumably the MPT2 boot ROM that the controller says it
installed doesn't work well with my motherboard.

 - If Boot Support is set to 'Disabled' or 'Enabled OS only' then the
controller initialisation simply states Adapter(s) disabled.  Then the
AHCI drive detection happens and linux boots.  Happily the connected
drive is visible in linux.


I can live with the mystery and I don't need to boot from drives
connected to the controller, so my only questions really are:

 - will flashing be safe given the 'ff' business?

and

 - will the controller being 'Disabled' lose me any capabilities
beyond booting from controller connected devices?


Thanks.
