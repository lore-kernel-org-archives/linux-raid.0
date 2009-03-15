From: Christopher Chen <muffaleta@gmail.com>
Subject: Best Practices for a Virtualized Tira Misu md Setup
Date: Sat, 14 Mar 2009 19:36:02 -0700
Message-ID: <7bc80d500903141936p64bb0595xc07d4c8a4e9a3cdd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I've got more layers than I can count.

However, I wanted to ask about what people consider to be best
practices regarding linux software raid over large numbers of drives
(> 50). I'm not creating groups that big, but in the aggregate, I'm
trying to have md manage about 56 spindles in 10 separate raid groups.
The drives themselves are 73G fibre channel, 10k. The decision has
been made to trade off sheer speed for capacity (since the drives
themselves are small), so they are arranged in raid 5 groups rather
than 10. Write speed has been good, relatively-- 160 MB/sec writes,
110 MB/sec reads for a six disk group. Since the drives are pretty old
at this point, I'm happy.

So far, I haven't seen any horrible problems with the md layer--after
increasing the size of the stripe cache, my write speeds began to look
normal.

Im setting this all up for iscsi export, in a DRBD and LVM sandwich.
Obviously, I expect to lose some performance in the assemblage, but I
did want to ask about readahead.

When you have a physical device that's part of an md that's part of a
logical volume, not to mention a drbd pseudo block device, you've got
a lot of places to set readahead using blockdev or lvchange. My
question is--where would one start to adjust, if at all? Mdadm creates
my md device with a readahead of chunk x 10. When I create a logical
volume on top of that, should I adjust it's read ahead? For my base
physical devices, should I leave them at 256 or change them?

Obviously there's no right answer--if I increase the read-ahead too
much, I'll kill my random performance, but given the fact that iscsi
is going to throw a fair bit of latency into the loop, I may have to
increase read ahead to get sequential read access up.

And there's the initiator side to deal with.

I just wanted to write the list and gather any thoughts people might have.

Cheers

cc

-- 
Chris Chen <muffaleta@gmail.com>
"I want the kind of six pack you can't drink."
-- Micah
