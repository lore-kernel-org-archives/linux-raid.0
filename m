From: Neil Brown <neilb@suse.de>
Subject: Re: Raid 4/5 small writes
Date: Mon, 3 Apr 2006 11:37:09 +1000
Message-ID: <17456.31813.855730.279982@cse.unsw.edu.au>
References: <qlk3bgwt2dp.fsf@clipper.ens.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from  =?ISO-8859-1?Q?=20Ga=EBtan?= LEURENT on Sunday April 2
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Ga=EBtan?= LEURENT <gaetan.leurent@ens.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday April 2, gaetan.leurent@ens.fr wrote:
> Hi,
> 
> I'm considering building a Raid4[#] array for my desktop and I have a
> question about small writes with Raid4/Raid5: when a small part of a
> block is modified, we have two options:
> 
> - read the hole stripe, compute the new checksum and write the data and
>   the checksum
> 
> - read only the part of the data that will be overwritten, and the
>   corresponding part of the checksum.  Since the checksum is a simple
>   XOR, we have:
>      New Checksum = Old Checksum XOR Old Data XOR New Data
>   and we can write the new data and the new checksum without reading
>   more data.
> 
> Does the Linux kernel implements the second way?


Linux/md does the right thing.

If you are writing all the blocks in a stripe, it doesn't read
anything.  It just creates the parity block from the new data and
writes it and the data out.
If you are writing more than half the blocks in the stripe, it
pre-reads the blocks you aren't writing and uses them and the new
blocks to generate parity and writes it and the new data out.
If you are writing fewer than half the blocks in the stripe, it will
do as you suggest, read the old data, work out what the new parity
will be from them and the old parity and the new data, and write out
the parity and new data.

If you are writing exactly half the data in a stripe, I think it takes
the first option (Read the old unchanged data) as that is fewer reads
than reading the old changed data and the parity block.

Does that make sense?

> 
> 
> [#] I'm not doing Raid5 because I have two 120Go drives and two 250Go
>     drives.  I am thinking of making a Raid0 array out of the two small
>     drives, and using that as the parity drive for the Raid4.  I believe
>     this should give better performance than Raid5.

Certainly worth a try.

NeilBrown
