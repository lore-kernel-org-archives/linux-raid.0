From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: EVMS or md?
Date: Mon, 04 Apr 2005 18:03:33 -0500
Message-ID: <1112655813.7245.10.camel@langvan2.homenetwork>
References: <200504040708.j3478bm03863@www.watkins-home.com>
	 <1112642928.25469.28.camel@dyn95395156>
	 <200504041446.50337.kewley@gps.caltech.edu>
	 <d2seal$ntf$1@terminus.zytor.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d2seal$ntf$1@terminus.zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2005-04-04 at 17:15, H. Peter Anvin wrote:
> Followup to:  <200504041446.50337.kewley@gps.caltech.edu>
> By author:    David Kewley <kewley@gps.caltech.edu>
> In newsgroup: linux.dev.raid
> >
> > Mike Tran wrote on Monday 04 April 2005 12:28:
> > > We (EVMS team) intended to support RAID6 last year.  But as we all
> > > remember RAID6 was not stable then.  I may write a plugin to support
> > > RAID6 soon.
> > 
> > Hi Mike,
> > 
> > In your view, is RAID6 now considered stable?  How soon might you have an evms 
> > plugin for it? ;)  I'd love to use evms on my new filserver if it supported 
> > RAID6.
> > 

I will do it, but I can't promise a time frame.  I will announce on evms
mailing list when it's available.  This discussion should be on evms
mailing list (sorry folks!)

> 
> I can't speak for the EVMS people, but I got to stress-test my RAID6
> test system some this weekend; after having run in 1-disk degraded
> mode for several months (thus showing that the big bad "degraded
> write" bug has been thoroughly fixed) I changed the motherboard, and
> the kernel didn't support one of the controllers.  And now there were
> 2 missing drives.  Due to some bootloader problems, I ended up
> yo-yoing between the two kernels a bit more than I intended to, and
> went through quite a few RAID disk losses and rebuilds as a result.
> 
> No hiccups, data losses, or missing functionality.  At the end of the
> whole ordeal, the filesystem (1 TB, 50% full) was still quite prisine,
> and fsck confirmed this.  I was quite pleased :)
> 
> Oh, and doing the N-2 -> N-1 rebuild is slow (obviously), but not
> outrageously so.  It rebuilt the 1 TB array in a matter of
> single-digit hours.  CPU utilitization was quite high, obviously, but
> it didn't cripple the system by any means.
> 

Glad to hear the good news :)  mdadm or EVMS is just a user space tool. 
We depend on the kernel side to provide stability.

--
Mike T.


