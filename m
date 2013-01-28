From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Huge values of mismatch_cnt on RAID 6 arrays under Fedora 18
Date: Mon, 28 Jan 2013 10:07:46 +0800
Message-ID: <5105DD72.6080909@fnarfbargle.com>
References: <20130127192656.634892005AD@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130127192656.634892005AD@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 28/01/13 03:26, Wolfgang Denk wrote:
> I have seen "mismatch_cnt is not 0" warnings in the past, but that has
> always been with RAID 1 arrays, and with relatively small numbers on
> /sys/block/md*/md/mismatch_cnt; my understanding was that this was not
> actually critical.
>
> However, after updating to Fedora 18, I get this message from all
> updated
> systems that have RAID 6 arrays, and with _huge_ numbers of
> mismatch_cnt, like that:

I saw this when I put two drives from a 10 drive RAID6 on a sil3124 
card. Unfortunately by the time I figured out what was going on my array 
was trashed.

Massive mismatch counts are indicative of an insidious problem further 
down the storage stack. Check your drivers, cards, cables and PSU.

