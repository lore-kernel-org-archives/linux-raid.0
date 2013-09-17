From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: LSI 9211 (SAS2008) BIOS problems, invalid PCI slot
Date: Tue, 17 Sep 2013 00:14:56 -0500
Message-ID: <5237E550.7090606@hardwarefreak.com>
References: <CAC38o7Q4R_qXdtfBv86cNkEq6bp-6GrtqYat2m=WW47Tc5D6aw@mail.gmail.com> <5237AFC2.7090807@hardwarefreak.com> <CAC38o7RW1NULs6WhSNTqiTr1Nu38QNy1vQTpHRNRfk4a3fKubw@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAC38o7RW1NULs6WhSNTqiTr1Nu38QNy1vQTpHRNRfk4a3fKubw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: P Orrifolius <porrifolius@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/16/2013 10:55 PM, P Orrifolius wrote:
> On 17 September 2013 13:26, Stan Hoeppner <stan@hardwarefreak.com> wrote:
>> On 9/15/2013 7:07 PM, P Orrifolius wrote:
...
> PCI Slot
> The PCI Slot number assigned by the System BIOS to an adapter.  If the
> value displayed is FF it indicates invalid slot number.

This is irrelevant, harmless.  The "PCI slot number" is assigned so a
human can find a card in a physical slot in the machine.  Cheap mobo
BIOS often doesn't assign slot numbers.  Enterprise targeted mobos and
vendor systems most certainly do.  Having a missing PCI slot number does
NOT affect the functionality of the card.  This is a convenience feature
only.  For more on this see:

"Core BIOS and BIOS configuration utility will display "FF" as the PCI
slot number when proper slot information is not available."

http://www-947.ibm.com/support/entry/portal/docdisplay?lndocid=MIGR-5090849

...
> I changed the controller Boot Support setting to Disabled and the
> Drive Spin-up Delay from 2 -> 0 after my failures, without touching
> any cabling.

When using the LSI controllers that have BIOS/firmware RAID and can boot
the system, it's always best to disable the controller BIOS to prevent
compatibility problems with the host BIOS.  If you aren't booting from a
drive on the LSI, disable the BIOS.

> And, lo!  On reboot the drive spun-up immediately and the controller
> detected it.  I booted into linux and it appeared as a sd? device.
> 
> Weird thing is I set the controller options back as they were yet the
> drive still spins-up... I swear I didn't touch the cabling.

Good, making some progress.  Keep in mind these enterprise HBAs are
designed primarily for SAS.  SCSI drives have supported spinup delay for
decades.  SATA drives often do not, or the implementation is poor.
Simply disabling the delay may be the key.

...
>  - If Boot Support is set to 'Disabled' or 'Enabled OS only' then the
> controller initialisation simply states Adapter(s) disabled.  Then the
> AHCI drive detection happens and linux boots.  Happily the connected
> drive is visible in linux.

So the problems are solved.  Good.

Note that enterprise RAID/HBA cards often cause problems with consumer
mobos because the latter vendors simply never do QC with such
aftermarket storage controllers.  LSI publishes an extensive list of
systems, server, and workstation mobos that have been tested with their
HBAs, including any errata for each, such as specific settings required
for the HBA to work.

> I can live with the mystery and I don't need to boot from drives
> connected to the controller, so my only questions really are:
> 
>  - will flashing be safe given the 'ff' business?

Flashing firmware, whether mobo or add in card, is never a guaranteed
proposition.  But any safety factor has nothing to do with slot number
assignment, which I explained above.  The flash program should find the
card without problems.  Whether the flash process is successful is
another matter.

That said, I highly recommend you do not flash the board with the
Initiator Target (IT) firmware.  The IT firmware simply removes RAID
capability, and adds support for SAS expanders and up to 256 connected
devices.  Other than that, AFA Linux is concerned, there is no
-functional- difference between the IR firmware in HBA (BIOS disabled)
mode, and the IT firmware.  If you do not plan to use an expander, don't
flash the board.  Just leave the BIOS disabled.

>  - will the controller being 'Disabled' lose me any capabilities
> beyond booting from controller connected devices?

The controller isn't disabled.  Only the BIOS and RAID firmware are
disabled.  You simply lose the firmware based RAID capability.  It
should be possible to boot a connected drive even with the RAID function
disabled.  Play with it some more.

-- 
Stan




