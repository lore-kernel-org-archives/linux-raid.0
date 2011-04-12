From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: raid1 boot regression in 2.6.37 [bisected]
Date: Tue, 12 Apr 2011 16:05:52 +0200
Message-ID: <201104121605.52443.thomas.jarosch@intra2net.com>
References: <201103251725.21180.thomas.jarosch@intra2net.com> <20110405134629.664b946c@notabene.brown> <20110406101600.GB4142@mtj.dyndns.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110406101600.GB4142@mtj.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

On Wednesday, 6. April 2011 12:16:00 Tejun Heo wrote:
> > To put it another way matching your description Tejun, the put path has
> > a chance to run firstly while mddev_find is waiting for the spinlock,
> > and then while flush_workqueue is waiting for the rest of the put path
> > to complete.
> 
> I don't think the logic is wrong per-se.  It's more likely that the
> implemented code doesn't really follow the model described by the
> logic.
> 
> Probably the best way would be reproducing the problem and throwing in
> some diagnostic code to tell the sequence of events?  If work is being
> queued first but it still ends up busy looping, that would be a bug in
> flush_workqueue(), but I think it's more likely that the restart
> condition somehow triggers in an unexpected way without the work item
> queued as expected.

I can test any debug patch you want, the box is in a test lab anyway.

Best regards,
Thomas
