From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Interpreting mdstat output
Date: Tue, 5 Feb 2013 13:49:07 +0000
Message-ID: <20130205134907.GA622@nsrc.org>
References: <20130205122048.GA417@nsrc.org>
 <20130205130237.GA9299@cthulhu.home.robinhill.me.uk>
 <20130205134014.GA587@nsrc.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20130205134014.GA587@nsrc.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 05, 2013 at 01:40:14PM +0000, Brian Candler wrote:
> On Tue, Feb 05, 2013 at 01:02:37PM +0000, Robin Hill wrote:
> > > 1. The UUUU_ and [22/21] suggests that one disk is bad, but is that true?
> > > And if so which one?
> > > 
> > No, that's normal. A RAID5 (or RAID6) array is created in a degraded
> > form, then the last disk(s) are recovered (it's the quickest way of
> > getting the array ready for use).
> 
> Ah I see. Thank you.

The odd thing is, if I make a RAID6 I get [UUUUU] with no underscores?

# cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md127 : active raid6 sdy[23](S) sdx[22] sdw[21] sdv[20] sdu[19] sdt[18] sds[17] sdr[16] sdq[15] sdp[14] sdo[13] sdn[12] sdm[11] sdl[10] sdk[9] sdj[8] sdi[7] sdh[6] sdg[5] sdf[4] sde[3] sdd[2] sdc[1] sdb[0]
      61532835840 blocks super 1.2 level 6, 512k chunk, algorithm 2 [23/23] [UUUUUUUUUUUUUUUUUUUUUUU]
      [>....................]  resync =  0.0% (850232/2930135040) finish=1607.7min speed=30365K/sec
      bitmap: 22/22 pages [88KB], 65536KB chunk

unused devices: <none>

Regards,

Brian.
