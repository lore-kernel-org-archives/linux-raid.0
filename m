From: Chris Webb <chris@arachsys.com>
Subject: Re: Setting /sys/block/mdX/md/rdY/size caps to half the true value
 of the component device size
Date: Fri, 3 Sep 2010 09:25:30 +0100
Message-ID: <20100903082527.GR26121@arachsys.com>
References: <5a6e17cae4572bddfdb55865a43b2c7b.squirrel@webmail.martian111.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5a6e17cae4572bddfdb55865a43b2c7b.squirrel@webmail.martian111.net>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Lui <linuxdevel@martian111.net>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Martin Lui <linuxdevel@martian111.net> writes:

> I ran into a similar situation as described in your thread (ack in Jun 2008):
> http://marc.info/?l=linux-raid&m=121381509915920&w=2
> 
> First off, thank you both for your time to make this feature work.  Since
> I've increased the partition size of my RAID partition, I too needed to
> grow my array and component devices.  To do that, I attempted to use the
> feature implemented in this patch:
> http://marc.info/?l=linux-raid&m=121434960912711&w=2
[...]
> However, it seems that the value applied by this method is half the
> actual/correct value.

Hi Martin. I'm afraid I haven't used this feature with recent kernels
because the structure of our storage system changed so as not to require it.

At the time, it definitely worked correctly, updating the component size at
runtime, but I think there has been some work to unify the units (512 byte
sectors vs 1kb blocks) of the various internals of the md driver since then.
Perhaps this code wasn't updated to match the units change elsewhere? It's
quite rarely used I think.

Do you see this behaviour for both metadata formats 0.90 and 1.x?

Best wishes,

Chris.
