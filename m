From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: Growing array, duplicating data, shrinking array questions.
Date: Tue, 3 Dec 2013 18:15:14 +0000
Message-ID: <BLU0-SMTP122E4AB9F76CD51C2F7AD5A98D50@phx.gbl>
References: <BLU0-SMTP1655B70AE4DF50100E9817198E10@phx.gbl>
	 <BLU0-SMTP228AF830EE9F7252DAE2AFF98E80@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP228AF830EE9F7252DAE2AFF98E80@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


> 
> Now for a huge problem...
> 
> My system is a "bios" not a "UEFI" and as such it, within the bios, does
> not report the disk sizes correctly, says is about 700GB (can't be exact
> without rebooting)... however to my surprise linux sees the whole disk
> as 3TB, I partitioned it using gptfdisk, then created a number of ext4
> file systems, filled them up with real files, ran fsck tests, zeroed out
> the highest partition, re-fsck'd the lower partitions and all seemed ok.

Did some further checks by tar>tar'ing across from my raid partition to
a single partition ext4 on the 3tb drive, then running diff, then
updating (editing different files manually on both the 3tb and 4tb raid)
a few files and re-running diff, which reported the changes correctly.

I'm now happy that linux sees the 3tb drive correctly and is not
mangling data silently.

> 
> ___question 1___
> (it should be noted that I was concerned that if the bios miss-reported
> the size and linux saw the whole disk I was worried that perhaps some
> overlapping mapping might have been going on, say the first partition,
> low on the disk, was somehow mapped into the last (700GB) of the disk..
> I'm guessing, and its a big guess, that once the bios has turned over
> control to linux then linux no longer uses the bios (or its hooks) to
> access the HD and instead goes to it directly, would this be a correct
> "guess"?)

It turns out that linux does indeed ignore the bios, it still uses a few
aspects of it, such as power/suspend/sleep, but on the whole it uses
(from what I've read in my limited understanding) protected mode drivers
that hit the hardware in a more direct manner... in my case the ICH10
(no R) and the drives themselves, again from what I've read ICH9 (not
sure if a revision involved) and above, ie. ICH10, are quite happy to
see and use disks greater than 2.2tb even if the bios miss-reports the
size.

> 
> Now here is where I know/think I have a big problem with a 3tb drive in
> a "bios" system and need confirmation before going any further...
> 
> ___question 2___
> I'm guessing that as the bios can only see the tail end of the hard
> drive it would not be able to load the data from the "mbr" (still there
> despite being a GPT formatted disk) and proceed to load the first stage
> boot loader because it will think the "mbr" should be at the start of
> the "700GB" which in reality is 2.2TB into the disk, would this be a
> correct assumption? (
> 
> Actually I could probably test this by installing
> (grub-install /dev/sdX) then going into the bios and telling it to boot
> from that disk while the original boot drives (containing
> biosboot /boot /root) were still pluged in, if it failed then I know its
> not going to work.

I've concluded that I'm going to have to create some form of work around
as the bios cannot load the mbr from the 3tb drive, and then the grub2
stuff in the bios boot partition which can then load additional grub2
stuff from the /boot partition.

> 
> ___question 3___
> If it does not work, but linux can see and use the drive with no
> problems, then is it possible to install the first (possibly second, i'm
> guessing thats what gets put in the "biosboot" partiton) stage grub2
> boot loaders to a USB drive, then have this load the rest of the system
> "/boot" partition from the new 3tb drives or if not possible then
> include the "/boot" on the usb drive as its only 200M its not a
> hardship, if I "raid" it to the existing partitions then any changes
> will be replicated, and should the usb fail I can just boot a system
> rescue disk make a new usb boot, copy the "/boot" from the hard drive
> and away we go.
> 
> ___question 4___
> I guess instead of using a USB, I could use the DVD drive, create a
> first/second stage loader onto it that will then chain into the hd to
> load the linux kernel.. is this possible?
> 
> I guess my last question is related to q3/q4 and that is... if its
> possible then is there a simple set of commands required, my initial
> thoughts are "grub-install" to the usb stick, as it will know to load
> from "the first drive" and as I will replicate, mirror, "/boot" (as well
> as "/") on the first 4 drives... if it fails then the second one will
> become the first so will be found by grub and so on...
> 

From what I can tell, the simplest way would be to make sure that grub2
is using strictly uuid's and not "disk notation" (on my pc booting from
a usb stick, or as I recall just leaving one in during boot, seems to
make the usb "sda" pushing the real disks higher up the chain, b-c-etc.
but I will need to double check that) then make the "/boot" partition on
the USB a member of the raid "/boot" partition held on the hard drives
(currently on a,b) then perform the usual grub-install to the usb stick,
which will update the mbr and put the required data into the bios-boot
partition of the usb stick (in the same way I had to grub=install
to /dev/sda and /dev/sdb)...

This will mean any changes to "boot" will be replicated across all
potential boot devices (even if the bios cant load from the 3tb
drive(s)) and as the bios can boot from the usb and is using uuid
notation it should in theory load and run the kernels from the hard
drives no matter how they are "numbered."

I guess the only "gotcha" I can see from this, is if I pull the usb
stick and re-insert it and forget to then re-add "/boot" back into the
raid1 and it becomes stale then I wonder what would happen then, would
it use the /boot on the usb, or the /boot on the disk drives... although
I guess because it "insmod" raid & mdraid1x it actually performs a
mdraid assemble/start and, tho I dont use it, because it can start
raid6rec and lvm it does actually start it, which would mean it would
always get the most up to date raid status no matter how stale the
"usb /boot" became, which then leads me to think I don't even need it on
the usb as the only important stuff (modules/etc) is put/compiled into
the biosboot partition... wow this stuff can do your head in :-/


> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


