From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID5 / 6 Growth
Date: Wed, 16 Dec 2009 02:06:09 -0600
Message-ID: <8D.4A.01567.8F4982B4@cdptpa-omtalb.mail.rr.com>
References: <70ed7c3e0912152237v3b7bf25cg54c70eb61101a60a@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912152237v3b7bf25cg54c70eb61101a60a@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Have you made sure that the value of
> /proc/sys/dev/raid/speed_limit_min is high enough? (200000 means 200

High enough?  Wouldn't a higher speed limit mean more stress on the systems?
Its value is 1000.

> MB/s) along with /proc/sys/dev/raid/speed_limit_max?

It's 200,000

> I interrupted an array resyncing a couple of times without issues.
> Only one time I interrupted an array during growth process and I had
> an old version of mdadm (2.6.3) which didn't support resuming that. I
> think Neil told me that 2.6.9 is the minimum requirement to resume.

It's 2.6.7.2.  Debian does not admit new software into its distro until they
are rock hard stable, unless it is a bug fix release.  I guess I'll have to
wait a few more days.


