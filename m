From: Mattias Wadenstein <maswan@acc.umu.se>
Subject: Re: random lockups, raid problems SOLVED (plus a question)
Date: Wed, 7 Dec 2005 08:49:46 +0100 (MET)
Message-ID: <Pine.GSO.4.62.0512070843030.19675@shaka.acc.umu.se>
References: <4395F259.1080801@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4395F259.1080801@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Stumpf <mjstumpf@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 6 Dec 2005, Michael Stumpf wrote:

> Sure it's a FAQ.  It's probably even documented.  And, I know it, but it 
> still surprised me.  Such is life:
>
> 2/3 sticks of perfectly good ECC ram in an old server class p3 board 
> apparently have gone bad.  Result?  Random lockups/reboots with nothing in 
> the system logs to even lend a clue.
>
> Memtest86 showed one problem immediately, and after some time, exposed some 
> more.  Remove the bad memory and it works fine.
>
> Is there some daemon that can more actively monitor memory function?  I must 
> have had this problem for months, but with sputtering hard drives that were 
> slowly dying and causing very similar problems, this diagnosis got muddled.

1. Run memtest if you experience instability.

2. Use a system that supports ecc and enable it in bios, that way you are 
likely to get a proper machine fault instead of lockups etc.

Note though, that it is very common for bugs in these systems, our last 3 
clusters over the last 4 years have all had errata on bios showing ecc to 
be enabled but not actually having it enabled.

/Mattias Wadenstein
