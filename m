From: David Flynn <davidf@rd.bbc.co.uk>
Subject: Re: md raid5 blocked in get_active_stripe after disk failure
Date: Wed, 19 Jan 2011 13:45:49 +0000
Message-ID: <20110119134549.GE26257@rd.bbc.co.uk>
References: <20110112130420.GA6275@rd.bbc.co.uk>
 <20110112140632.GB6275@rd.bbc.co.uk>
 <20110113073331.687bc941@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20110113073331.687bc941@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: David Flynn <davidf@rd.bbc.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

* NeilBrown (neilb@suse.de) wrote:
> If this is easily reproducible (which I think you suggested it is), I would
> put a printk in raid5_end_read_request where it sets "retry = 1" to report
> "trying to fix a failed read".
>
> If you then get a hang but don't get that message, it is a device driver
> problem.  If you do get that message it is probably an md/raid5 problem.

Thanks for the quick reply.

At the time it was easily reproducible (after rebooting as soon as the
nfs clients retried their requests).  Unfortunately, I had to remove the
disk from the array, and will not be able to test the above until next
month.

Kind regards,

..david
