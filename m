From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Software RAID checksum performance on 24 disks not even close
 to kernel reported
Date: Tue, 05 Jun 2012 09:15:26 -0500
Message-ID: <4FCE147E.9080900@hardwarefreak.com>
References: <CA+4vN7wPd0Av_sbtA0JD5y=fGcsuq20SOQVHWnE8BUFpDxOEXQ@mail.gmail.com> <CA+sTkh6rA_yoeM3Fw1s47sgEsJRWG7vbtXH9QaPWbwG6Mvt7fQ@mail.gmail.com> <CA+4vN7zTmKPuyseOO9QhSKO3vjeLpt8pQ76W-MwZg1-YCz+vLA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+4vN7zTmKPuyseOO9QhSKO3vjeLpt8pQ76W-MwZg1-YCz+vLA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ole Tange <ole@tange.dk>
Cc: Igor M Podlesny <for.poige+lsr@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/5/2012 2:47 AM, Ole Tange wrote:

>   time parallel -j0 dd if={} of=/dev/null bs=1000k count=1k ::: /dev/sd?
                                            ^^^^^^^^
Block size, bs, should always be a multiple of the page size lest
throughput will suffer.  The Linux page size on x86 CPUs is 4096 bytes.
 Using bs values that are not multiples of page size will usually give
less than optimal results due to unaligned memory accesses.

Additionally, you will typically see optimum throughput using bs values
of between 4096 and 16384 bytes.  Below and above that throughput
typically falls.  Test each page size multiple from 4096 to 32768 to
confirm on your system.

Also, using large block sizes causes dd to buffer large amounts of data
into memory as each physical IO is only 4096 bytes.  Thus dd doesn't
actually start writing to disk until each block is buffered into RAM, in
this case just under 1MB.  This reduces efficiency by quite a bit vs the
4096 byte block size which allows streaming directly from dd without the
buffering.

> The 900 MB/s was based on my old controller. I re-measured using my
> new controller and get closer to 2000 MB/s in raw (non-RAID)
> performance, which is close to the theoretical maximum for that
> controller (2400 MB/s). This indicated that hardware is not a
> bottleneck.
> 
>>> When I set the disks up as a 24 disk software RAID6 I get 400 MB/s
>>> write and 600 MB/s read. It seems to be due to checksuming, as I have
>>> a single process (md0_raid6) taking up 100% of one CPU.

The dd block size will likely be even more critical when dealing with
parity arrays, as non page size blocks will cause problems with stripe
aligned writes.

Since both the Linux page size and all filesystem (EXT, XFS, JFS) block
sizes are 4096 bytes, you should always test dd with bs=4096, as that's
your real world day-to-day target block IO size.

-- 
Stan
