From: "Marcin M. Jessa" <lists@yazzy.org>
Subject: Re: Linux raid autodetect partition disappears after RAID degrade
Date: Sun, 02 Oct 2011 19:13:15 +0200
Message-ID: <4E889BAB.7030705@yazzy.org>
References: <4E883769.2080402@yazzy.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E883769.2080402@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 10/02/2011 12:05 PM, Marcin M. Jessa wrote:
>
> Hi guys.
>
> My RAID array just kicked out one of the drives again at heavy activity
> running:
>  # ddrescue -n -f /dev/fridge/storage storage.img ddrescue.log
> where the /dev/fridge/storage LV Size is 4.88 TiB
>
> What's strange is the device is there:
>   brw-rw---- 1 root disk 8, 144 Oct  2 11:48 /dev/sdj
>
> But the /dev/sdj1 which should hold Linux raid autodetect partition
> just disappeared...
>
>  # fdisk -l /dev/sdj
>
> Disk /dev/sdj: 2000.4 GB, 2000398934016 bytes
> 255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
> Units = sectors of 1 * 512 = 512 bytes
> Sector size (logical/physical): 512 bytes / 512 bytes
> I/O size (minimum/optimal): 512 bytes / 512 bytes
> Disk identifier: 0x00000000
>
>    Device Boot      Start         End      Blocks   Id  System
> /dev/sdj1              63  3907029167  1953514552+  fd  Linux raid
> autodetect
>
>
> Is this a normal behavior? I don't understand either why the heck is
> the RAID degrading all the time ?
> I replaced all the cables with SATA3 cables, the BIOS is updated, both
> the motherboard and the drives are SATA3 and brand new.
>
> I could not find anything about the RAID being degraded or the device
> having problems in dmesg, /var/log/messages, /var/log/syslog or
> /var/log/kern.log
>
>
> I'm on Debian Wheezy
>  # uname -a
>  Linux odin 3.0.0-1-amd64 #1 SMP Sat Aug 27 16:21:11 UTC 2011 x86_64
> GNU/Linux
>

OK, this is strange, /dev/sdj shows a different End and Blocks  value
then all the other drives in the array.
Any idea why this would be happening and what  to do? Is that /dev/sdj
HD somehow unsafe and degraded?

 # fdisk -l /dev/sdj

Disk /dev/sdj: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdj1              63  3907029167  1953514552+  fd  Linux raid
autodetect

# fdisk -l /dev/sdk

Disk /dev/sdk: 2000.4 GB, 2000398934016 bytes
255 heads, 63 sectors/track, 243201 cylinders, total 3907029168 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sdk1              63  3907024064  1953512001   fd  Linux raid
autodetect

