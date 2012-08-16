From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid5 to utilize upto 8 cores
Date: Thu, 16 Aug 2012 00:58:48 -0500
Message-ID: <502C8C18.5070501@hardwarefreak.com>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent Ferrer <vincentchicago1@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/15/2012 9:56 PM, vincent Ferrer wrote:

> - My  storage server  has upto 8 cores  running linux kernel 2.6.32.27.
> - I created  a raid5 device of  10  SSDs .
> -  It seems  I only have single raid5 kernel thread,  limiting  my
> WRITE  throughput  to single cpu  core/thread.

The single write threads of md/RAID5/6/10 are being addressed by patches
in development.  Read the list archives for progress/status.  There were
3 posts to the list today regarding the RAID5 patch.

> Question :   What are my options to make  my raid5 thread use all the
> CPU cores ?
>                   My SSDs  can do much more but  single raid5 thread
> from mdadm   is becoming the bottleneck.
> 
> To overcome above single-thread-raid5 limitation (for now)  I  re-configured.
>      1)  I partitioned  all  my  10 SSDs into 8  partitions:
>      2)  I created  8   raid5 threads. Each raid5 thread having
> partition from each of the 8 SSDs
>      3)  My WRITE performance   quadrupled  because I have 8 RAID5 threads.
> Question: Is this workaround a   normal practice  or may give me
> maintenance problems later on.

No it is not normal practice.  I 'preach' against it regularly when I
see OPs doing it.  It's quite insane.  The glaring maintenance problem
is that when one SSD fails, and at least one will, you'll have 8 arrays
to rebuild vs one.  This may be acceptable to you, but not to the
general population.  With rust drives, and real workloads, it tends to
hammer the drive heads prodigiously, increasing latency and killing
performance, and decreasing drive life.  That's not an issue with SSD,
but multiple rebuilds is.  That and simply keeping track of 80 partitions.

There are a couple of sane things you can do today to address your problem:

1.  Create a RAID50, a layered md/RAID0 over two 5 SSD md/RAID5 arrays.
 This will double your threads and your IOPS.  It won't be as fast as
your Frankenstein setup and you'll lose one SSD of capacity to
additional parity.  However, it's sane, stable, doubles your
performance, and you have only one array to rebuild after an SSD
failure.  Any filesystem will work well with it, including XFS if
aligned properly.  It gives you an easy upgrade path-- as soon as the
threaded patches hit, a simple kernel upgrade will give your two RAID5
arrays the extra threads, so you're simply out one SSD of capacity.  You
won't need to, and probably won't want to rebuild the entire thing after
the patch.  With the Frankenstein setup you'll be destroying and
rebuilding arrays.  And if these are consumer grade SSDs, you're much
better off having two drives worth of redundancy anyway, so a RAID50
makes good sense all around.

2.  Make 5 md/RAID1 mirrors and concatenate them with md/RAID linear.
You'll get one md write thread per RAID1 device utilizing 5 cores in
parallel.  The linear driver doesn't use threads, but passes offsets to
the block layer, allowing infinite core scaling.  Format the linear
device with XFS and mount with inode64.  XFS has been fully threaded for
15 years.  Its allocation group design along with the inode64 allocator
allows near linear parallel scaling across a concatenated device[1],
assuming your workload/directory layout is designed for parallel file
throughput.

#2, with a parallel write workload, may be competitive with your
Frankenstein setup in both IOPS and throughput, even with 3 fewer RAID
threads and 4 fewer SSD "spindles".  It will outrun the RAID50 setup
like it's standing still.  You'll lose half your capacity to redundancy
as with RAID10, but you'll have 5 write threads for md/RAID1, one per
SSD pair.  One core should be plenty to drive a single SSD mirror, with
plenty of cycles to spare for actual applications, while sparing 3 cores
for apps as well.  You'll get unlimited core scaling with both md/linear
and XFS.  This setup will yield the best balance of IOPS and throughput
performance for the amount of cycles burned on IO, compared to
Frankenstein and the RAID50.

[1] If you are one of the uneducated masses who believe dd gives an
accurate measure of storage performance, then ignore option #2.  Such a
belief would indicate you thoroughly lack understanding of storage
workloads, and thus you will be greatly disappointed with the dd numbers
this configuration will give you.

-- 
Stan

