From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: read errors not corrected when doing check on RAID6
Date: Sun, 12 Jan 2014 16:49:27 +0000
Message-ID: <21202.51095.833898.785557@tree.ty.sabi.co.uk>
References: <alpine.DEB.2.02.1401120723010.20074@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1401120723010.20074@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
> So here now in the replace function, md decided to correct the
> read errors on /dev/sds. Now the pending sectors are down to 7
> on /dev/sds. There were some more errors which were also
> corrected, and now the pending count is down to 5. Recovery is
> still ongoing. [ ... ]  I expected it to correct the read
> errors on the drive then, but it seems it didn't. [ ... ]

That seems to me a big misunderstanding (or delusion).
