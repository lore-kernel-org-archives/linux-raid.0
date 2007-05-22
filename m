From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm, raid10, and problem
Date: Tue, 22 May 2007 10:43:34 +1000
Message-ID: <18002.15542.445123.221297@notabene.brown>
References: <20070520153535.GA563@ep09.pld-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Maciej 'Agaran' Pijanka on Sunday May 20
Sender: linux-raid-owner@vger.kernel.org
To: Maciej 'Agaran' Pijanka <agaran@pld-linux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday May 20, agaran@pld-linux.org wrote:
> 
> Hello
> 
> 
> i was trying to build raid 10 from six devices (currently loops but need
> to check before i try to do same on physical drives).
> 
> and mdadm gets bit mad, 
> 
> mdadm -C -l10 -n6 /dev/loop1 /dev/loop2 /dev/loop3 missing missing
> missing
> produced weird result 

What did you expect :-?

> mdadm: RUN_ARRAY failed: Input/output error
> mdadm: stopped /dev/md0

Yes, lots of mdadm's errors are - like this - quite unhelpful.  It is
something that I would like to get improved, but it just doesn't get a
high priority.

> -from dmesg:
> md: bind<loop0>
> md: bind<loop1>
> md: bind<loop2>
> md: md0: raid array is not clean -- starting background reconstruction
> raid10: not enough operational mirrors for md0

"not enough" means "you don't have the right drives".

For every level other than raid10, it doesn't matter which drives you
have, it just matter how many there are.
For raid10, you do that to have are set of drives that provides all
blocks.  But I just re-used the error message from raid1.

Patches always welcome...

NeilBrown
