From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Stupid question regarding RAID-1 access pattern
Date: Thu, 7 Jan 2010 09:17:23 -0600
Message-ID: <33.95.19578.10BF54B4@cdptpa-omtalb.mail.rr.com>
References: <4B44EB58.2090400@northarc.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B44EB58.2090400@northarc.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Curt Hartung' <curt@northarc.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of Curt Hartung
> Sent: Wednesday, January 06, 2010 1:58 PM
> To: linux-raid@vger.kernel.org
> Subject: Stupid question regarding RAID-1 access pattern
> 
> Tried to ferret out the answer to this myself and so far so bad.
> 
> This just 'popped in there' while I was optimizing something completely
> different... in a RAID-1, writes have to be mirrored of course, thats
> what RAID-1 is, but for reads, could they not be sped up by a
> significant amount if a storage pattern was chosen such that large
> blocks of data were "striped" in an in-order/out-of-order scheme? In
> other words, store all the data on both drives, but in huge (2x cache
> size) -ish blocks that might allow 50% of a given [large] access to come
> from each drive, with trivial [smaller] reads always coming from one or
> the other chosen at random.
> 
> Downside, I know, is that the data would be organized ina  way only the
> raid subsystem would understand, so the niceness of pulling a mirrored
> drive out of service and it being a literal copy of the otehr drive
> would be lost, but for such a speedup I'd be willing to pay the price of
> always having to access it as a failed set (worst case) through the
> md-daemon.
> 
> Am I off into the weeds?

	I think either you may be expressing yourself incorrectly, or else
you are not thinking through the process.  If both drive are identical in
type, then reading from either one is going to take the same amount of time.
If one drive is inherently slower than the other, then one may employ the
write-mostly parameter of RAID so that it generally only reads from the
faster drive.  The only performance benefit would be observed by performing
ordered non-sequential seeks on alternate drives, and I believe md already
does that.  There is no benefit gained to set up a formal "stripe"
architecture, but, for example, if the system calls for seeks to cylinders
1000, 1001, 1002, 1003, 768, 769, and 770, then the best performance would
be gained by issuing seeks to 1000 - 1003 on one drive and 768 - 770 on the
other.

