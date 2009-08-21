From: "Carl A. Cook" <CACook@quantum-equities.com>
Subject: Re: linux disk access when idle
Date: Fri, 21 Aug 2009 16:13:27 -0700
Message-ID: <200908211613.28075.CACook@quantum-equities.com>
References: <20090820163522.GA29215@sewage> <4A8F190B.9010406@tmr.com> <20090821231039.GB22331@sewage>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090821231039.GB22331@sewage>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


I haven't followed this whole thread, but there is some aspect of ext3 journalling which hits that disk with regularity.  Obviously not a write flush, but some sort of check out of insecurity or something.


On Friday 21 August 2009 16:10:39 Matt Garman wrote:
> On Fri, Aug 21, 2009 at 06:00:43PM -0400, Bill Davidsen wrote:
> > /proc/sys/vm/dirty_expire_centisecs still set to 30 sec?
> 
> $ cat /proc/sys/vm/dirty_expire_centisecs
> 2999
> 
> Yup.  Maybe I don't understand exactly what this does, but if the
> drives are idle (i.e. no reads or writes) for say an hour or more,
> why would there be any dirty data to flush?
> 
> That's why I'm confused---this machine literally goes for hours at a
> time without and read or write attemps on these drives.
> 
> -Matt
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

