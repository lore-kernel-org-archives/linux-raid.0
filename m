From: Micah Anderson <micah@riseup.net>
Subject: Re: Unable to read superblock
Date: Thu, 18 Jul 2002 16:58:47 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020718235847.GG25867@riseup.net>
References: <20020718033404.GR17829@riseup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20020718033404.GR17829@riseup.net>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some addition information if it helps:

Both disks are partitioned the same:

Disk /dev/hda: 255 heads, 63 sectors, 5004 cylinders
Units = cylinders of 16065 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1             1         1      8001    1  FAT12
/dev/hda2   *         2         2      8032+  fd  Linux raid autodetect
/dev/hda3             3        20    144585   fd  Linux raid autodetect
/dev/hda4            21      5005  40042012+   5  Extended
/dev/hda5            21        29     72261   fd  Linux raid autodetect
/dev/hda6            30       210   1453851   fd  Linux raid autodetect
/dev/hda7           211       392   1461883+  fd  Linux raid autodetect
/dev/hda8           393       423    248976   82  Linux swap
/dev/hda9           424      4975  36563908+  fd  Linux raid autodetect
/dev/hda10         4976      5005    240943+  fd  Linux raid autodetect

On Wed, 17 Jul 2002, Micah Anderson wrote:

> I'm confused, I've done this hundreds of times, but for some reason it
> doesn't work now, I must be missing something, can someone poke me in
> the eye with it?
> 
> I've currently got 2.2.20 with raid-1 devices booting fine:
> 
> Filesystem           1k-blocks      Used Available Use% Mounted on
> /dev/md5                139945     28617    104103  22% /
> /dev/md0                  7683      4253      3034  58% /boot
> /dev/hda5                69904        15     66280   0% /tmp
> /dev/md4               1430864    933128    425048  69% /usr
> /dev/md3               1438768    392848    972832  29% /var
> /dev/md2              35990024   3980340  30181492  12% /var/spool
> /dev/md1                233225    160199     60985  72% /home
> 
> cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid5] [translucent] 
> read_ahead 1024 sectors
> md0 : active raid1 hdc2[0] hda2[1] 7936 blocks [2/2] [UU]
> md5 : active raid1 hdc3[0] hda3[1] 144512 blocks [2/2] [UU]
> md6 : active raid1 hdc5[0] hda5[1] 72192 blocks [2/2] [UU]
> md4 : active raid1 hdc6[0] hda6[1] 1453760 blocks [2/2] [UU]
> md3 : active raid1 hdc7[0] hda7[1] 1461760 blocks [2/2] [UU]
> md2 : active raid1 hdc9[0] hda9[1] 36563840 blocks [2/2] [UU]
> md1 : active raid1 hdc10[0] hda10[1] 240832 blocks [2/2] [UU]
> unused devices: <none>
> 
> I had lilo set for:
> 
> boot=/dev/md0
> root=/dev/md5
> image=/boot/vmlinuz-2.2.20RAID
>         label=RAID
>         read-only
>         alias=4
> 		
> When I installed 2.4.18, all of a sudden I can't boot, EXT2-fs: unable
> to read superblock. Yes, I selected all the RAID options on kernel
> compile.
> 
> What the heck?
> 
> Ok, so I think it is a lilo problem, I wanted to toss lilo and put
> grub on anyway:
> 
> My grub is set for:
> kernel (hd0,1)/vmlinuz-2.2.20RAID root=/dev/md5
> 
> If I have grub set to:
> 
> kernel (hd0,1)/vmlinuz-2.4.18 root=/dev/md5
> 
> again with the unable to read superblock stuff....
> 
> if I have it set to:
> kernel (hd0,1)/vmlinuz-2.4.18 root=/dev/hda3
> 
> request module [block major 3]: root fs not mounted
> cannot open root device hda3
> please append correct root= boot option
> 
> AGGGH?!
> 
> Thanks,
> Micah
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
