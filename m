From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mismatch sector in range, kernel 4.13
Date: Tue, 5 Sep 2017 08:25:58 +0200 (CEST)
Message-ID: <alpine.DEB.2.20.1709050824290.29378@uplift.swm.pp.se>
References: <20170905003950.6dtfdoxpbadxiibu@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170905003950.6dtfdoxpbadxiibu@merlins.org>
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 4 Sep 2017, Marc MERLIN wrote:

> The part where I'm a bit confused is that I have btrfs on top, which has 
> per data and metadata block checksums, and all those checksums come out 
> fine (I did a full btrfs scrub on the entire filesystem).
>
> Given this, what is the suggested course of action?

If the data section is fine (which it seems to be because btrfs is happy), 
then you should issue "repair" to correct parity.

"echo repair > /sys/block/mdX/md/sync_action"

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
