From: ptb@lab.it.uc3m.es (Peter T. Breuer)
Subject: Re: Spares and partitioning huge disks
Date: Sat, 15 Jan 2005 11:33:58 +0100
Message-ID: <m58nb2-idr.ln1@news.it.uc3m.es>
References: <4m4nb2-20f.ln1@news.it.uc3m.es> <Pine.LNX.4.44.0501151050110.3584-100000@uplift.swm.pp.se>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Abrahamsson <swmike@swm.pp.se> wrote:
> if read error then
>   recreate the block from parity
>   write to sector that had read error
>   wait until write has completed
>   flush buffers
>   read back block from drive
>     if block still bad
>       fail disk
>   log result

Well, I haven't checked the RAID5 code (which is what you seem to be
thinking of), but I can tell you that the RAID1 code simply retries a
failed read. Unfortunately, it also ejects the disk with the bad read
from the array.

So it was fairly simple to alter the RAID1 code to "don't do that then".
Just remove the line that says to error the disk out, and let the retry
code do its bit.

One also has to add a counter so that if there is no way left of getting
the data, then the read eventually does return an error to the user.

Thus far no real problem.

The dangerous bit is launching a rewrite of the eaffceted block, which
I think one does by placing the ultimately successful read on the queue
for the raid1d thread, and changing the cmd type to "special", which should
trigger the raid1d thread to do a rewrite from it. But I haven't dared
test that yet.

I'll revisit that patch over the weekend.

Now, all that is what you summarised as

    recreate the block from parity
    write to sector that had read error

and I don't see any need for much of the rest except

    log result

In particular you seem to be trying to do things synchronusly, when
that's not at all necessary, or perhaps desirable. The user will get a
succes notice from the read when end_io is run on the originating
request, and we can be doing other things at the same time. The raid
code really has a copy of the original request, so we can ack the
original while carrying on with other things - we just have to be
careful not to lose the buffers with the read data in them (increment
reference counts and so on).

I'd appreciate Neil's help with that but he hasn't commented on the
patch I published so far!

Peter

