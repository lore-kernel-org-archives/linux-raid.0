From: Jaromir Capik <jcapik@redhat.com>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to make it more robust
Date: Wed, 18 Jul 2012 09:04:18 -0400 (EDT)
Message-ID: <691e878b-1a0d-4042-bb92-c8af76ba063b@zmail15.collab.prod.int.phx2.redhat.com>
References: <20120718211537.516b574f@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120718211537.516b574f@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil.

> 
> If a drive ever lets you read incorrect data rather than giving you
> an error
> indication, then the drive is broken by design.  Don't use drives
> that do
> that.

Unfortunately many drives do that. This happens transparently
during the drive's idle surface checks, when there's no read request
from the OS. I don't know how it is done in server harddrives, but
I experienced data corruptions related to bad sector reallocations
in case of several different desktop drives. I got no read errors
at all even when the SMART attributes were showing reallocations.
Somebody could ask, why people want to implement RAID on top of cheap
desktop harddrives. It's surprisingly because of their price.
Chunk checksums would give people a cheap and safe/robust solution.

> 
> >     Would it be possible
> > to implement chunk checksums to avoid such data corruptions?
> 
> No.

I respect your decision.
Thank you for your time.

Jaromir.

> 
> NeilBrown
> 
> 
> > If a corrupted chunk is encountered, it would be taken from the
> > second
> > drive and immediately synced back. This would have a small
> > performance
> > and capacity impact (1 sector per chunk to minimize performance
> > impact
> > caused by unaligned granularity = 0.78% of the capacity with 64k
> > chunks).
> > 
> > Please, let me know if you find my request reasonable or not.
> > 
> > Thanks in advance.
> > 
> > Regards,
> > Jaromir.
> > 
> > --
> > Jaromir Capik
> > Red Hat Czech, s.r.o.
> > Software Engineer / BaseOS
> > 
> > Email: jcapik@redhat.com
> > Web: www.cz.redhat.com
> > Red Hat Czech s.r.o., Purkynova 99/71, 612 45, Brno, Czech Republic
> > IC: 27690016
> > 
> > 
> > --
> > To unsubscribe from this list: send the line "unsubscribe
> > linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 
