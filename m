From: Yves Glodt <yg@mind.lu>
Subject: Re: Some raid1 questions
Date: Mon, 2 Feb 2004 23:28:07 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200402022328.12806.yg@mind.lu>
References: <200402011438.01880.yg@mind.lu> <24725.213.135.224.9.1075707187.squirrel@www.mind.lu> <16414.50602.162401.424505@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16414.50602.162401.424505@notabene.cse.unsw.edu.au>
Content-Description: clearsigned data
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

On Monday 02 February 2004 22:48, Neil Brown wrote:
> On Monday February 2, yg@mind.lu wrote:
> > Sorry for being unclear...
> > After an unclean shutdown, my raid always rebuilds, and the
> > filesystem never replays the journal. I just does not see that it
> > was not properly unmounted.
>
> That is certainly odd.  Are you sure that is what is happening?
> There are two ways that the journal can be replayed:
>    1/ fsck can replay it or
>    2/ ext3 in the kernel can replay it.
>
> The former will not appear in any logs and will only be seen if you
> watch the boot-time messages go past.  The latter will cause a kernel
> message to be logged.
>
> Were you watching for fsck messages, or only looking in logs?

I was watching the boot messages. I use the "quiet" kernel parameter, so 
the first thing I really saw was that the raid complained about not 
being clean.
But, now I checked my /var/log/messages, and I saw that in about 4 of 5 
times when I had a freeze, on the next boot, the ext3 driver seemed to 
recover something, look at this:

Jan 27 17:45:40 Valhalla kernel: md: autorun ...
Jan 27 17:45:40 Valhalla kernel: md: considering hdc2 ...
Jan 27 17:45:40 Valhalla kernel: md:  adding hdc2 ...
Jan 27 17:45:40 Valhalla kernel: md:  adding hda2 ...
Jan 27 17:45:40 Valhalla kernel: md: created md0
Jan 27 17:45:40 Valhalla kernel: md: bind<hda2,1>
Jan 27 17:45:40 Valhalla kernel: md: bind<hdc2,2>
Jan 27 17:45:40 Valhalla kernel: md: running: <hdc2><hda2>
Jan 27 17:45:40 Valhalla kernel: md: hdc2's event counter: 00001115
Jan 27 17:45:40 Valhalla kernel: md: hda2's event counter: 00001115
Jan 27 17:45:40 Valhalla kernel: md: RAID level 1 does not need 
chunksize! Continuing anyway.
Jan 27 17:45:40 Valhalla kernel: md: raid1 personality registered as nr 
3
Jan 27 17:45:40 Valhalla kernel: md0: max total readahead window set to 
124k
Jan 27 17:45:40 Valhalla kernel: md0: 1 data-disks, max readahead per 
data-disk: 124k
Jan 27 17:45:40 Valhalla kernel: raid1: device hdc2 operational as 
mirror 1
Jan 27 17:45:40 Valhalla kernel: raid1: device hda2 operational as 
mirror 0
Jan 27 17:45:40 Valhalla kernel: raid1: raid set md0 not clean; 
reconstructing mirrors
Jan 27 17:45:40 Valhalla kernel: raid1: raid set md0 active with 2 out 
of 2 mirrors
Jan 27 17:45:40 Valhalla kernel: md: updating md0 RAID superblock on 
device
Jan 27 17:45:40 Valhalla kernel: md: hdc2 [events: 00001116]<6>(write) 
hdc2's sb offset: 29302464
Jan 27 17:45:40 Valhalla kernel: md: syncing RAID array md0
Jan 27 17:45:40 Valhalla kernel: md: minimum _guaranteed_ reconstruction 
speed: 100 KB/sec/disc.
Jan 27 17:45:40 Valhalla kernel: md: using maximum available idle IO 
bandwith (but not more than 100000 KB/sec) for reconstruction.
Jan 27 17:45:40 Valhalla kernel: md: using 124k window, over a total of 
29302464 blocks.
Jan 27 17:45:40 Valhalla kernel: md: hda2 [events: 00001116]<6>(write) 
hda2's sb offset: 29302464
Jan 27 17:45:40 Valhalla kernel: md: ... autorun DONE.
Jan 27 17:45:40 Valhalla kernel: kjournald starting.  Commit interval 5 
seconds
Jan 27 17:45:40 Valhalla kernel: EXT3 FS 2.4-0.9.19, 19 August 2002 on 
md(9,0), internal journal
Jan 27 17:45:40 Valhalla kernel: EXT3-fs: recovery complete.
Jan 27 17:45:40 Valhalla kernel: EXT3-fs: mounted filesystem with 
writeback data mode.







