From: Christian Schmit <cschmit@vo.lu>
Subject: Re[4]: RH 7.3 raid1 setup
Date: Mon, 3 Jun 2002 19:03:47 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <169640920625.20020603190347@vo.lu>
References: <Pine.LNX.3.96.1020603053217.19266A-100000@Maggie.Linux-Consulting.com>
Reply-To: Christian Schmit <cschmit@vo.lu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.3.96.1020603053217.19266A-100000@Maggie.Linux-Consulting.com>
To: Alvin Oga <aoga@Maggie.Linux-Consulting.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi alvin,

I got it working by disconnecting the 1st disk
and then booting from cd in linux rescue mode
with the 2nd disk.

I mounted the "/" partition on the disk and
launched grub. Here I issued root (hd0,0) and
setup(hd1) to install grub in the mbr.

After this I can boot fine from both disks.

Christian





AO> hi ya christian

AO> looks okay too me... not that i played with grub too much but..

AO> make a boot floppy so that we can recover if my experiment fails ...

AO>         dd=/vmlinuz-2.4.18-3  of=/dev/fd0 bs-1204

AO>         ( or make a boot flop w/ syslinux
AO>         http://www.Linux-Consulting.com/Boot/boot.flop.syslinux.txt

AO>         ( test that you can boot from floppy )
AO>         ( you'll see lots of "...." on the screen as it boot

AO>         - should also work even if hda or hdc is disconnected

AO> than comment out initrd in your grub.conf and "re-run/re-initialize" grub

AO>         - that'd be my guess of why if you disconnect hda that the system
AO>         wont boot
AO>         - am guessing that the kernel that is in the initrd is NOT able
AO>         to support raid1

AO> - if its not the initrd.. ( guess i better go play with grub too one day )

AO> - interesting problem... :-)

AO> thanx
AO> alvin


>> grub.conf:
>> -----------
>> default=0
>> timeout=10
>> splashimage=(hd0,0)/grub/splash.xpm.gz
>> title Red Hat Linux (2.4.18-3)
>>         root (hd0,0)
>>         kernel /vmlinuz-2.4.18-3 ro root=/dev/md2
>>         initrd /initrd-2.4.18-3.img
>> 
>> 
>> Partitions:
>> ------------
>> 
>> Disk /dev/hda: 255 heads, 63 sectors, 5005 cylinders
>> Units = cylinders of 16065 * 512 bytes
>> 
>>    Device Boot    Start       End    Blocks   Id  System
>> /dev/hda1   *         1        45    361431   fd  Linux raid autodetect
>> /dev/hda2            46       810   6144862+  fd  Linux raid autodetect
>> /dev/hda3           811      1065   2048287+  fd  Linux raid autodetect
>> 
>> Disk /dev/hdc: 255 heads, 63 sectors, 5005 cylinders
>> Units = cylinders of 16065 * 512 bytes
>> 
>>    Device Boot    Start       End    Blocks   Id  System
>> /dev/hdc1   *         1        45    361431   fd  Linux raid autodetect
>> /dev/hdc2            46       810   6144862+  fd  Linux raid autodetect
>> /dev/hdc3           811      1065   2048287+  fd  Linux raid autodetect
>> 

