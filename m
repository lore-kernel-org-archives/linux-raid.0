From: Jan Wagner <jwagner@kurp.hut.fi>
Subject: Re: single RAID slower than aggregate multi-RAID?
Date: Mon, 18 Aug 2008 13:48:21 +0300 (EEST)
Message-ID: <alpine.DEB.1.10.0808181339010.365@kurp.hut.fi>
References: <alpine.DEB.1.10.0808151607560.5400@kurp.hut.fi> <18597.64737.508658.390657@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18597.64737.508658.390657@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil and all,

first off thanks for your interest.

On Sat, 16 Aug 2008, Neil Brown wrote:
> You should only need about 12Meg of dirty memory to keep your RAID0
> busy, and I doubt that is even 1% of your memory.

Strange. With the 12disk raid we get as much as 200MB dirty and throughput 
is slow. With the 4*3disk raid's we see just around 12MB and throughput 
is good. We have 4GB RAM.

> md/raid0 has very little overhead.  It just encourages the filesystem
> to send requests that are aligned with the chunks, and then sends each
> request on to the target drive without any further intervention.   So
> the queue for each device should be kept full, and the individual
> devices should be going at full speed.

Okay. We have been using power-of-2 raw write sizes, and in the case of 
using a filesystem, it was XFS with settings in mkfs.xfs that tell it 
about the chunk size and device count.

> So to make sure I'm not misunderstanding you description, could you
> run the two tests again: 12disk raid0 and 4*3disk raid0,  and for
> each report
>  mdadm -D   of each array
>  output of
>     time dd if=/dev/zero of=/dev/mdXX bs=1024k
>  on all arrays in parallel
> Using a chunksize of 1024.

One of our eSATA<=>SATA conversion cables got lost, so I couldn't right 
now do your test on the 4*3disk raid0 in my first posting. Instead I ran 
with 12disk and 3*4disk raid0.

http://www.metsahovi.fi/~jwagner/10g-tests/pmp/linux-raid-1.txt

473 MB/s with single raid, high 'dirty', 692 MB/s with triple raid and low 
'dirty.

Any ideas?

TIA,
  - Jan
