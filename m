From: Ronny Plattner <ronny_p@gmx.net>
Subject: Re: once again raid5
Date: Thu, 31 Mar 2005 15:15:33 +0200
Message-ID: <d2gt2h$ha4$1@sea.gmane.org>
References: <d2gr28$aeb$1@sea.gmane.org> <16971.62329.939077.933653@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16971.62329.939077.933653@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Neil Brown schrieb:
> It looks like hdi1 doesn't think it is an active part of the array. 
> It is just a spare. 
> It is as-though the array was not fully synced when hdm1 (?) failed.

Mhm.

> Looking back through previous emails, it looks like you had 2 drive
> fail in a raid5 array.  This means you lose. :-(

hdm is since 2 weeks stable with 3 reallocated sectors...so, maybe no 
much data is lost.

> Your best bet would be:
> 
>   mdadm --create /dev/md2 --level 5 -n 4 /dev/hda1 /dev/hdk1 missing  /dev/hdo1
> 
> and hope that the data you find on md2 isn't too corrupted.  You might be

Okay. But, isnt it better to use build instead of create? In the the 
manpages (printed 5.4.2004) ...i can see

-snip-
mdadm -build device ..... -raid-devices=Z devices

This usage is similar to --create. The difference is that it creates a 
legacy array without a superblock. With these arrays there is no 
difference between initially creating the array and subsequently 
assembling the array, except that hopefully there is useful data there 
in the second case.
-snap-

> lucky, but I'm not holding my breath - sorry.

Thank you :-)  ... so, there are no problems with the superblocks?

Regards,
Ronny

