From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: RE: Single md physical device limit
Date: Tue, 20 Aug 2002 07:01:10 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15713.23702.808856.809290@notabene.cse.unsw.edu.au>
References: <CDF05CB9FCA0C845B9778F9E463C476101FC63@cinshrexc01.shermfin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Rechenberg, Andrew on Monday August 19
To: "Rechenberg, Andrew" <ARechenberg@shermanfinancialgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday August 19, ARechenberg@shermanfinancialgroup.com wrote:
> Interesting, when I initially built my array (with RedHat raidtools-0.90
> not mdctl/mdadm, on kernel 2.4.17) it stated that I could only stripe
> across 12 devices.  Do you have any idea from which this number comes?
> Is it an old limit?

Yes, some old limit.  I don't remember the exact details, they were
never important to me, but I think it involved some miscalculation
about how many entries would actually fit in the 4096 byte superblock.

Hopefully 2.6 will have a much higher limit (using an optional
different superblock format).

NeilBrown
