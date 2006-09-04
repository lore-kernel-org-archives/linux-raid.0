From: Josh Litherland <josh@temp123.org>
Subject: Re: Superblock checksum problems
Date: Mon, 04 Sep 2006 17:54:53 -0400
Message-ID: <1157406893.2990.22.camel@localhost>
References: <1157236610.8070.7.camel@localhost>
	 <17659.46517.979409.131348@cse.unsw.edu.au>
	 <1157385612.2990.4.camel@localhost> <1157403347.2990.11.camel@localhost>
	 <1157404398.2990.14.camel@localhost>
	 <17660.39978.663609.990424@cse.unsw.edu.au>
Reply-To: josh@temp123.org
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17660.39978.663609.990424@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2006-09-05 at 07:35 +1000, Neil Brown wrote:

> Try
>  for i in `seq 1 20`; do
>   dd if=/dev/sda of=/tmp/try-$i conv=direct
>  done
>  for i in `seq 2 20`; do
>   cmp -l /tmp/try-1 /tmp/try=$i
>  done

I tried a variant of this:

for i in `seq 1 20`; do
	dd if=/dev/sda1 of=/tmp/try-$i count=4 bs=4096 iflag=direct 
	sleep 0.25
done

Tried it with and without the sleep, on all 4 drives.  In all cases, the
20 "try" files were identical.

-- 
Josh Litherland (josh@temp123.org)

