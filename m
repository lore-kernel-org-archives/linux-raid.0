From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Adding a smaller drive
Date: Sun, 28 Jun 2009 16:22:21 -0500
Message-ID: <20090628212227029.KYDP20969@cdptpa-omta01.mail.rr.com>
References: <4A47DC1E.7030907@anonymous.org.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A47DC1E.7030907@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: 'John Robinson' <john.robinson@anonymous.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > 	I may have to rethink my position on using raw drives.  If I
> > partition the drives, I can make the partition a bit smaller than the
> whole
> > drive, allowing for the addition of a future drive whose size is a bit
> off.
> > I hate to waste space, but being stuck with an undersized or limping
> array
> > is worse.
> 
> Yes it is. You can still use raw devices, just give the --size argument
> when creating your array, and it won't use the largest size possible.

	That's a great idea.  I think I'll implement it the next time I have
to re-organize one of the arrays.

> You'll want to work out how many KiB (i.e. 2^10 bytes) there are in a
> drive manufacturer's MB (10^6), GB (10^9) or TB (10^12) and use that as
> appropriate. For example, presumably all manufacturers' 500G drives will
> have at least 500*10^9 bytes of storage on them, and divided by 1024
> that's 488281250.

	I'm not confidant of that presumption.  I would not be surprised in
the least if some manufacturer produced a 1T drive with an actual 999.8G of
storage.  The device sizes on my arrays are all 1000.205G or 1500.300G,
respectively, so until I move to 3T drives, I'll just have to hope I don't
get a smaller one.

