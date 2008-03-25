From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: performance problems with raid10,f2
Date: Tue, 25 Mar 2008 13:22:03 +0000
Message-ID: <18408.64635.201923.65782@tree.ty.sabi.co.uk>
References: <20080314231151.GA14568@rap.rap.dk>
	<20080320172817.GA27070@rap.rap.dk>
	<18408.35320.92714.891870@notabene.brown>
	<20080325103656.GA4911@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080325103656.GA4911@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>>> I have a 4 drive array with 1 TB Hitachi disks, formatted
>>>> as raid10,f2 I had some strange observations: 1. while
>>>> resyncing I could get the raid to give me about 320 MB/s in
>>>> sequential read, which was good. After resync had been
>>>> done, and with all 4 drives active, I only get 115 MB/s.

[ ... ]

>> Is this with, or without, your patch to avoid "read-balancing"
>> for raid10/far layouts?  It sounds like it is without that
>> patch ????

> I tried both without the patch and with the patch, with almost
> same resulte.

That could be the usual issue with apparent pauses in the stream
of IO requests to the array component devices, with the usual
workaround of trying 'blockdev --setra 65536 /dev/mdN' and see if
sequential reads improve.

> Is resync building some table, and could that be it?  Or could
> it be some time of inode traffic?

One good way to see what is actually happening is to use either
'watch iostat -k 1 2' and look at the load on the individual MD
array component devices, or use 'sysctl vm/block_dump=1' and look
at the addresses being read or written.
