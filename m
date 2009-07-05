From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Adding a smaller drive
Date: Sun, 5 Jul 2009 17:03:02 -0500
Message-ID: <20090705220252458.BCFJ19903@cdptpa-omta03.mail.rr.com>
References: <4A4F7336.6070800@anonymous.org.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A4F7336.6070800@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > That last sentence is important! If this is a standard, then it would
> > seem to be actually intended to deceive the consumer. If there is to be
> > a standard for 1, 1.5, and 2, they really should have some sensible
> > relationship in size.
> >
> > That said, I confess that I use partitions and leave a little breathing
> > room on my drives when building a raid array.
> 
> I think I might take to doing that too, making my partitions/arrays
> multiples of 1,000,000,000 bytes (a drive maker's 1GB) where possible,
> just to be sure :-)

	Well, that's not quite possible, of course, since sectors are
usually 512 bytes, and 1E9 is not a multiple of 512.  Indeed, that's where
this whole situation is ridiculous. For drive manufacturers to even consider
using GB as a measuring basis is ludicrous.  If sectors were 1000 bytes, and
if computer registers were base 10, it would be an entirely different
matter, but the fact is the sector size is 2^9 and all the register
boundaries are going to be multiples of 2, not 10.

