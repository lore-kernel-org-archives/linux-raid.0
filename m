From: Alexander Rietsch <Alexander.Rietsch@hispeed.ch>
Subject: Re: RAID 5 re-add of removed drive? (failed drive replacement)
Date: Tue, 2 Jun 2009 16:24:10 +0200
Message-ID: <49F571CD-BD24-4F22-B13B-CF6B0E24FFD5@hispeed.ch>
References: <20090602111729.GA15172@cthulhu.home.robinhill.me.uk> <C840D176-51A0-4AFD-8AD0-1F1D2CAA830D@hispeed.ch> <20090602131037.GB15172@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090602131037.GB15172@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Robin Hill <robin@robinhill.me.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02.06.2009, at 15:10, Robin Hill wrote:

> Almost - you'll also need to specify "missing" for disc 6 (and the
> --assume-clean isn't actually needed in this case, as the array  
> can't do
> any reconstruction with a missing drive), so:
>
>    mdadm --create /dev/md0 --level=5 --chunk=64 --raid-devices=7
>    /dev/sdi1 /dev/sdl1 /dev/sdh1 /dev/sdj1 /dev/sdk1 /dev/sdg1 missing

Yes, that's it! The RAID is alive! Mr. Robin Hill, you're a HERO!

With this trick, it's possible to recover a RAID which was confused by  
a data error during disk-replacement. I'll note this somewhere.

Here's the log of the creation command for completeness:

[root@localhost ~]# mdadm --create /dev/md0 --assume-clean --level=5 -- 
chunk=64 --raid-devices=7 --spare-devices=0 /dev/sdi1 /dev/sdl1 /dev/ 
sdh1 /dev/sdj1 /dev/sdk1 /dev/sdg1 missing
mdadm: /dev/sdi1 appears to be part of a raid array:
     level=raid5 devices=7 ctime=Sun Nov  2 13:21:54 2008
mdadm: /dev/sdl1 appears to be part of a raid array:
     level=raid5 devices=7 ctime=Sun Nov  2 13:21:54 2008
mdadm: /dev/sdh1 appears to be part of a raid array:
     level=raid5 devices=7 ctime=Sun Nov  2 13:21:54 2008
mdadm: /dev/sdj1 appears to be part of a raid array:
     level=raid5 devices=7 ctime=Sun Nov  2 13:21:54 2008
mdadm: /dev/sdk1 appears to be part of a raid array:
     level=raid5 devices=7 ctime=Sun Nov  2 13:21:54 2008
mdadm: /dev/sdg1 appears to be part of a raid array:
     level=raid5 devices=7 ctime=Sun Nov  2 13:21:54 2008
mdadm: largest drive (/dev/sdg1) exceeds size (976759936K) by more  
than 1%
Continue creating array? y
mdadm: array /dev/md/0 started.

Jun  2 15:34:47 localhost klogd: md: bind<sdi1>
Jun  2 15:34:47 localhost klogd: md: bind<sdl1>
Jun  2 15:34:47 localhost klogd: md: bind<sdh1>
Jun  2 15:34:47 localhost klogd: md: bind<sdj1>
Jun  2 15:34:47 localhost klogd: md: bind<sdk1>
Jun  2 15:34:47 localhost klogd: md: bind<sdg1>
Jun  2 15:34:47 localhost klogd: md: raid6 personality registered for  
level 6
Jun  2 15:34:47 localhost klogd: md: raid5 personality registered for  
level 5
Jun  2 15:34:47 localhost klogd: md: raid4 personality registered for  
level 4
Jun  2 15:34:47 localhost klogd: raid5: device sdg1 operational as  
raid disk 5
Jun  2 15:34:47 localhost klogd: raid5: device sdk1 operational as  
raid disk 4
Jun  2 15:34:47 localhost klogd: raid5: device sdj1 operational as  
raid disk 3
Jun  2 15:34:47 localhost klogd: raid5: device sdh1 operational as  
raid disk 2
Jun  2 15:34:47 localhost klogd: raid5: device sdl1 operational as  
raid disk 1
Jun  2 15:34:47 localhost klogd: raid5: device sdi1 operational as  
raid disk 0
Jun  2 15:34:47 localhost klogd: raid5: allocated 7434kB for md0
Jun  2 15:34:47 localhost klogd: raid5: raid level 5 set md0 active  
with 6 out of 7 devices, algorithm 2
Jun  2 15:34:47 localhost klogd: RAID5 conf printout:
Jun  2 15:34:47 localhost klogd:  --- rd:7 wd:6
Jun  2 15:34:47 localhost klogd:  disk 0, o:1, dev:sdi1
Jun  2 15:34:47 localhost klogd:  disk 1, o:1, dev:sdl1
Jun  2 15:34:47 localhost klogd:  disk 2, o:1, dev:sdh1
Jun  2 15:34:47 localhost klogd:  disk 3, o:1, dev:sdj1
Jun  2 15:34:47 localhost klogd:  disk 4, o:1, dev:sdk1
Jun  2 15:34:47 localhost klogd:  disk 5, o:1, dev:sdg1
Jun  2 15:34:47 localhost klogd: md0: detected capacity change from 0  
to 6001213046784
Jun  2 15:34:47 localhost klogd:  md0: unknown partition table

[root@localhost ~]# cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdg1[5] sdk1[4] sdj1[3] sdh1[2] sdl1[1] sdi1[0]
       5860559616 blocks level 5, 64k chunk, algorithm 2 [7/6] [UUUUUU_]
unused devices: <none>

Again, thanks a lot for your help. Very appreciated.

Alexander
