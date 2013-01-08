From: Chris Murphy <lists@colorremedies.com>
Subject: Re: How do I tell which disk failed?
Date: Tue, 8 Jan 2013 00:17:25 -0700
Message-ID: <02B6762C-3755-4CE3-9AB1-A48D3384CACB@colorremedies.com>
References: <1357610701.16366.13.camel@corn.betterworld.us> <50EBAC5D.8080000@hardwarefreak.com> <1357628351.16366.86.camel@corn.betterworld.us>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357628351.16366.86.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 7, 2013, at 11:59 PM, Ross Boylan <ross@biostat.ucsf.edu> wrote:
>> 
> Isn't it possible there's a hardware problem, e.g., leading to a
> failure/retry cycle?

smartctl -a /dev/sda
smartctl -a /dev/sdb
smartctl -a /dev/sdc

Compare them. If there was a write failure reported by the drive, md would have marked the device faulty.

Chris Murphy