From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: Write intent bitmaps
Date: Sun, 7 Jun 2009 21:10:30 -0500
Message-ID: <20090608021026139.GMOD14139@cdptpa-omta02.mail.rr.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I have been reading a bit about write-intent bitmaps on RAID arrays, and I
am considering adding them to my arrays.  I have a few questions:

1. The write-intent bitmap seems to be rather similar to a file system
journal.  Are there any features of the bitmaps which distinguish them from
a journal, other than the fact they operate at the RAID layer, of course,
instead of the filesystem layer?

2. On a RAID5 or RAID6 array, how much of a performance hit might I expect?

3. The threads I have read all speak about the benefits during a power
failure.  Power failures are not the only source of dirty shutdowns,
however.  Are there any benefits to a bitmap for recovering a failed array
or a degraded array?  A resync can take more than a day, and the array is
vulnerable during that time.

4. How much space will be required for the bitmnap on an external drive?

5. What happens if the bitmap is lost or the external drive fills up?

6. Would it be best to allocate a small separate partition entirely for the
bitmap?  If so, would ext2 probably be the best choice?  How does one
guarantee the partition and filesystem will be available prior to the
assembly of  the RAID array during boot?

