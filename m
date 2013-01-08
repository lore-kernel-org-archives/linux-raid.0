From: Chris Murphy <lists@colorremedies.com>
Subject: Re: How do I tell which disk failed?
Date: Tue, 8 Jan 2013 01:48:29 -0700
Message-ID: <F5C2E9CA-635E-4FA5-9C20-EB0F6AE94838@colorremedies.com>
References: <1357610701.16366.13.camel@corn.betterworld.us> <50EBAC5D.8080000@hardwarefreak.com> <1357628351.16366.86.camel@corn.betterworld.us> <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com> <1357631387.16366.131.camel@corn.betterworld.us>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357631387.16366.131.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 8, 2013, at 12:49 AM, Ross Boylan <ross@biostat.ucsf.edu> wrote:
> 
> The raw value (last column) for one of the parameters seems to be
> changing extremely rapidly, and perhaps is overflowing:
> # date; smartctl -a /dev/sda | grep 195
> Mon Jan  7 23:11:03 PST 2013
> 195 Hardware_ECC_Recovered  0x001a   059   024   000    Old_age   Always       -       241377818
> # date; smartctl -a /dev/sda | grep 195
> Mon Jan  7 23:12:26 PST 2013
> 195 Hardware_ECC_Recovered  0x001a   056   024   000    Old_age   Always       -       3600778

Not good. The current value is 56, the worst is 24, and the threshold is 0. These are high values. The firmware is doing its job in that it's fixing errors. But the fact it has to at this rate is not a good sign. Post sda's full attribute list.

Is this disk under warranty? If it is I'd just get rid of it.


Chris Murphy