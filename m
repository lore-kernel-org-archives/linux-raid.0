From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Spurious HD convictions
Date: Tue, 15 Dec 2009 23:41:03 -0600
Message-ID: <FD.42.04641.7F2782B4@cdptpa-omtalb.mail.rr.com>
References: <70ed7c3e0912141206p65005aeegf663183c946dec7b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0912141206p65005aeegf663183c946dec7b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Hi Leslie,
> 
> I was wondering if you were able to stop the weird behavior with your
> disks.

	It seems to have done so, yes.  I've looked around the web trying to
find some additional info, but I've come up empty handed.  Perhaps someone
here can answer at least one of my questions?  I know that putting a value
of 32 into /sys/block/<driveID>/device/queue_depth fully enables NCQ, and
putting a value of 1 there disables NCQ.  What do all the numbers in between
do?

