From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Deleting an raid device
Date: Wed, 26 May 2004 09:42:04 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16563.55756.112020.262470@cse.unsw.edu.au>
References: <002501c44257$7135dd80$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from me@heyjay.com on Tuesday May 25
To: me@heyjay.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday May 25, me@heyjay.com wrote:
> Hi,
> 
> What are the proper steps for deleting all remnants of a previous raid
> install?
> 
> I've done:
> mdadm --stop /dev/md0
> mdadm --zero-superblock /dev/md0

I doubt that.  After stopping /dev/md0, trying to zero a superblock in
/dev/md0 would fail.
Superblocks don't live in the array, they live in the individual
component drives:

  mdadm --zero-superblock /dev/sd?c
or something.

But there is no harm having stray superblocks lying around.  
Make sure the partitions are not raid-auto-detect (as someone else
has mentioned I think) and make sure mdadm.conf doesn't mention the
arrays.

NeilBrown
 
> 
> But I still see it getting stopped on shutdown.
> 
> Thanks
> Jay
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
