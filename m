From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: md-raid5, dm-crypt, alignment and readahead
Date: Mon, 10 Mar 2008 21:37:16 +0000
Message-ID: <18389.43532.913309.862144@tree.ty.sabi.co.uk>
References: <bb145bd20803100910l6cfe250bs631184b493a23e04@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20803100910l6cfe250bs631184b493a23e04@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


[ ... careful RAID5 test ... ]

The test is fairly careful, but your chunk size of 1MB is a bit
huge. Not a good idea for sequential reads for example.

pernegger> Writes: 182MB/s
pernegger> - that's 81% of the write performance of 3 disks in parallel
pernegger> - iostat shows that during writes the load is evenly
pernegger>   distributed over the component disks, but also that
pernegger>   there are *reads* going on in parallel, if
pernegger>   slowly.
          
pernegger> Why is that? The dd block size should be a full
pernegger> stripe and in any case large enough to be combined
pernegger> into one. When I do some badly misaligned writes on
pernegger> purpose the "MB_read/s" values are about 10-15 times
pernegger> higher, so it's not raid5 read-modify-write cycles,
pernegger> but what is it reading?

My guess is that the reads and writes that you do get rearranged
by the page cache and not necessarily all will remain stripe
aligned. I would make sure that 'syslog' is logging debug-level
messages to a named pipe, say '/dev/xconsole', 'cat' it, and
then 'sysctl vm/block_dump=1' to see the stream of IO operations
and check where the reads are.

pernegger> How is readahead handled when "stacked" virtual block
pernegger> devices are involved? Does only the top layer count,
pernegger> does each layer read ahead for itself and if it does
pernegger> is the data used at all?

Good question. From some quick testing I did in the MD block
device on top of disk block device case the readhead that
matters is the top level one. I tried to follow the logic in the
code, but a bit opaque. I suspect that it depends on the type of
request function the upper layer uses to issues requests to the
lower layer.

pernegger> Considering the past reports on dm-crypt-on-md data
pernegger> corruption - what is a good data corruption test I
pernegger> can leave running for a few days and at least hope
pernegger> that everything is fine if it passes?

I personally like 'loop-AES', and it is seems to be particularly
reliable, and has some very good encryption code builtin.
