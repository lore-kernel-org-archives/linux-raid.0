From: Neil Brown <neilb@suse.de>
Subject: Re: How to grow RAID1 mirror on top of LVM?
Date: Tue, 25 Mar 2008 16:36:40 +1100
Message-ID: <18408.36712.100712.499844@notabene.brown>
References: <25F8EF57-9606-4217-B2D4-2DD3D8E064C4@cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Anton Altaparmakov on Thursday March 13
Sender: linux-raid-owner@vger.kernel.org
To: Anton Altaparmakov <aia21@cam.ac.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 13, aia21@cam.ac.uk wrote:
> 
> Is there a better way to do this?  I am hoping someone will tell me to  
> use option blah to utility foo that will do this for me without having  
> to break the mirror twice and resync each time.  (-;

Sorry, but no.  This mode of operation was never envisaged for md.
I would always put the md/raid1 devices below the LVM.

Every time you buy two drives, combine them into a RAID1, and add the
/dev/mdX as a PV for LVM.  Then grow you LVM devices whenever you
like.

> 
> If not, please consider this a feature request for mdadm.  (-:  It  
> should have an option to detect that the underlying device has grown  
> and thus write a new superblock  (or move the old one or whatever) at  
> the end of the newly grown device instead of complaining that it does  
> not exist.  Or something!  As it is, it is incredibly time consuming  
> and inefficient.  )-:

I'll keep it in mind (Which it to say:  I will save this in my 'mdadm'
mailbox, and have a look through that mailbox next time I'm working on
improvements to mdadm).

NeilBrown
