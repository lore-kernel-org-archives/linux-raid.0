From: NeilBrown <neilb@suse.de>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Wed, 19 Jan 2011 06:44:57 +1100
Message-ID: <20110119064457.5ab8bdd0@notabene.brown>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 18 Jan 2011 22:59:07 +0700 Igor Podlesny <for.poige+linux@gmail.com>
wrote:

>    I had experience of using FreeBSD's vinum (another software RAID).
> Its author, Greg Lehey, stated in vinum's manual: "... A good
> guideline for stripe size is between 256 kB and 512 kB.  Avoid powers
> of 2, however: they tend to cause all superblocks to be placed on the
> first subdisk. ..."
> 
>    Meanwhile, with LSR we're given exactly 2^n choices, for e. g.,
> neither 768 KiB, nor 387 KiB won't go: "mdadm: invalid chunk/rounding
> value: 387".
> 
>    So, why... ($Subj) and how complex would it be to abolish this
> restriction? I think this could be a key to performance increase.
> 
>    P. S. Thanks a ton for LSR, Neil, BTW. :-)
> 

1/ The rationale given by Greg for non-power-of-two chunk sizes is not so
 relevant for Linux I think.  The more common filesystems  can be told that
 the device is a RAID and can deliberately offset the extra super blocks so
 they don't all end up on the one device.

2/ Power-off-two is required simply because it was easier to code.  The
  restriction was dropped for RAID0 a year or more ago.  The restriction 
  could be dropped for RAID4/5/6 and RAID10 relatively easily.  It would just
  require a thorough code review and changing a few 'mask' and 'shift'
  operations to divisions.

3/ You are welcome.

NeilBrown