So it seems that the filesystem is recovering (in 4 of 5 times):
Here the example where it did not:

Jan 19 18:57:49 Valhalla kernel: md: autorun ...
Jan 19 18:57:49 Valhalla kernel: md: considering hdc2 ...
Jan 19 18:57:49 Valhalla kernel: md:  adding hdc2 ...
Jan 19 18:57:49 Valhalla kernel: md:  adding hda2 ...
Jan 19 18:57:49 Valhalla kernel: md: created md0
Jan 19 18:57:49 Valhalla kernel: md: bind<hda2,1>
Jan 19 18:57:49 Valhalla kernel: md: bind<hdc2,2>
Jan 19 18:57:49 Valhalla kernel: md: running: <hdc2><hda2>
Jan 19 18:57:49 Valhalla kernel: md: hdc2's event counter: 000010f8
Jan 19 18:57:49 Valhalla kernel: md: hda2's event counter: 000010f8
Jan 19 18:57:49 Valhalla kernel: md: RAID level 1 does not need 
chunksize! Continuing anyway.
Jan 19 18:57:49 Valhalla kernel: md: raid1 personality registered as nr 
3
Jan 19 18:57:49 Valhalla kernel: md0: max total readahead window set to 
124k
Jan 19 18:57:49 Valhalla kernel: md0: 1 data-disks, max readahead per 
data-disk: 124k
Jan 19 18:57:49 Valhalla kernel: raid1: device hdc2 operational as 
mirror 1
Jan 19 18:57:49 Valhalla kernel: raid1: device hda2 operational as 
mirror 0
Jan 19 18:57:49 Valhalla kernel: raid1: raid set md0 not clean; 
reconstructing mirrors
Jan 19 18:57:49 Valhalla kernel: raid1: raid set md0 active with 2 out 
of 2 mirrors
Jan 19 18:57:49 Valhalla kernel: md: updating md0 RAID superblock on 
device
Jan 19 18:57:49 Valhalla kernel: md: hdc2 [events: 000010f9]<6>(write) 
hdc2's sb offset: 29302464
Jan 19 18:57:49 Valhalla kernel: md: syncing RAID array md0
Jan 19 18:57:49 Valhalla kernel: md: minimum _guaranteed_ reconstruction 
speed: 100 KB/sec/disc.
Jan 19 18:57:49 Valhalla kernel: md: using maximum available idle IO 
bandwith (but not more than 100000 KB/sec) for reconstruction.
Jan 19 18:57:49 Valhalla kernel: md: using 124k window, over a total of 
29302464 blocks.
Jan 19 18:57:49 Valhalla kernel: md: hda2 [events: 000010f9]<6>(write) 
hda2's sb offset: 29302464
Jan 19 18:57:49 Valhalla kernel: md: ... autorun DONE.
Jan 19 18:57:49 Valhalla kernel: kjournald starting.  Commit interval 5 
seconds
Jan 19 18:57:49 Valhalla kernel: EXT3 FS 2.4-0.9.19, 19 August 2002 on 
md(9,0), internal journal
Jan 19 18:57:49 Valhalla kernel: EXT3-fs: mounted filesystem with 
writeback data mode.






Ok, I guess the filesystem just behaves fine, well but still I wonder if 
it's "normal" that the raid reconstructs also after *every* unclean 
shutdown.
thank you for your support,
Yves


> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

- -- 
Linux 2.4.24 #5 Mon Jan 5 19:38:06 CET 2004 i686
 23:03:40 up  4:54,  1 user,  load average: 0.02, 0.08, 0.15
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFAHs78fmxiTOp0sQYRAgc4AJ4orJbkdYopVysZo7nq1f9hGhz9bgCeKjQX
or6pSSaGIeJFsTAqqw1Gg3o=
=6287
-----END PGP SIGNATURE-----

