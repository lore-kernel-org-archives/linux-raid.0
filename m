From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Sun, 27 Jan 2013 12:45:19 -0700
Message-ID: <CA3C3BC1-A00A-422B-A643-D5323FDC3F6A@colorremedies.com>
References: <20130127192656.634892005AD@gemini.denx.de>
Mime-Version: 1.0 (Mac OS X Mail 6.2 \(1499\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130127192656.634892005AD@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


On Jan 27, 2013, at 12:26 PM, Wolfgang Denk <wd@denx.de> wrote:

> I have seen "mismatch_cnt is not 0" warnings in the past, but that has
> always been with RAID 1 arrays, and with relatively small numbers on
> /sys/block/md*/md/mismatch_cnt; my understanding was that this was not
> actually critical.

Well, you have a block on each drive that's supposed to be identical, and if there's a mismatch that means they're not identical and it's ambiguous which one is correct. So if the data on the drives is unimportant to retrieve correctly, then I guess it's not a critical error.

> 
> However, after updating to Fedora 18, I get this message from all
> updated
> systems that have RAID 6 arrays, and with _huge_ numbers of
> mismatch_cnt, like that:
> 
> fter updating to Fedora 18, I get this message from all updated
> systems that have RAID 6 arrays, and with _huge_ numbers of
> mismatch_cnt, like that:
> 

Bad paste. No messages provided.


> This is with mdadm v3.2.6 (mdadm-3.2.6-7.fc18.x86_64); except for the
> huge values of mismatch_cnt, I see no other indications for errors on
> the disk drives, RAID arrays or the file systems on top of these.
> 
> Is this some known (and hopefully harmless), issue, or must I worry
> about our data?

It means there's a mismatch between parity and data. One of them is wrong, maybe both if there are many errors. So yeah I'd say it sounds like a problem.

What's the smartctl -a look like for all drives? I imagine one or more have bad sectors, ECC errors, or UDMA/CRD errors.


Chris Murphy

