From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Help: very slow software RAID 5.
Date: Fri, 21 Sep 2007 09:00:08 -0400
Message-ID: <46F3C058.1050701@tmr.com>
References: <20070918230914.9FF5910215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709182004210.13217@p34.internal.lan> <20070919014919.DF19D10215F@medulla.enet.sharplabs.com> <Pine.LNX.4.64.0709190437050.4411@p34.internal.lan> <20070919174956.9497310209D@medulla.enet.sharplabs.com> <46F292E2.1090700@tmr.com> <20070920184738.441FD10208C@medulla.enet.sharplabs.com> <46F2E159.9030806@msgid.tls.msk.ru> <20070921005851.44E8910236D@medulla.enet.sharplabs.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070921005851.44E8910236D@medulla.enet.sharplabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Dean S. Messing" <deanm@sharplabs.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dean S. Messing wrote:
> Michael Tokarev writes:
> : Dean S. Messing wrote:
> : []
> : > []  That's what
> : > attracted me to RAID 0 --- which seems to have no downside EXCEPT
> : > safety :-).
> : > 
> : > So I'm not sure I'll ever figure out "the right" tuning.  I'm at the
> : > point of abandoning RAID entirely and just putting the three disks
> : > together as a big LV and being done with it.  (I don't have quite the
> : > moxy to define a RAID 0 array underneath it. :-)
> : 
> : "Putting three disks together as a big LV" - that's exactly what
> : "linear" md module.  
> : It's almost as unsafe as raid0, but with
> : linear read/write speed equal to speed of single drive...
>
> I understand I only get the speed of a single drive was I was not
> aware of the safety factor.  I had intended to use snapshotting off
> to a cheap USB drive each evening.  Will that not keep me safe within a
> day's worth of data change?  I only learned about "snapshots" yesterday.
> I'm utterly new to the disk array/LVM game.
>   

But your read speed need not be limited if you tune the readahead. 
There's also the question of how much transfer speed you actually 
*need*. If your application is CPU-bound faster will not be the same as 
"runs in less time," and random access is limited by the seek speed of 
your drives, although some RAID tuning does apply to random writes.
> For that matter why not run a RAID-0 + LVM  across two of the three drives
> and snapshot to the third?
>
> : Note also that the more drives you add to raid0-like config,
> : the more chances of failure you'll have - because raid0 fails
> : when ANY drive fails.  Ditto - for certain extent - for linear
> : md module and for "one big LV" which is basically the same thing.
>
> I understand the probability increases for additional drives.
>
> : By the way, before abandoming "R" in "RAID", I'd check whenever
> : the resulting speed with raid5 (after at least read-ahead tuning)
> : is acceptable, and use that if yes.
>
> My problem is not quite knowing what "acceptable" is.  I bought a Dell
> Precision 490 with two relatively fast SATA II drives. With RAID 0 I
> attain speeds of nearly 140 MB/s (using 2 drives) for reads and writes
> and the system is very snappy for everything, from processing 4Kx2K
> video to building a 'locate' datebase, to searching my very large mail
> archives for technical info.
>   

When you process video and monitor the system with vmstat, do you see 
significant iowait time? No, neither do I, with a modest readahead I am 
totally CPU limited. If you are searching your mail database, if you 
just use a text tool which reads everything, that's pure sequential 
access. And unless you actually *use* the locate command, building that 
database is just a way to beat your disks (and it's more sequential than 
you would expect). You can turn it off and do your bit to avoid global 
warming.
> When I see the speed loss of software RAID 5 (writes are at 55MB/s and
> random reads are at 54 MB/s) for everything but seq. reads (and that
> only if I increase read-ahead from 512 to 16384 to get read speeds of
> about 110 MB/s I lose heart, esp. since I don't know the other
> consequences of increasing read-ahead by so much.
>   

Assuming that your have enough memory, there would be a small slowdown 
in random reading a lot of small records. You should know what your 
application would do, but that access is typical of looking things up in 
a database or processing small records, like a DNS or mail server. 
Numbers from bonnie or similar benchmarks are nice, but they show 
details of various performance area, and if you don't match "what you 
do" to "what works best" you make bad choices. In other words if your 
application can only read 10MB/s the benchmark is telling you your disk 
is fast enough to keep up with the CPU.
> : If no, maybe raid10 over
> : the same 3 drives will give better results.
>
> Does RAID10 work on three drives?  I though one needed 4 drives,
> with striping across a pair of mirrored pairs.

No, that's 0+1, RAID-10 works across any number of drives.

Have you actually take 10-15 minutes to read "man md" and get the 
overview of how RAID works, or are you reading bits and pieces about 
individual features?

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

