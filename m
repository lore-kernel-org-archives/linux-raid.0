From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: A general Raid 5 question
Date: Mon, 4 Jul 2005 16:35:01 +1000
Message-ID: <17096.55445.909008.12947@cse.unsw.edu.au>
References: <5d96567b050622103157ada455@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Raz Ben-Jehuda(caro) on Wednesday June 22
Sender: linux-raid-owner@vger.kernel.org
To: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday June 22, raziebe@gmail.com wrote:
> If I pull the plug out from my machine while io is being generated. 
> Is there a chance that  i would loose the raid ( obviously i would
> loose some data).
> I am refering to raid with no backup battery unit or anything of that sort.
> 
> I tried to do it and the worst case was that the rebuilding was long (
> both in software raid and hardware raid -- 3ware ).
> 
> I would appreciate answers

"Pulling the plug" can cause physical harm.  It  probably isn't
common, and probably only affects cheaper hardware, but it can happen.
Electrical spikes or other sudden changes may not be what the device
was designed to handle.

If you pull the plug and hurt two drives of a raid5 array, you lose.

So yes, it can happen.  But is less likely to happen with better
quality components.
Possibly the old adage "RAID doesn't replace backups" applies.

NeilBrown
