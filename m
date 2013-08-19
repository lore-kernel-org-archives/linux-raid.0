From: Roberto Spadim <rspadim@gmail.com>
Subject: Re: Small chunk size read performance penalty
Date: Mon, 19 Aug 2013 00:01:47 -0300
Message-ID: <CAH3kUhEr1o5n4Fgvz_4MV+o2fJ4h085fsHhK57szSB9y7rA9Dw@mail.gmail.com>
References: <kurge6$qi0$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <kurge6$qi0$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ian Pilcher <arequipeno@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

HI Ian
just some points that you should consider... it's an idea about the
theory... don't think it's a main guide to linux-raid or anything
else...

some basic things... a disk have one head arm, in other words it can
read/write a sequence of bits, move, read/write more bits, move... etc

when you use strip (raid-0, 5, 6, raid 10) you change how data is
write, instead of a continous byte stream, you divide it in chunks...
chunk 1 at disk 1 position 0, chunk 2 at disk 2 position 0, chunk 3 at
disk1 position 1 .... etc... this place each disk close to one
specific chunk
example... considering a read from position 0 to last position of
array: the disk used = chunk id % number_of_disks, with a chunk of
128MB and two disks, and reading 1GB you will read 0-128MB from disk
1, 128-256MB from disk 2, 256-384MB  from disk 1 ... etc

when you read more than one chunk, you use two heads arms (two disks)
here you have speed boost, you must check what is the best chunk size
for your work load, (and chunk should only be used when need, on some
workloads raid1 is better)

using two head you can read/write faster, but this is only nice for
continous stream...
when you need parallel works (many thread) you can use raid1 for read
in parallel since it don't have chunks it can read data with only one
disk, in other words... the workload can (when possible) be shared for
1 disk / thread, if you have 10 disks using raid-1, you can have a
nice performace for 10 threads without problems, for write the slowest
disk will stall the write performace, but you should consider what you
need...

that's a superficial explain, the implementation can be a bit
different, but explain the idea about the use of chunks

the workload tell what's better
in my system sometimes raid1 is better than raid10 because i have many
threads reading diferent parts of disk, in this case i can add many
heads arms (disks) one for each important thread, and i have a good
performace (considering a high load system), but if you need fast
continous read, the chunk is VERY good
for example if you need a read of 1GB, and have 10 disks, you can have
a performace of 10x with a good chunk size, since each disk will be
used when a chunk read is requested, and each disk can read parallel
and continous (without many head movement)
if you put a chunk size of 1GB and you need a read of 1GB, you don't
have any performace boost from chunks...

the best thing to do is TEST with your workload
i think this can help, if not delete from your mail box :)
