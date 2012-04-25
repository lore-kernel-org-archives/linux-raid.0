From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Monitoring for failed drives
Date: Wed, 25 Apr 2012 17:54:55 +0100
Message-ID: <20120425165455.GB11238@nsrc.org>
References: <20120425123951.GB10172@nsrc.org> <4F9823BD.8040300@computer.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4F9823BD.8040300@computer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jan Ceuleers <jan.ceuleers@computer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Apr 25, 2012 at 06:18:05PM +0200, Jan Ceuleers wrote:
> Brian Candler wrote:
> >The problem is, how to detect and report this? At the md RAID level,
> >`cat /proc/mdstat` and `mdadm --detail` show nothing amiss.
> >
> >     # cat /proc/mdstat
> >     Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10]
> >     md127 : active raid0 sdk[8] sdf[4] sdb[0] sdj[9] sdc[1] sde[2] sdd[3] sdi[6] sdg[5] sdh[7] sdv[20] sdw[21] sdl[11] sdu[19] sdt[18] sdn[13] sds[17] sdq[14] sdm[10] sdx[22] sdr[16] sdo[12] sdp[15] sdy[23]
> >           70326362112 blocks super 1.2 512k chunks
> 
> Brian,
> 
> I know that you know this, but this is a RAID0 which does not have
> any redundancy. What would you expect md to do?

In an ideal world, maybe it would mark the drive as "failing" or "erroring"
but still keep it in service.

There is some data on the failing disk which is still accessible, so as you
say there is value in keeping the array online, but if you try to access
data in the bad area of that disk you get I/O errors.  This is a serious
problem and I want to know about it somehow.

I'm not saying that md is necessarily the right layer to give me this
information. I'm not sure that SMART is necessarily the right place either,
although it may suffice.

If there are some drive error counters I can read, preferably exposed via
SNMP, that would be great.  Otherwise, I seek your advice on the best place
to look for this information...

Thanks,

Brian.
