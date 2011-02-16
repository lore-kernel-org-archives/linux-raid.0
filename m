From: Simon McNair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 21:28:22 +0000
Message-ID: <4D5C4176.80604@gmail.com>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown> <4D5A92F3.1090004@turmel.org> <4D5BD678.2050200@gmail.com> <4D5BE119.7000804@turmel.org> <4D5C0E17.3060306@gmail.com> <4D5C140F.9010301@turmel.org> <4D5C1508.3040308@gmail.com> <4D5C15D3.1070608@turmel.org> <4D5C167C.7000101@turmel.org> <4D5C1CF8.1020507@gmail.com> <4D5C1E0B.9060300@turmel.org> <4D5C2061.4060106@gmail.com> <4D5C2143.3000907@turmel.org> <4D5C2260.3020800@gmail.com> <4D5C273E.7020609@turmel.org>
Reply-To: simonmcnair@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C273E.7020609@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Phil,
Jeez I'm having a bad week (my windows 7x64 machine has just started 
randomly crashing, my Thecus n5200 is playing up and the weather has 
been dire so I've not been able to put my new shed up...oh and I have 
ongoing 'other' issues as you're well aware ;-))  The thecus n5200 has 
5x2TB hdd's.  I wiped out the existing raid5 array to create a jbod span 
of 10tb in order to hold my 9tb of backups.  The Thecus has had a hissy 
fit and I've had to set the process off again, so you can bet it'll be a 
day or two before it get's the drives formatted (it's not a very 
powerful nas), then I'll do the backups, then I'll try as you suggested.

Thanks for the ongoing assistance.

Simon

On 16/02/2011 19:36, Phil Turmel wrote:
> On 02/16/2011 02:15 PM, Simon McNair wrote:
>> proxmox:/home/simon# vgscan --verbose
>>      Wiping cache of LVM-capable devices
>>      Wiping internal VG cache
>>    Reading all physical volumes.  This may take a while...
>>      Finding all volume groups
>>      Finding volume group "pve"
>>    Found volume group "pve" using metadata type lvm2
>>      Finding volume group "lvm-raid"
>>    Found volume group "lvm-raid" using metadata type lvm2
>> proxmox:/home/simon#
>> proxmox:/home/simon# lvscan --verbose
>>      Finding all logical volumes
>>    ACTIVE            '/dev/pve/swap' [11.00 GB] inherit
>>    ACTIVE            '/dev/pve/root' [96.00 GB] inherit
>>    ACTIVE            '/dev/pve/data' [354.26 GB] inherit
>>    inactive          '/dev/lvm-raid/RAID' [8.19 TB] inherit
>>
>> proxmox:/home/simon# vgchange -ay
>>    3 logical volume(s) in volume group "pve" now active
>>    1 logical volume(s) in volume group "lvm-raid" now active
> Heh.  Figures.
>
>> proxmox:/home/simon# fsck.ext4 -n /dev/mapper/lvm-raid-RAID
> Actually, I wanted you to try with a capital N.  Lower case 'n' is similar, but not quite the same.
>
>> e2fsck 1.41.3 (12-Oct-2008)
>> fsck.ext4: No such file or directory while trying to open /dev/mapper/lvm-raid-RAID
>>
>> The superblock could not be read or does not describe a correct ext2
>> filesystem.  If the device is valid and it really contains an ext2
>> filesystem (and not swap or ufs or something else), then the superblock
>> is corrupt, and you might try running e2fsck with an alternate superblock:
>>      e2fsck -b 8193<device>
>>
>> proxmox:/home/simon# fsck.ext4 -n /dev/mapper/
>> control         lvm--raid-RAID  pve-data        pve-root        pve-swap
> Strange.  I guess it does that to distinguish dashes in the VG name from dashes between VG and LV names.
>
>> proxmox:/home/simon# fsck.ext4 -n /dev/mapper/lvm--raid-RAID
>> e2fsck 1.41.3 (12-Oct-2008)
>> /dev/mapper/lvm--raid-RAID has unsupported feature(s): FEATURE_I31
>> e2fsck: Get a newer version of e2fsck!
>>
>> my version of e2fsck always worked before ?
> v1.41.14 was release 7 weeks ago.  But, I suspect there's corruption in the superblock.  Do you still have your disk images tucked away somewhere safe?
>
> If so, try:
>
> 1) The '-b' option to e2fsck.  We need to experiment with '-n -b offset' to find the alternate superblock.  Trying 'offset' = to 8193, 16384, and 32768, per the man-page.
>
> 2) A newer e2fsprogs.
>
> Finally,
> 3) mount -r /dev/lvm-raid/RAID /mnt/whatever
>
> Phil
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
