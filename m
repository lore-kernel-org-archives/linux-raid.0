From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: raid10: unfair disk load?
Date: Sun, 23 Dec 2007 15:36:04 +0300
Message-ID: <476E5634.4050607@msgid.tls.msk.ru>
References: <476BA4FD.6080401@msgid.tls.msk.ru>	 <476BA942.40406@msgid.tls.msk.ru> <20071221174902.6fc02c4e@absurd>	 <476C2869.1080903@msgid.tls.msk.ru> <20071222130559.68b773fd@absurd>	 <cccedfc60712220504t1d720330p6f8ecf9bfd0f3163@mail.gmail.com> <beb6123c0712222034g68743afv31c644ff4dd9aaff@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <beb6123c0712222034g68743afv31c644ff4dd9aaff@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: maobo <maobo1983@gmail.com>
Cc: Jon Nelson <jnelson@jamponi.net>, Janek Kozicki <janek_listy@wp.pl>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

maobo wrote:
> Hi,all
> Yes, Raid10 read balance is the shortest position time first and
> considering the sequential access condition. But its performance is
> really poor from my test than raid0.

Single-stream write performance of raid0, raid1 and raid10 should be
of similar level (with raid5 and raid6 things are different) -- in all
3 cases, it should be near the write speed of a single drive.  The
only possible problematic cases is when you've some "unlucky" hardware
which does not permit writing into two drives in parallel - in which
case raid1 and raid10 write speed should be less than to raid0 and
single drive.  But even ol'good IDE drives/controllers, even if two
disks are on the same channel, permits parallel writes.  Modern SATA
and SCSI/SAS should be no problem - hopefully, modulo (theoretically)
some very cheap lame controllers.

> I think this is the process flow raid10 influence. But RAID0 is so
> simple and performed very well!
> From this point that striping is better than mirroring! RAID10 is
> stipe+mirror. But for write condition it performed really bad than RAID0.
> Isn't it?

No it's not.  When the hardware (and drivers) is sane anyway.

Also, "speed" is a very objective thing, so to say - it very much
depends on the workload.

/mjt
