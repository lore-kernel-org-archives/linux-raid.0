From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Thu, 28 Apr 2011 15:47:40 +0200
Message-ID: <201104281547.40899.thomas.jarosch@intra2net.com>
References: <201103251725.21180.thomas.jarosch@intra2net.com> <201104271700.58894.thomas.jarosch@intra2net.com> <20110428112328.07cf4578@notabene.brown>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110428112328.07cf4578@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday, 28. April 2011 03:23:28 NeilBrown wrote:
> Yes it helps, thanks.
> 
> I do need to add_disk before I kobject_init_and_add the mddev object
> otherwise it will try to create something in sysfs in a non-existent
> directory.
> 
> So the sysfs stuff needs to come last.
> 
> Could you try this one please?

Works like a charm! I've put the box in a reboot loop again,
lets see if it survives until tomorrow :)

Cheers,
Thomas
