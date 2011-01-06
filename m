From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Considering a complete rework of RAID on my home compute server
Date: Thu, 6 Jan 2011 02:10:48 -0600
Message-ID: <CA.87.02631.B09752D4@cdptpa-omtalb.mail.rr.com>
References: <20110106054754.44e7fe1a@natsu>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110106054754.44e7fe1a@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: 'Roman Mamedov' <rm@romanrm.ru>
Cc: 'Mark Knecht' <markknecht@gmail.com>, 'Linux-RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Wed, 5 Jan 2011 18:03:47 -0600
> "Leslie Rhorer" <lrhorer@satx.rr.com> wrote:
> 
> > 	RAID1 certainly offers the most robust solution, especially
> > with more than 1 mirror.
> 
> > 	RAID1 is as safe as it gets
> 
> Are you sure about that?

	Well, yeah.

> Considering that mdadm's handling of corrupt data
> on
> RAID1 devices is pretty simplistic (obviously it does not have per-block
> checksums anywhere, it does not do 'voting' on RAID1 with more than 2
> devices), it basically has no way of knowing if a block of data is
> returned

	Well I can't answer to that very well.  Some of the other folks who
are more familiar with the mechanics of the situation will have to comment,
but each single member of a RAID1 array holds the entire contents of the
data set.  A 3N has 3 complete sets of data on it, and piecing together a
fragmented data set from 3 complete sets of data is going to be more likely
to produce an intact data set than from 1 + 1/N data sets.

> differently by some of the component devices, which one has the 'correct'
> data. From what I understand, RAID5 and especially RAID6 give a much
> better
> protection in this situation.

	It's certainly not been my experience.  That said, I do run RAID6
arrays, along with RAID1 arrays.  YMMV, of course.

