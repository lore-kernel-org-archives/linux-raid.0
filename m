From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Mon, 2 May 2011 14:17:50 +0200
Message-ID: <201105021417.51280.thomas.jarosch@intra2net.com>
References: <201103251725.21180.thomas.jarosch@intra2net.com> <20110428112328.07cf4578@notabene.brown> <201104281547.40899.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <201104281547.40899.thomas.jarosch@intra2net.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

On Thursday, 28. April 2011 15:47:40 Thomas Jarosch wrote:
> > Could you try this one please?
> 
> Works like a charm! I've put the box in a reboot loop again,
> lets see if it survives until tomorrow :)

Patch is working fine, the box survived rebooting for several days.

Thanks,
Thomas
