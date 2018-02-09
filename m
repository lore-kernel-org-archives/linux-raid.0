From: Kay Diederichs <kay.diederichs@uni-konstanz.de>
Subject: Re: force remapping a pending sector in sw raid5 array
Date: Fri, 9 Feb 2018 22:17:12 +0100
Message-ID: <c4f452ea-eca8-c94c-d871-63688e923d51@uni-konstanz.de>
References: <20180206181416.amo6geclrvc6ylrf@merlins.org>
 <aedfc1ac-a95f-b20f-2713-87cf412afdf4@uni-konstanz.de>
 <20180209192928.vliiwkv6q76jf6jp@merlins.org>
 <1227ce39-31af-22f2-f4fa-de85466f05c7@turmel.org>
 <20180209202958.6mieeomu5of45rjf@merlins.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20180209202958.6mieeomu5of45rjf@merlins.org>
Content-Language: en-MW
Sender: linux-raid-owner@vger.kernel.org
To: Marc MERLIN <marc@merlins.org>, Phil Turmel <philip@turmel.org>
Cc: Andreas Klauer <Andreas.Klauer@metamorpher.de>, Adam Goryachev <mailinglists@websitemanagers.com.au>, Roger Heflin <rogerheflin@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/09/2018 09:29 PM, Marc MERLIN wrote:

...
> 
> myth:~# badblocks -fsvnb512 /dev/sdh 1287409599 1287409400
> /dev/sdh is apparently in use by the system; badblocks forced anyway.
> Checking for bad blocks in non-destructive read-write mode

badblocks gives a warning that /dev/sdh is in use. You should not use it
that way (needing the -f option), because essentially you are messing
with the drive behind md's back.
Remove /dev/sdh from the array before you use badblocks, or hdparm, or
dd or the like on a member device.

Kay

