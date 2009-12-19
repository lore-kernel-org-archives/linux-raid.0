From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Sat, 19 Dec 2009 14:19:03 -0600
Message-ID: <88.03.04641.B353D2B4@cdptpa-omtalb.mail.rr.com>
References: <70ed7c3e0912191155n5935bcfbk2a1029beae86afc8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912191155n5935bcfbk2a1029beae86afc8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> With dev/backup I mean if the Linux machine you're running is a a
> backup system or a development machine that you can at least test this
> on, it'd be convenient.

	Oh, I see.  I'll think about it.  I have the machine offline
entirely right now, making some hardware changes.

> The reason why you can't mount even though repair suggests you do
> might be because of a bug in xfsprogs/libs not a complete corruption
> in the filesystem itself.

	It's possible, I guess, but the diagnostics seem pretty coherent.
Running xfs_repair in test mode finds a small but reasonable number of
issues.

> Perhaps even the newer version of the progs & libs might be able to
> handle the kind of corruption in the filesystem you're having now,
> without the need to clear the log.

	Again, it's possible, of course.  I'll take it under advisement.
The question at hand, however is, "Is there possibly something at a lower
level (md) that could potentially be addressed which could clear the issues
that xfs thinks it has?"

 
> In case you resort to clearing the log, wouldn't running xfs_repair
> result in eventually finding the lost inodes and putting them in
> lost+found?

	The lost inodes, yes.  Xfs is reporting a few other errors, as well.
They don't look to be too heinous, so it might be easier all the way around
to just clear the log and proceed.  An rsych should easily recover any lost
files.

