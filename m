From: Finn Thain <fthain@telegraphics.com.au>
Subject: Re: [PATCH v4 0/3] Badblock tracking for gendisks
Date: Wed, 9 Dec 2015 08:52:35 +1100 (AEDT)
Message-ID: <alpine.LNX.2.00.1512090848001.2126@nippy.intranet>
References: <1449602295-28781-1-git-send-email-vishal.l.verma@intel.com> <87poygsmxd.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <87poygsmxd.fsf@notabene.neil.brown.name>
Sender: linux-scsi-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: Vishal Verma <vishal.l.verma@intel.com>, linux-nvdimm@lists.01.org, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org, Jens Axboe <axboe@fb.com>, Jeff Moyer <jmoyer@redhat.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-raid.ids


On Wed, 9 Dec 2015, NeilBrown wrote:

> On Wed, Dec 09 2015, Vishal Verma <vishal.l.verma@intel.com> wrote:
> 
> >
> > Patch 3 converts md over to use the new badblocks 'library'. I have 
> > done some pretty simple testing on this - created a raid 1 device, 
> > made sure the sysfs entries show up, and can be used to add and view 
> > badblocks. A closer look by the md folks would be nice here.
> 
> Hi,
>  this all looks reasonably sensible.  I haven't gone over it with a
>  fine toothed comb (I wonder where that analogy comes from....)

Delousing. (Not debugging.)

> but
>  nothing is obviously wrong.
> 
>  Acked-by: NeilBrown <neilb@suse.com>
> 
> Thanks,
> NeilBrown
> 

-- 
