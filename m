From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Incredibly poor performance of mdraid-1 with 2 SSD Samsung 840
 PRO
Date: Tue, 23 Apr 2013 22:24:40 -0500
Message-ID: <51775078.3000500@hardwarefreak.com>
References: <5171CBF9.9020701@redhost.ro> <51732E2B.6090607@hardwarefreak.com> <5174501F.80509@redhost.ro> <51747382.1010105@hardwarefreak.com> <5a749bb56c88b6d6b8a806694b163bda@redhost.ro> <5175F71A.8030805@hardwarefreak.com> <51765FD7.8090309@redhost.ro>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51765FD7.8090309@redhost.ro>
Sender: linux-raid-owner@vger.kernel.org
To: Andrei Banu <andrei.banu@redhost.ro>
List-Id: linux-raid.ids

On 4/23/2013 5:17 AM, Andrei Banu wrote:

> I am sorry for the very long email. And thanks a lot for all your patience.

From now on simply provide what is asked for.  That keeps the length
manageable and the info relevant, and allows us to help you get to a
solution more quickly without being bogged down.

> 1. DMESG doesn't show any "hard resetting link" at all.

Then it seems you don't have hardware problems.

> 2. The SSDs are connected to ATA 0 and ATA1. The server is brand new (or
> at least it should be).

Nor the Intel 6 Series SATA problem.

> 3. Partition table:

/etc/fstab contains mount points, not the partition table.

> root [~]# cat /etc/fstab

> UUID=cef1d19d-2578-43db-9ffc-b6b70e227bfa swap swap    defaults        0 0

I can't discern from UUID where your swap partition is located.  Is it a
partition directly on an SSD or is it a partition atop md1?

> root [/]# echo 3 > /proc/sys/vm/drop_caches
> root [~]# time cp largefile.tar.gz test03.tmp; time sync;

You're slowing us down here.  Please execute commands as instructed
without modification.  The above is wrong.  You don't call time twice.
If you're worried about sync execution being included time, use:
$ time (cp src.tmp src.temp; sync)

Though it makes little difference as Linux is pretty good about flushing
the last few write buffers.  But you missed the important part, the math
for bandwidth determination:  548/real = xx MB/s

This is cp not dd.  It's up to you to do the math.  Using time allows
you to do so.  548MB is my example using your previous file size in your
tests.  Modify accordingly if needed.

*Important note*  The job of this list is to provide knowledge transfer,
advice, and assistance.  You must do the work, and you must learn along
the way.  We don't fix people's problems, as we don't have access to
their computers.  What we do is *enable* people to fix their problems
themselves.

> After about 15 seconds the server load started to increase from 1,
> spiked to 40 in about a minute and then it started decreasing.

Please stop telling us this.  Linux load average is irrelevant.

> 5. The perf top -U output during a dd copy:

This was supposed to be executed before and simultaneously with the cp
operation above.  Do you know how to use multiple terminal windows?

> 6. iotop 

Again, this was supposed to be run with the cp command, exited toward
the end of the cp operation, then copy/pasted.

is very dynamic and I am afraid the data I am providing will be
> unclear but let me give a number of snapshots from during the large file
> copy and maybe you can make something of it (samples a few seconds apart):

> !!!!!! 6085 be/4 root        7.69 K/s 1004.85 M/s  0.00 %  0.00 % dd
> if=largefile.tar.gz of=test10 oflag=sync bs=1G

This is another example of why you don't use dd for IO testing, and
especially with a block size of 1GB.  dd buffers into RAM up to
$block_size bytes before it begins flushing to disk.  So what you're
seeing here is that massive push at the beginning of the run.  Your SSDs
in RAID1 peak at ~265MB/s.  iotop is showing 1GB/s, 4 times what the
drives can do.  This is obviously not real.

You can get away with oflag=sync using 1GB block size.  But if you run
dd the only way it can be run for realistic results, using bs=4096 which
matches every filesystem block size including EXTx, XFS, and JFS, then
using iflag=sync will degrade your performance, an ack is required on
each block.  That's what sync does.  With SSD it won't be nearly as
dramatic as rust, where the difference in runtime is 100-200x slower due
to rotational latency.

> I appologize for such a lengthy email!

Don't apologize, just don't send more information than needed,
especially if you don't know it's relevant. ;)  Send only what's
requested, and as requested, please.

-- 
Stan


