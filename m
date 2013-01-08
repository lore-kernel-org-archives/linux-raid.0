From: Chris Murphy <lists@colorremedies.com>
Subject: Re: How do I tell which disk failed?
Date: Mon, 7 Jan 2013 22:55:52 -0700
Message-ID: <87128B0B-8DE8-44F5-90BE-5E93F81ADEA2@colorremedies.com>
References: <1357610701.16366.13.camel@corn.betterworld.us>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1357610701.16366.13.camel@corn.betterworld.us>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 7, 2013, at 7:05 PM, Ross Boylan <ross@biostat.ucsf.edu> wrote:
> 
> Personalities : [raid1]
> md0 : active raid1 sda1[0] sdc2[2] sdb2[1]
> 
> 
> md1 : active raid1 sda3[0] sdc4[2] sdb4[1]

fdisk -l ?

Where are sda2, sdc1, sdc3, sdb1, sdb3?

Chris Murphy
