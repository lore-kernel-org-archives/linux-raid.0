From: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Subject: Re: [sucess?] upgrading LSI SAS9211-8i fw IR->IT
Date: Thu, 26 Oct 2017 14:31:33 +1100
Message-ID: <f268a7a1-6a73-8c9f-b4c8-1e8190f54850@eyal.emu.id.au>
References: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <08feefcc-14d0-e7ec-aa23-927ecbb63ac3@eyal.emu.id.au>
Content-Language: en-AU
Sender: linux-raid-owner@vger.kernel.org
To: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24/10/17 22:47, Eyal Lebedinsky wrote:
> [This is a resend, as plain text and with reduced size attachment...]
> 
> Following some excitement with my 4yo+ controller I acquires a new one.
> I now want to upgrade the fw from IR to IT.
> 
> I did some reading, which suggests the process is simple and straight forward - if I am lucky.
> The issue seems to be that the flashing program does not run on all mobos.
> 
> I think that my server (Intel BOXDH77KC) is not booting UEFI.
> Anyway, I plan to do the upgrade elsewhere, probably on my workstation (Gigabyte GA-G33M-DS2R).
> Both are rather old and will be upgraded within a year. I decided to give it a test.
> 
> I disconnected the (only) disk it has and installed the LSI controller.
> [No problem here except that using the on-board VGA video (until now I used an add-on video card)
> I see that the letters q-z do not show properly in FreeDOS, but are OK during POST]
> 
> I started reading here:
>     https://forums.servethehome.com/index.php?threads/tutorial-updating-ibm-m1015-lsi-9211-8i-firmware-on-uefi-systems.11462/
> where one needs to switch between UEFI and DOS mode. Probably unsuitable for me.
> 
> I then proceeded here
>     http://brycv.com/blog/2012/flashing-it-firmware-to-lsi-sas9211-8i/
> where the blog mentions some hurdles along the way.
> 
> I used files from two packages:
>     LSI-9211-8i.zip
>     9211-8i_Package_P20_IR_IT_FW_BIOS_for_MSDOS_Windows.zip
> 
> Booted OK from a FreeDOS 1.2 USB disk. Ran 'sas2flsh.exe -list' and got the attached screen.
> Seems to me that this worked. At least I did not get the
>       ERROR: Failed to initialize PAL. Exiting program.
> message, in which case I would need to use the efi mode flasher.
> 
> Q1) Does this mean that I am clear to proceed?
> 
> Now I am ready to do a flash erase followed by a flash program.
> However, LSI warns that a failure after the erase and before the program will leave a dead (unrecoverable) card.
> 
> Q2) How do I check that I can safely do BOTH steps?
> 
> TIA

I progressed slowly and I think that I finally succeeded.

1) Prepared a bootable USB disk (full FreeDOS 1.2)
2) Copied the required files to the USB disk.
3) Installed the LSI card in a PC after disconnecting all the disks
4) Booted from the USB and tried
	sas2flsh -list
    It worked.
5) Upgraded from fw IR 18 to IR 20
	sas2flsh -o -f 2118ir.bin -b mptsas2.rom
    It worked again, so now I was ready to attempt a flash clear and upgrade to IT
6) Cleared the flash
	sas2flsh -o -e 6
    After it said that it is clearing I got no more messages for over 10 minutes.
    This was my worst worry as the card would be bricked.
    ^C had no effect. Ctl-Alt-Del had no effect. The machine was deal.
    Is this proof that there IS a God?

[BTW, this machine was known to lock up at times, I thought it was the system (linux)
  but it now seems to be a more fundamental issue]

7) Re-booted from the USB and ran
	sas2flsh -list
    A message came up saying the card is not operational, but surprisingly
    it proceeded to say a firmware is required and asked for a file name.
    I entered '2118it.bin' and it succeeded in flashing it as a '-list' proved.

At the end I rebooted once more and all looked good. Naturally there is no BIOS
programmed (I could flash it but decided that the IT fw probably does not require it)
	Q1) is this correct?

Comparing the '-list' details before and after the process, on top of the new fw
(and no BIOS) I noticed that the "SAS Address" changed.
	Q2) Should I reconfigure the card with the original address with
		sas2flsh -o -sasadd 500605B-#-####-####
	    I assume it is only used as a global unique ID.

As a final test I plan to boot the actual server with this card and 3 sacrificial
disks (now all zeroed) attached, to confirm that nothing is written to the disks.

As an aside, I now do not see the text corruption I mentioned earlier, so it was
probably the BIOS causing it and not FreeDOS.

cheers

-- 
Eyal Lebedinsky (eyal@eyal.emu.id.au)
