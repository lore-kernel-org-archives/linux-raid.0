From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: DDF Trial Use draft specification now publicly available
Date: Thu, 11 Mar 2004 15:43:18 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4050CF66.8090409@pobox.com>
References: <20040311154542.GA6173@lists.us.dell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040311154542.GA6173@lists.us.dell.com>
To: Matt Domsch <Matt_Domsch@dell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matt Domsch wrote:
> The Disk Data Format (DDF) trial use draft spec has now been published
> by SNIA.  This is the common on-disk metadata format that
> RAID vendors have been driving towards, which should allow one to move
> disks from one vendor's RAID controller to another vendor's RAID
> controller without the backup-rebuild-restore that's currently needed.
> 
> http://www.snia.org/tech_activities/ddftwg

Thanks for posting this.

I haven't even read past "locality" section to find brokenness.  DDF 
RAID groups (a.k.a. each RAID array) must store information about other 
RAID groups "on the controller."  There is also apparently 
per-controller state information one must care about.  While I 
understand why they would want this, this also means the format is quite 
a bit less flexible than md, and in some respects, more difficult to 
work with.

/me continues reading...


