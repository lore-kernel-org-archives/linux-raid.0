From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: feature re-quest for "re-write"
Date: Mon, 24 Feb 2014 14:14:55 +0000
Message-ID: <BLU0-SMTP340FC1C74C40495FA5F94298860@phx.gbl>
References: <alpine.DEB.2.02.1402211903030.15054@uplift.swm.pp.se>
	 <530AA09B.3090708@fnarfbargle.com> <530AA460.602@eyal.emu.id.au>
	 <530AAA55.2080508@fnarfbargle.com> <530ABF21.7030200@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <530ABF21.7030200@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: list linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


> # echo 3 >'/proc/sys/vm/drop_caches'
> # dd if=/dev/md127 of=/dev/null count=$((20*1024*1024))
> 20971520+0 records in
> 20971520+0 records out
> 10737418240 bytes (11 GB) copied, 13.5717 s, 791 MB/s
> 
> Note that I do not expect to get an error because reading the array will not read the P/Q checksums
> (it assumes good data and avoids the calculations overhead of verifying P/Q).
> 
> BTW, due to the use of a buffer layer I could have done the whole test using 4k blocks rather than
> sectors, but it makes no difference in this case.
> 
> Eyal
> 

I wonder, could you not use dd to perform a "refresh"?

dd if=/dev/md127 of=/dev/md127 count=... bs=....

As that would force a re-calc and write of P & Q and data.

That said, its just a "could you/would it" suggestion not a "do it" due
to the inherent dangers of dd.


