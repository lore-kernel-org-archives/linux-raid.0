From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Sun, 27 Jan 2013 19:16:46 -0700
Message-ID: <2C80C970-FE4F-4CFE-8F40-48BE14F3140F@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de> <5105D0EA.7080100@turmel.org> <6BCDA3B1-C137-486D-A45D-55912207AF3C@colorremedies.com>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6BCDA3B1-C137-486D-A45D-55912207AF3C@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, Brad Campbell <lists2009@fnarfbargle.com>
Cc: Wolfgang Denk <wd@denx.de>, "linux-raid@vger.kernel.org Raid" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 27, 2013, at 6:42 PM, Chris Murphy <lists@colorremedies.com> wrote:

> The mismatch number is not divisible by 16, yet your chunk size is 16KB. It is divisible by 4 and 8, so I'm going to guess that the physical sector size is 4096 bytes. If correct, I'm coming up with a maximum of 346GiB worth of sectors may be adversely affected, assuming every sector in the mismatch count is bad (which is probably not true, but could be).

Since the upgrade to Fedora 18 for this particular RAID 6, can you estimate how much data has been written to the array? Could it be in the 90GiB to 350GiB range?

On Jan 27, 2013, at 7:07 PM, Brad Campbell <lists2009@fnarfbargle.com> wrote:
> 
> Massive mismatch counts are indicative of an insidious problem further down the storage stack. Check your drivers, cards, cables and PSU.

Yeah, this may be difficult, but I think the array needs to be remounted ro or unmounted. The writes may be killing it. But there's not enough information yet to know, it's smoke but no fire so far.

man 4 md says the same, for raid 5 and 6, mismatches are not expected to be software problems, but much more likely hardware. But if it's true that the OP's problems started exactly with the upgrade to Fedora 18, that it could be a device driver. What HBA is being used?


Chris Murphy

