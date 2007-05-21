From: "Bill Rugolsky Jr." <brugolsky@telemetry-investments.com>
Subject: Re: Adding larger disks to RAID5
Date: Mon, 21 May 2007 19:57:35 -0400
Message-ID: <20070521235735.GA26776@ti88.telemetry-investments.com>
References: <465204AA.90301@dhp.com> <18002.11374.159035.143026@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18002.11374.159035.143026@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Christian <cjs@dhp.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

What seems desirable to me is a way to take a new (larger) spare drive and
add it to a RAID1 for a particular RAID 4/5/6 component, and then when
it's sync'd, replace the now redundant small drive with another larger
drive.  Wash, rinse, repeat.  This way the array is never degraded.
Though I imagine that this particular arrangement doesn't have the
benefit of the stripe rewrite when encountering a latent error on the
drive that is being migrated.  [Presumably the failing addresses could
be cycled through the check from userland though, by doing a read above
the stacked RAID.]

One could start a RAID 4/5/6 array over a degraded RAID1 for each
component, (i.e., a degraded RAID1).

I haven't been following the metadata changes closely.  Is it possible
to do this with external MD metadata?  It can also be done with
device-mapper, but dm-mirror is very immature compared to MD RAID1.

Comments?

Regards,

	Bill Rugolsky
