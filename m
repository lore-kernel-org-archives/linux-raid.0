From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: readahead (blockdev --setra) with sw raid(5)?
Date: Tue, 30 Nov 2004 13:18:58 +1100
Message-ID: <16811.55442.206604.468078@cse.unsw.edu.au>
References: <Pine.LNX.4.61.0411272328270.16979@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephan van Hienen on Saturday November 27
Sender: linux-raid-owner@vger.kernel.org
To: Stephan van Hienen <raid@a2000.nu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday November 27, raid@a2000.nu wrote:
> Hi,
> 
> just saw a 3ware document with some hints for hardware raid5
> they advice to use blockdev --setra 16384
> 
> since i'm not using 3ware hardware raid
> (i'm using 2*7500 3ware's with sw raid5 over 14 disks)
> i'm wondering if --setra can still improve my raid performance

--setra large can improve sequential read performance for any device,
possibly at the cost of reducing random-io bandwidth or using up
memory that other applications might want (I'm not sure what the exact
trade-off is).

md sets the read-ahead number for raid0/4/5/6 to be twice the stripe
size. i.e. chunksize * number of data disks * 2.

> 
> any hints about this ?
> or some other hints, improvements on filesystem ?
> i'm currently using blocksize 128, maybe switching to 256 helps ? (with 
> large files)

It might help large sequential reads, but might hurt smaller reads.

Some testing I did a couple of years ago (and so is probably
out-of-date) suggested that after about 128K, the returns from
doubling chunk size diminished very quickly.


This sort of tuning is very dependant on work load.  If you have just
one application that does lots of very large sequential reads, then
large chunk size and large 'ra' are good.  Otherwise ... it is hard to
know.

NeilBrown

> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
