From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: once again raid5
Date: Thu, 31 Mar 2005 22:56:25 +1000
Message-ID: <16971.62329.939077.933653@cse.unsw.edu.au>
References: <d2gr28$aeb$1@sea.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Ronny Plattner on Thursday March 31
Sender: linux-raid-owner@vger.kernel.org
To: Ronny Plattner <ronny_p@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 31, ronny_p@gmx.net wrote:
> Hi,
> 
> we still have troubles with our raid5 array. You can find the history of 
> the fault in detail in my other postings (11.3.2005).
> 
> I will show you my attempts.
> 
> There are 4 discs (Maxtor 250GB) in a raid5-array. One disc failed and 
> we sent it back to Maxtor. Now, the array consists of 3 discs.
> I tried to reassemble it,
> 
> mdadm -A --run --force /dev/md2 /dev/hdi1 /dev/hdk1  /dev/hdo1
> 
> but i got an error:
> 
> -snip-
> mdadm: failed to RUN_ARRAY /dev/md2: Invalid argument
> -snap-

It looks like hdi1 doesn't think it is an active part of the array. 
It is just a spare. 
It is as-though the array was not fully synced when hdm1 (?) failed.

Looking back through previous emails, it looks like you had 2 drive
fail in a raid5 array.  This means you lose. :-(

Your best bet would be:

  mdadm --create /dev/md2 --level 5 -n 4 /dev/hda1 /dev/hdk1 missing  /dev/hdo1

and hope that the data you find on md2 isn't too corrupted.  You might be
lucky, but I'm not holding my breath - sorry.

NeilBrown
