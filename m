From: David Rees <drees76@gmail.com>
Subject: Re: High IO Wait with RAID 1
Date: Fri, 13 Mar 2009 15:10:04 -0700
Message-ID: <72dbd3150903131510p58c85cf6pdd70f11330774958@mail.gmail.com>
References: <407601c9a405$d3d76b6a$e90df40a@exchange.rackspace.com>
	 <7d86ddb90903131129k2fa7d98ah636320c9a3b78259@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb90903131129k2fa7d98ah636320c9a3b78259@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: David Lethe <david@santools.com>, Bill Davidsen <davidsen@tmr.com>, Alain Williams <addw@phcomp.co.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 13, 2009 at 11:29 AM, Ryan Wagoner <rswagoner@gmail.com> wrote:
> The other system with the onboard ICH controller exhibits the same
> symptoms so I think my card is configured correctly. The interesting
> part of this is I can kick off a resync on all three RAID volumes and
> the system load and io wait is low. The rebuild rate is 85M/s for the
> RAID 5 volume and 65M/s for the RAID 1 volumes, which is the max each
> individual drive can do.

The load from rebuilding the raid doesn't show up in system load or io
wait as it's done in-kernel.  If you run some other IO intensive
processes during the rebuild you should notice that it will run a bit
slower and io wait should be higher.

-Dave
