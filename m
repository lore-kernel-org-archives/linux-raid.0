From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: XFS on top RAID10 with odd drives count and 2 near copies
Date: Mon, 13 Feb 2012 21:49:06 -0600
Message-ID: <4F39D9B2.3050305@hardwarefreak.com>
References: <CAGqmV7o7AQFY1K-1JLDk02Cv6GpAUQFjiSdM2Wbdbu6Zh_t0Wg@mail.gmail.com> <4F35E925.6000003@hardwarefreak.com> <CAGqmV7rBa39U-RWkzH-cTci1pNrrY1sfS=DkyK1wHE80bMt6qA@mail.gmail.com> <4F38FD5D.1010201@hardwarefreak.com> <CAGqmV7o6SNGV_A=iP2-uJXAJpPwh83GuqTZ-BzuY6vceMJJPVg@mail.gmail.com> <20120213230228.GA5822@www5.open-std.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120213230228.GA5822@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: CoolCold <coolthecold@gmail.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 2/13/2012 5:02 PM, keld@keldix.com wrote:

> And anyway, I think a 7 spindle raid10,f2 would be much faster than 
> a md linear array setup, both for small files and for largish
> sequential files. But try it out and report to us what you find.

The results of the target workload should be interesting, given the
apparent 7 spindles of stripe width of mdraid10,f2, and only 3 effective
spindles with the linear array of mirror pairs, an apparent 4 spindle
deficit.

> I would expect  a linear md, and also most other MD raids would tend to perform better in 
> the almost empty state, as the files will be placed on the faster parts of the spindles.

This is not the case with XFS.

> raid10,f2 would have a more uniform performance as it gets filled, because read access to 
> files would still be to the faster parts of the spindles.

This may be the case with EXTx, Reiser, etc, but not with XFS.

XFS creates its allocation groups uniformly across the storage device.
So assuming your filesystem contains more than a handful of directories,
even a very young XFS will have directories and files stored from outer
to inner tracks.

This layout of AGs, and the way XFS makes use of them, is directly
responsible for much of XFS' high performance.  For example, a single
file create operation on a full EXTx filesystem will exhibit a ~30ms
combined seek delay with an average 3.5" SATA disk.  With XFS it will be
~10ms.  This is because with EXTx the directories are at the outer edge
and the free space is on the far inner edge.  With XFS the directory and
free space area few tracks apart within the same allocation group.  Once
you seek the directory in the AG, the seek latency from there to the
track with the free space may be less than 1ms.  The seek distance
principal here is the same for single disks and RAID.

-- 
Stan
