From: Florian Lampel <florian.lampel@gmail.com>
Subject: Re: RAID6 dead on the water after Controller failure
Date: Sat, 15 Feb 2014 13:31:46 +0100
Message-ID: <5269CCC7-A0A7-479E-9738-88C74CB19435@gmail.com>
References: <7A417EAE-106E-4541-941F-1002696F8735@gmail.com> <52FE7E2D.8020308@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 7.1 \(1827\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52FE7E2D.8020308@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

first of all - thanks to Phil Turmel for pointing me in the right direction. I checked all the cables and true enough, the System SSD's cable's shielding was halfway peeled off.

Anyway, the current state is as follows:

*) The missing HDDs came up right after the reboot, and I had to use the "bootdegraded=true" kernel option.
*) All 12 drives are functional.

Here is a link to the requested output of 

--- mdadm -E /dev/sd[abcd]1 ---
--- for x in /dev/sd[a-z] ; do echo $x : ; smartctl -x $x ; done ----

as well as

---- mdadm --examine /dev/sd[abcdefghijklmnop]1 ------


Link:
h__p://pastebin.com/v6yzn3KX

My findings:
The Event count does differ, but not by much. As my next step, I would follow Phil Turmel's advice and reassemble the Array using the --force option, to be precise:

mdadm -Afv /dev/md0 /dev/sd[abcdefgjklm]1

Could you please advise me wether this next step is all right to do now that we have new logs etc.?

Thanks in advance,
Florian Lampel

PS: Thanks again to Phil for pointing out that --create would be madness.