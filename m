From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Is my RAID broken?
Date: Mon, 6 Nov 2006 10:45:25 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0611061044070.5535@uplift.swm.pp.se>
References: <e50d039c0611042329m29046e6fjf56a8f52a82294ad@mail.gmail.com>
 <17742.25624.469667.437194@cse.unsw.edu.au> <Pine.LNX.4.64.0611060858260.5535@uplift.swm.pp.se>
 <Pine.LNX.4.64.0611060015180.20361@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0611060015180.20361@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 6 Nov 2006, dean gaudet wrote:

> it should be only once a month... and it's just a "check" -- it reads
> everything and corrects errors.

If you have a recent enough kernel, yes. I used 2.6.15 and it would 
actually rebuild, I think it was 2.6.16 that does correct "read and 
compare".

> i think it's a great thing actually... way more useful than smart long
> self-tests because md can reconstruct read errors immediately -- before
> you lose redundancy in that stripe.

Quite, I highly recommend doing this on all RAID sets including hardware 
ones (3ware for instance) once a week.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
