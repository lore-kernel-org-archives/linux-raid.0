From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: converting to raid - Error 2
Date: Wed, 05 May 2010 20:49:26 -0700
Message-ID: <4BE23C46.20504@vorgon.com>
References: <4BDB4076.7010909@vorgon.com> <4BDB4358.80009@redhat.com> <4BDB5268.8050102@vorgon.com> <4BE19BEB.1040009@redhat.com> <4BE1B489.1050906@vorgon.com> <4BE205E4.8090308@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BE205E4.8090308@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 5/5/2010 4:57 PM, Doug Ledford wrote:
> On 05/05/2010 02:10 PM, Timothy D. Lenz wrote:
>
>>>> grub>   setup (hd0)
>>>>    Checking if "/boot/grub/stage1" exists... yes
>>>>    Checking if "/boot/grub/stage2" exists... yes
>>>>    Checking if "/boot/grub/e2fs_stage1_5" exists... yes
>>>>    Running "embed /boot/grub/e2fs_stage1_5 (hd0)"...  15 sectors are
>>>> embedded.
>>>> succeeded
>>>>    Running "install /boot/grub/stage1 (hd0) (hd0)1+15 p
>>>> (hd0,0)/boot/grub/stage2 /boot/grub/menu.l
>>>> st"... succeeded
>>>> Done.
>>>> ---------------------------------------
>
>>> Normally sda would be the one I would use, but sda1 would work as long
>>> as you have a normal DOS master boot record on the drive.
>>>
>
> A normal DOS master boot record is one that resides in the master boot
> record of the drive and that knows to chain load the next boot sector
> from the first sector of the partition that's marked active.  So, if you
> install a boot loader on sda1, you have to have the normal DOS master
> boot record in the master boot record of the drive.  Once you install
> grub on the bare drive (aka, on sda instead of sda1), you wipe out any
> other boot loader in the master boot record and replace it with a grub
> master boot record.  So, at this point you probably don't have a normal
> DOS master boot record (unless the grub one suffices but I don't think
> it does) and will need to make sure to install whatever new boot loader
> you install to sda versus sda1 or else it won't overwrite the previous
> grub master boot record.
>
>> I was thinking making one more try, but ether using su instead of sudo
>> or just logging in as root as some stuff doesn't seem to work with sudo.
>> Need to find the time when I'm home long enough with no interruptions to
>> try it:).
>
> Sudo versus su versus logging in as root shouldn't matter as long as
> whatever command you are running doesn't come back with some sort of
> error message.
>
>> Before I try the manual install, do you know what the "1+15 p" is in the
>> install line the auto system did?
>
> Prior to the install line that the setup macro does, it embedded the
> e2fs_stage1_5 on the disk between the partition table and the start of
> the first partition.  The (hd0)1+15 means to load sectors 1 through 15
> of (hd0) as the next stage in the boot loader.  The p is separate and
> merely means patch the block list for the next part of the boot loader
> into the previous part.  It can be omitted as grub does this anyway
> based upon the number of stages you specify.
>

Thank you for the reply and I should be able to follow it, but I think I 
get confused trying to follow it. Looks like you are saying I messed up 
the MBR.

First a bit of backing up a few post, you mentioned adding the "d" option:

-------------------------------------------------------------------
"install --stage2=/grub/stage2 /grub/stage1 (hd0) /grub/e2fs_stage1_5
/grub/stage2 /grub/grub.conf

and if that doesn't work in your particular configuration, you can add
the d option after stage1 and before (hd0), but if you use it, then your
boot disk must always be BIOS device 0x80, which means setting your BIOS
to boot off of some disk other than the first disk found usually won't
work and instead you just have to make whatever disk you want to boot
off of the first disk found by the BIOS."
-------------------------------------------------------------------

I want to avoid that because it would defeat one of the advantages of 
mirroring. Today the 32bit system, the one that I got converted seems to 
have started loosing sda after a shutdown restart, but it came up fine 
because it rolled over and booted on sdb. More about that down near the 
bottom and new possible complications with that...

-------------------------------------------------------------------
"You can switch (hd0) to (hd0,0) if you want and if you have a normal 
DOS master boot record."
-------------------------------------------------------------------

 From what I understand that would be the same as using sda1 instead of sda?

To use your install line, the instructions I had did the following:

  grub>device (hd0) /dev/sda
  grub>root (hd0,0)

first so that grub would treat the target drive as (hd0) for setting up 
boot information, maybe something to do with information in menu.lst 
which only points (hd0,0) as the boot device:


title		Debian GNU/Linux, kernel 2.6.25.9.20081002.1
root		(hd0,0)
kernel		/boot/vmlinuz-2.6.25.9.20081002.1 root=/dev/md0 ro quiet

title		Debian GNU/Linux, kernel 2.6.25.9.20081002.1 (single-user mode)
root		(hd0,0)
kernel		/boot/vmlinuz-2.6.25.9.20081002.1 root=/dev/md0 ro quiet single

