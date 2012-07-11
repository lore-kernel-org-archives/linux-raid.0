From: David Brown <david.brown@hesbynett.no>
Subject: Re: Does mdadm supports TRIM command to SSDs?
Date: Wed, 11 Jul 2012 17:08:28 +0200
Message-ID: <4FFD96EC.2020007@hesbynett.no>
References: <CAF-9JegPGmayAO0gAsqY4J3rpRpTq_ciLA5e+nu0PsSjJhwr-A@mail.gmail.com> <4FFD632F.3060407@hesbynett.no> <CAA8Hn0eWuHJy9ivmvUVc-m=2t+L2_ACTy52tGVOYnFy97XFTXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA8Hn0eWuHJy9ivmvUVc-m=2t+L2_ACTy52tGVOYnFy97XFTXA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Scott E. Armitage" <launchpad@scott.armitage.name>
Cc: Bar Ziony <bartzy@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/2012 01:58 PM, Scott E. Armitage wrote:
> On Wed, Jul 11, 2012 at 7:27 AM, David Brown <david.brown@hesbynett.no
> <mailto:david.brown@hesbynett.no>> wrote:
>
>     The big question here is /why/ would you want TRIM support?  In many
>     circumstances it leads to slower operations, and for SSDs from the
>     past couple of years it is almost entirely superseded by the SSD's
>     own garbage collection.
>
>
> Are you speaking from a general usage standpoint, or from a TRIM + RAID
> standpoint? For the general usage case, I was under the impression that
> SSD garbage collection was hamstrung by insufficient knowledge about
> which blocks are and are not in use. E.g. when a filesystem deletes a
> large file simply by marking it as deleted in the
> filetable/inode/whatever that particular system uses, the SSD is forced
> to carry around (and re-copy, if necessary) the data blocks until the
> filesystem tells it those blocks are no longer in use (i.e. a TRIM command).
>

That is correct - except that "hamstrung" is an exaggeration.  Blocks 
that are unused by the filesystem still have to be carried around by the 
SSD if they are not TRIM'ed, and that is extra work.  But it is not 
actually a great deal of extra work.  In particular, filesystems do a 
lot of re-use of deleted blocks - when the logical block is re-written, 
the SSD knows that the old data is no longer needed.

The main purpose of TRIM, and the reason it was introduced, was not so 
much to avoid moving around unneeded copies of old data, but to make 
sure there are free erased blocks available when they are needed.  With 
modern SSDs with over-provisioning and better garbage collection, that 
is no longer necessary - there are always free blocks, since there are 
many more physical blocks than logical ones.

If TRIM were well implemented, then it could still have been useful. 
But it is a synchronous command, and cannot be queued - this means it is 
slow, and breaks the flow of commands.  So the result is that operations 
such as "delete" can take many times longer to complete if TRIM is enabled.

