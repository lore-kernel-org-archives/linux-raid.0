From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Sat, 19 Dec 2009 15:05:37 -0600
Message-ID: <D6.C4.01550.4204D2B4@cdptpa-omtalb.mail.rr.com>
References: <70ed7c3e0912191232k7deb3a3p40ddd6bc1bdfd3ae@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912191232k7deb3a3p40ddd6bc1bdfd3ae@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I understand what you're aiming at finding, unfortunately I can't
> think of anything that would cause a corruption apart from bad cables
> or bad sectors.

	Well, me, either, but the question at hand isn't so much, "What
caused it?" as it is, "Is there something (above and beyond the resync which
was already done) I can do to verify the health of the underlying array
before proceeding?"
> 
> Perhaps the file system was dirty before growing the array and the
> growth process emphasized the problems. You said you unmounted the
> filesystem, but did you try to mount it just to check, or run

	Yes,I did.

> xfs_repair before growing to make sure the filesystem is clean?

	No, it mounted just fine, and I could read the array, so I didn't go
any further.  I then shut down all the network accesses, did a `sync`, and
then umounted the array.  I didn't bother to actually check for dirty pages.

> > I'm out of ideas, for now. I haven't encountered such problems with
> XFS & software RAID before, and I hope someone has an answer to your
> problem, as I, and maybe others, might probably face it later.

	I've had similar problems when growing an array before, but this is
the first time I have grown an array under mdadm and also the first time
under xfs.