I should still do that with your install command? I don't want to mess 
the current working boot drive or the system will no longer be bootable. 
Want to make sure it acts on the correct drive.

I got lost in the problems with the MBR. I used fdisk to set the first 
partition of each drive bootable. Do I need to mark them unbootable and 
then back again to fix the MBR or will the above install line fix it..

-------------------------------------------------------------------
The (hd0)1+15 means to load sectors 1 through 15
of (hd0) as the next stage in the boot loader.  The p is separate and
merely means patch the block list for the next part of the boot loader
into the previous part.  It can be omitted as grub does this anyway
based upon the number of stages you specify.
-------------------------------------------------------------------

To be clear, the "1+15" can also be omitted correct?
===============================================================

Now, 1 step forward, 4 back :(.  While waiting for a reply to my last 
post, I had a bit of time so thought I would just go ahead and try using 
su instead of sudo... Turned on the monitor and set the kvm to that 
computer and found:

   end_request: I/O error, dev fd0, sector 0

repeated 5 times on the screen. No idea why it started trying to read 
the floppy. Last reboot was Apr 28 19:16 and in the logs:

Apr 28 19:16:29 x64VDR kernel: EXT3-fs: mounted filesystem with ordered 
data mode.
Apr 28 19:16:29 x64VDR kernel: NET: Registered protocol family 10
Apr 28 19:16:34 x64VDR kernel: warning: `ntpd' uses 32-bit capabilities 
(legacy support in use)
Apr 28 19:16:35 x64VDR kernel: Clocksource tsc unstable (delta = 
-77401545 ns)
Apr 28 19:16:39 x64VDR kernel: eth0: no IPv6 routers present
Apr 30 14:53:38 x64VDR kernel: end_request: I/O error, dev fd0, sector 0
Apr 30 15:13:58 x64VDR kernel: end_request: I/O error, dev fd0, sector 0
Apr 30 16:30:30 x64VDR kernel: end_request: I/O error, dev fd0, sector 0
Apr 30 16:31:43 x64VDR kernel: end_request: I/O error, dev fd0, sector 0
Apr 30 17:02:30 x64VDR kernel: end_request: I/O error, dev fd0, sector 0
May  2 00:57:01 x64VDR kernel: md: data-check of RAID array md0

Good news, the array check on the 3 arrays seemed ok.

But I also found several entries of this in the user.log

   Apr 28 19:16:47 x64VDR usbmount[1388]: cannot read from /dev/sdd

Only time I know sdd is referenced is when I boot with the cd to copy 
sync from the working drive hda1 (which becomes sdd1) to the boot array 
md0, or the array I've been trying to get bootable. And it's talking 
about a usb device. Now I did plug a usb drive in some time back to copy 
data over, but that was unmounted and removed after the copy and the 
computer has been rebooted since then. yet I also find inthe current 
dmesg log:

scsi 6:0:0:0: Direct-Access     Generic  STORAGE DEVICE   9325 PQ: 0 ANSI: 0
sd 6:0:0:0: [sdd] Attached SCSI removable disk
usb-storage: device scan complete

The floppy drive is one of those combos with built in card readers which 
is connected to usb, but I never got that to work right. only time it 
would reconize when a card was plugged in or removed was when you also 
added ore removed a usb memory stick or drive... Strange and anoying.

Soooo, instead of try to make the array bootable again, I decided to 
check email... and have to nice little emails from the 32bit system that 
I was able to get booting on raid. Both said the same thing...

-------------------------------------------------------------------
From: mdadm monitoring <root>
subject: Fail event on /dev/md0:LLLx64-32

This is an automatically generated mail message from mdadm
running on LLLx64-32

A Fail event had been detected on md device /dev/md0.

It could be related to component device /dev/sda1.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
md1 : active raid1 sdb2[1] sda2[0]
       4891712 blocks [2/2] [UU]

md2 : active raid1 sdb3[1] sda3[2](F)
       459073344 blocks [2/1] [_U]

md0 : active raid1 sdb1[1] sda1[2](F)
       24418688 blocks [2/1] [_U]

unused devices: <none>
-------------------------------------------------------------------

I had shut it down to put a second ATSC tuner card in trying to track 
down another problem I've been fighting since I set it up. After it was 
up I noticed a high pitched wine, a little louder then is normal for WD 
drives, then it went away. have noticed it before from time to time, but 
not often. Guess this confirms a possible from another thread I had:

"possible bus loading problem during resync"

So now i get to figure out setting up a replacement drive and going 
through grub on that one again. Only, I started the update to grub 2 on 
that system. It's at the 1/2 way point of the change over. I was trying 
to find out exactly what to check for to be sure it would work if I 
finished the conversion and /boot/grub is full of .mod files. This 
should complicate getting that new drive setup.. :(
