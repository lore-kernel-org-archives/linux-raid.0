From: Florian Schanda <ma1flfs@bath.ac.uk>
Subject: Re: 2.6.0-test{1,2,3,4} kernels + software raid 0 + xfs broken?
Date: Wed, 27 Aug 2003 18:20:43 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200308271820.43920.ma1flfs@bath.ac.uk>
References: <200308231916.00588.ma1flfs@bath.ac.uk> <16200.32203.357734.460269@gargle.gargle.HOWL>
Reply-To: ma1flfs@bath.ac.uk
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_7ZPT/Ibaxxh623X"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16200.32203.357734.460269@gargle.gargle.HOWL>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Boundary-00=_7ZPT/Ibaxxh623X
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Sunday 24 August 2003 08:56, Neil Brown wrote:
> On Saturday August 23, ma1flfs@bath.ac.uk wrote:
> > Hi all,
> >
> > I am running a 2.4.21 kernel + xfs + raid0 (software) on 2 scsi disks. It
> > works without flaws.
> >
> > Trying the same setup in 2.6.0-test{1,2,3} (haven't tested 4 yet) _will_
> > give data corruption if I write to the array.
> >
> Can you test without raid0 and confirm that it works with xfs on a
> single drive?

I have now also tested with -test4.
It works, in all of 2.6.0{1,2,3,4} and 2.4.21-xfs.

> Are there any kernel messages?

Only this: (from /var/log/kern.log)

Aug 27 17:57:02 omoikane kernel: XFS mounting filesystem md0
Aug 27 17:57:03 omoikane kernel: Ending clean XFS mount for filesystem: md0
Aug 27 17:58:22 omoikane kernel: XFS mounting filesystem md0
Aug 27 17:58:22 omoikane kernel: Starting XFS recovery on filesystem: md0 
(dev: 9/0)
Aug 27 17:58:22 omoikane kernel: Ending XFS recovery on filesystem: md0 (dev: 
9/0)
Aug 27 17:59:27 omoikane kernel: XFS mounting filesystem md0
Aug 27 17:59:27 omoikane kernel: Ending clean XFS mount for filesystem: md0
Aug 27 18:00:17 omoikane kernel: XFS mounting filesystem md0
Aug 27 18:00:17 omoikane kernel: Starting XFS recovery on filesystem: md0 
(dev: 9/0)
Aug 27 18:00:18 omoikane kernel: Ending XFS recovery on filesystem: md0 (dev: 
9/0)

What I did was (4 times):

1) mount /dev/md0 on /data
2) make a dir called testdir
3) copy some random files in there (about 20-500) MB each
4) umount /data
5) mount /data

In this particular case it was able to recover (but it really shouldn't... 
since it was cleanly unmounted), but If I do lots of stuff it usually can't 
recover. Usually the only way out is xfs_repair -L /dev/md0

Note that the very first initial mount (mounting the array as it was left by 
2.4.21) did not generate any messages and succeded flawlessly.

I've attached my 2.4.6 config below - just in case.

Thanks,

	Florian

--Boundary-00=_7ZPT/Ibaxxh623X
Content-Type: application/x-bzip2;
  name="config.bz2"
Content-Transfer-Encoding: base64
Content-Disposition: attachment;
	filename="config.bz2"

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

--Boundary-00=_7ZPT/Ibaxxh623X--

