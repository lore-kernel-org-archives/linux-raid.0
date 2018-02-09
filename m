From: Wol's lists <antlists@youngman.org.uk>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Fri, 9 Feb 2018 22:07:57 +0000
Message-ID: <3345d6f0-80d0-bfaf-9974-a7472d499117@youngman.org.uk>
References: <20180209192928.vliiwkv6q76jf6jp@merlins.org>
 <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org>
 <20180209202958.6mieeomu5of45rjf@merlins.org>
 <59144df0-35b7-942f-22c8-754afd0f89c4@uni-konstanz.de>
 <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <aedfc1ac-a95f-b20f-2713-87cf412afdf4@uni-konstanz.de>
 <20180209192928.vliiwkv6q76jf6jp@merlins.org>
 <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org>
 <20180209202958.6mieeomu5of45rjf@merlins.org>
 <5947e803-b1e8-b530-4935-df126f867213@turmel.org>
 <20180209212252.GN9565@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180209212252.GN9565@merlins.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, Phil Turmel <philip@turmel.org>, Kay Diederichs <kay.diederichs@uni-konstanz.de>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/02/18 21:22, Marc MERLIN wrote:
> Interesting. I figured once a sector went pending once, it would not actually be re-used and
> be remapped on the next write. Seems like it didn't happen here.

Because there's all sorts of reasons a sector can go pending.

My favourite example is to compare it to DRAM. DRAM needs refreshing 
every couple of seconds, otherwise it loses its contents and cannot be 
read, but it's perfectly okay to rewrite and re-use it.

Likewise, the magnetism in a drive can decay such that the data is 
unreadable, but there's nothing actually wrong with the drive. (If the 
data next door is repeatedly rewritten, the rewrite can "leak" and trash 
nearby data ...) The decay time for that should be years.

The problem of course is when the problem has a decay time measured in 
minutes or hours. The rewrite succeeds, so the sector doesn't get 
remapped, but when you next read it it has died :-(

Cheers,
Wol
