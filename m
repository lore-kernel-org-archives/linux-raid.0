From: Scott Long <scott_long@adaptec.com>
Subject: Re: DDF Trial Use draft specification now publicly available
Date: Fri, 12 Mar 2004 00:27:54 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4051667A.5010303@adaptec.com>
References: <20040311154542.GA6173@lists.us.dell.com> <4050CF66.8090409@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4050CF66.8090409@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jeff Garzik wrote:
> Matt Domsch wrote:
>  > The Disk Data Format (DDF) trial use draft spec has now been published
>  > by SNIA.  This is the common on-disk metadata format that
>  > RAID vendors have been driving towards, which should allow one to move
>  > disks from one vendor's RAID controller to another vendor's RAID
>  > controller without the backup-rebuild-restore that's currently needed.
>  >
>  > http://www.snia.org/tech_activities/ddftwg
> 
> Thanks for posting this.
> 
> I haven't even read past "locality" section to find brokenness.  DDF
> RAID groups (a.k.a. each RAID array) must store information about other
> RAID groups "on the controller."  There is also apparently
> per-controller state information one must care about.  While I
> understand why they would want this, this also means the format is quite
> a bit less flexible than md, and in some respects, more difficult to
> work with.
> 

Complexity != brokenness

Recording information about all disks and arrays on every disk means
that you can detect when a whole array is missing.  The more complex
array information means that you can express mutli-level arrays in a
reasonable way.  We've already spoken a little bit about this.  There is
also quite a bit of information in the format that allows you to
validate each disk and determine how much your 'trust' it.  While this
certainly adds complexity, it also strengthens the notion that RAID is
about ensuring integrety.  Of course it doesn't slow down the actual
transform of a raid-0, so you can still measure it's worthiness that
way =-)

As Matt Domsch mentioned earlier, Adaptec has been working on a DDF
implementation for Linux under MD.  We are putting the final touches on
it right now (as I type this at 12:30am) and getting it ready for formal
testing.  After that, we will release it to the Linux community for
review and inclusion.  As an added benefit, our Enhanced MD will also
provide full (and Open) support for Adaptec HostRAID.

Scott

