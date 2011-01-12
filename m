From: NeilBrown <neilb@suse.de>
Subject: Re: md raid5 blocked in get_active_stripe after disk failure
Date: Thu, 13 Jan 2011 07:33:31 +1100
Message-ID: <20110113073331.687bc941@notabene.brown>
References: <20110112130420.GA6275@rd.bbc.co.uk>
	<20110112140632.GB6275@rd.bbc.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110112140632.GB6275@rd.bbc.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: David Flynn <davidf@rd.bbc.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 12 Jan 2011 14:06:32 +0000 David Flynn <davidf@rd.bbc.co.uk> wrote:

> * David Flynn (davidf@rd.bbc.co.uk) wrote:
> > I have a fileserver that mounts an md raid5 array with 20 active disks,
> > holding an xfs filesystem which is then exported via nfs. (system is
> > a twin-quadcore intel, 64bit)
> 
> I ought to mention, this is running 2.6.35.8
> 

Ah... you had already answer that, sorry.

There have been no changes in md since then which could affect your problem,
so if it in an md problem it is still there.

If this is easily reproducible (which I think you suggested it is), I would
put a printk in raid5_end_read_request where it sets "retry = 1" to report
"trying to fix a failed read".

If you then get a hang but don't get that message, it is a device driver
problem.  If you do get that message it is probably an md/raid5 problem.

NeilBrown

