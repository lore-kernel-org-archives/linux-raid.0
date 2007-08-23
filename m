From: "Greg Nicholson" <d0gz.net@gmail.com>
Subject: Re: Raid5 Reshape gone wrong, please help
Date: Thu, 23 Aug 2007 10:06:50 -0500
Message-ID: <c92bcddf0708230806m4da9466dod5f38409b2d13dfc@mail.gmail.com>
References: <c92bcddf0708171826n5991b3ffw1094e0e8c44c97e8@mail.gmail.com>
	 <18118.46141.966406.577626@notabene.brown>
	 <c92bcddf0708180837y4d92d2b4x3a4308e77b515ab3@mail.gmail.com>
	 <18120.9950.578786.624453@notabene.brown>
	 <c92bcddf0708190845k485a8460q609b16a8795bc288@mail.gmail.com>
	 <c92bcddf0708191944x4aab7770ga6815210109dca6f@mail.gmail.com>
	 <c92bcddf0708201909w2534c25du6282fd661ed838f5@mail.gmail.com>
	 <c92bcddf0708230804g2e3fb7ev4e5d1a13814d4d0f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c92bcddf0708230804g2e3fb7ev4e5d1a13814d4d0f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/23/07, Greg Nicholson <d0gz.net@gmail.com> wrote:
> <Trimming tons of detail, but keeping the thread>
>
> OK.... I've reproduced the original issue on a seperate box.
> 2.6.23-rc3 does not like to grow Raid 5 arrays.  MDadm 2.6.3
>
> mdadm --add /dev/md0 /dev/sda1
> mdadm -G --backup-file=/root/backup.raid.file /dev/md0
>
> (Yes, I added the backup-file this time... just to be sure.)
>
> Mdadm began the grow, and stopped in the critical section, or right
> after creating the backup... Not sure which.  Reboot.
>
> Refused to start the array.  So...
>
>  mdadm -A /dev/md0 /dev/sd[abdefg]1
>
> and we have in /proc/mdstat:
>
> Personalities : [raid6] [raid5] [raid4]
> md0 : active raid5 sdg1[0] sda1[5] sdf1[4] sdd1[3] sdb1[2] sde1[1]
>       1953535488 blocks super 0.91 level 5, 128k chunk, algorithm 2
> [6/6] [UUUUUU]
>       [>....................]  reshape =  0.0% (512/488383872)
> finish=378469.4min speed=0K/sec
>
> unused devices: <none>
>
> And it's sat there without change for the past 2 hours.  Now, I have a
> backup, so frankly, I'm about to blow away the array and just recreate
> it, but I thought you should know.
>
> I've got the stripe_cache_size at 8192... 256 and 1024 don't change anything.
>

Forgot the DMESG output:

md: bind<sde1>
md: bind<sdb1>
md: bind<sdd1>
md: bind<sdf1>
md: bind<sda1>
md: bind<sdg1>
md: md0: raid array is not clean -- starting background reconstruction
raid5: reshape will continue
raid5: device sdg1 operational as raid disk 0
raid5: device sda1 operational as raid disk 5
raid5: device sdf1 operational as raid disk 4
raid5: device sdd1 operational as raid disk 3
raid5: device sdb1 operational as raid disk 2
raid5: device sde1 operational as raid disk 1
raid5: allocated 6293kB for md0
raid5: raid level 5 set md0 active with 6 out of 6 devices, algorithm 2
RAID5 conf printout:
 --- rd:6 wd:6
 disk 0, o:1, dev:sdg1
 disk 1, o:1, dev:sde1
 disk 2, o:1, dev:sdb1
 disk 3, o:1, dev:sdd1
 disk 4, o:1, dev:sdf1
 disk 5, o:1, dev:sda1
...ok start reshape thread
md: reshape of RAID array md0
md: minimum _guaranteed_  speed: 1000 KB/sec/disk.
md: using maximum available idle IO bandwidth (but not more than
200000 KB/sec) for reshape.
md: using 128k window, over a total of 488383872 blocks.

Looks good, but it doesn't actually do anything.
