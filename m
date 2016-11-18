From: Jack Wang <jack.wang.usish@gmail.com>
Subject: Re: [PATCH/RFC] add "failfast" support for raid1/raid10.
Date: Fri, 18 Nov 2016 16:41:18 +0100
Message-ID: <CA+res+TZD2Lx4CaGPx6SjTc6VKGLUc=qyYBgi15oSYU1bBuHew@mail.gmail.com>
References: <147944614789.3302.1959091446949640579.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <147944614789.3302.1959091446949640579.stgit@noble>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Shaohua Li <shli@kernel.org>, linux-raid <linux-raid@vger.kernel.org>, linux-block@vger.kernel.org, Christoph Hellwig <hch@lst.de>, linux-kernel@vger.kernel.org, hare@suse.de
List-Id: linux-raid.ids

2016-11-18 6:16 GMT+01:00 NeilBrown <neilb@suse.com>:
> Hi,
>
>  I've been sitting on these patches for a while because although they
>  solve a real problem, it is a fairly limited use-case, and I don't
>  really like some of the details.
>
>  So I'm posting them as RFC in the hope that a different perspective
>  might help me like them better, or find a better approach.
>
>  The core idea is that when you have multiple copies of data
>  (i.e. mirrored drives) it doesn't make sense to wait for a read from
>  a drive that seems to be having problems.  It will probably be faster
>  to just cancel that read, and read from the other device.
>  Similarly, in some circumstances, it might be better to fail a drive
>  that is being slow to respond to writes, rather than cause all writes
>  to be very slow.
>
>  The particular context where this comes up is when mirroring across
>  storage arrays, where the storage arrays can temporarily take an
>  unusually long time to respond to requests (firmware updates have
>  been mentioned).  As the array will have redundancy internally, there
>  is little risk to the data.  The mirrored pair is really only for
>  disaster recovery, and it is deemed better to lose the last few
>  minutes of updates in the case of a serious disaster, rather than
>  occasionally having latency issues because one array needs to do some
>  maintenance for a few minutes.  The particular storage arrays in
>  question are DASD devices which are part of the s390 ecosystem.

Hi Neil,

Thanks for pushing this feature also to mainline.
We at Profitbricks use raid1 across IB network, one pserver with
raid1, both legs on 2 remote storages.
We've noticed if one remote storage crash , and raid1 still keep
sending IO to the faulty leg, even after 5 minutes,
md still redirect I/Os, and md refuse to remove active disks, eg:

2016-10-27T19:47:07.776233+02:00 pserver25 kernel: [184749.101984]
md/raid1:md23: Disk failure on ibnbd47, disabling device.

2016-10-27T19:47:07.776243+02:00 pserver25 kernel: [184749.101984]
md/raid1:md23: Operation continuing on 1 devices.

[...]

2016-10-27T19:47:16.171694+02:00 pserver25 kernel: [184757.498693]
md/raid1:md23: redirecting sector 79104 to other mirror: ibnbd46

[...]

2016-10-27T19:47:21.301732+02:00 pserver25 kernel: [184762.627288]
md/raid1:md23: redirecting sector 79232 to other mirror: ibnbd46

[...]

2016-10-27T19:47:35.501725+02:00 pserver25 kernel: [184776.829069] md:
cannot remove active disk ibnbd47 from md23 ...

2016-10-27T19:47:36.801769+02:00 pserver25 kernel: [184778.128856] md:
cannot remove active disk ibnbd47 from md23 ...

[...]

2016-10-27T19:52:33.401816+02:00 pserver25 kernel: [185074.727859]
md/raid1:md23: redirecting sector 72832 to other mirror: ibnbd46

2016-10-27T19:52:36.601693+02:00 pserver25 kernel: [185077.924835]
md/raid1:md23: redirecting sector 78336 to other mirror: ibnbd46

2016-10-27T19:52:36.601728+02:00 pserver25 kernel: [185077.925083]
RAID1 conf printout:

2016-10-27T19:52:36.601731+02:00 pserver25 kernel: [185077.925087]
--- wd:1 rd:2

2016-10-27T19:52:36.601733+02:00 pserver25 kernel: [185077.925091]
disk 0, wo:0, o:1, dev:ibnbd46

2016-10-27T19:52:36.601735+02:00 pserver25 kernel: [185077.925093]
disk 1, wo:1, o:0, dev:ibnbd47

2016-10-27T19:52:36.681691+02:00 pserver25 kernel: [185078.003392]
RAID1 conf printout:

2016-10-27T19:52:36.681706+02:00 pserver25 kernel: [185078.003404]
--- wd:1 rd:2

2016-10-27T19:52:36.681709+02:00 pserver25 kernel: [185078.003409]
disk 0, wo:0, o:1, dev:ibnbd46

I tried to port you patch from SLES[1], with the patchset, it reduce
the time to ~30 seconds.

I'm happy to see this feature upstream :)
I will test again this new patchset.

Cheers,
Jack Wang
