From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: EVMS or md?
Date: Mon, 04 Apr 2005 14:28:48 -0500
Message-ID: <1112642928.25469.28.camel@dyn95395156>
References: <200504040708.j3478bm03863@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200504040708.j3478bm03863@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Guy,

On Mon, 2005-04-04 at 02:08, Guy wrote:
> I am top posting since I am starting a new topic.
> 
> Don't get me wrong, I like and trust md, at least with kernel 2.4.
> 
> This is the first I knew about EVMS, the website makes it sound wonderfull!
> http://evms.sourceforge.net/
> 
> Is EVMS "better" than md?
> Is EVMS replacing md?
> Any performance data comparing the 2?

EVMS uses MD and Device Mapper (DM).  So, EVMS does not replace MD.  For
RAID-1 & RAID-5, EVMS ioctl md driver to start the array.  For MD's
RAID-0 and LINEAR arrays, EVMS uses DM stripe and linear targets to
create device nodes.

You can say EVMS replaces mdadm (sorry, NeilB :))

Regarding performance issue (raid1 & raid5), I/O requests from MD will
appear on DM's queue.  So, it is probably slower.  How much slower, we
never run any benchmark to find out.

> 
> One bad point for EVMS, no RAID6.  :(

We (EVMS team) intended to support RAID6 last year.  But as we all
remember RAID6 was not stable then.  I may write a plugin to support
RAID6 soon.

> One good point for EVMS, bad Block Relocation (but only on writes).
> Not sure how EVMS handles read errors.

As I mentioned above, kernel MD driver handle I/O requests for raid1 and
raid5.

> 
> I am getting on the mailing list(s).  I must know more about this!!!
> 

Welcome aboard :)

--
Regards,
Mike T.


