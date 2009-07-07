From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Adding a smaller drive
Date: Mon, 6 Jul 2009 21:57:57 -0500
Message-ID: <20090707025746993.BGXW24657@cdptpa-omta01.mail.rr.com>
References: <4A51255F.1020308@anonymous.org.uk>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A51255F.1020308@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >> I think I might take to doing that too, making my partitions/arrays
> >> multiples of 1,000,000,000 bytes (a drive maker's 1GB) where possible,
> >> just to be sure :-)
> >
> > 	Well, that's not quite possible, of course, since sectors are
> > usually 512 bytes, and 1E9 is not a multiple of 512.  Indeed, that's
> where
> > this whole situation is ridiculous. For drive manufacturers to even
> consider
> > using GB as a measuring basis is ludicrous.  If sectors were 1000 bytes,
> and
> > if computer registers were base 10, it would be an entirely different
> > matter, but the fact is the sector size is 2^9 and all the register
> > boundaries are going to be multiples of 2, not 10.
> 
> But 10^9 is divisible by 512: 10^9 = (2*5)^9 = 2^9 * 5^9. There are
> therefore 1953125 512-byte sectors in 1 drive maker's GB.

	Oh, good heavens!  Silly me, how could I have missed that?

