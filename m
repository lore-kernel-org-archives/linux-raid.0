From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: RAID5 Performance
Date: Thu, 28 Jul 2016 18:20:16 +0100
Message-ID: <22426.16080.579831.750402@tree.ty.sabi.co.uk>
References: <7b7d730f-2951-ba5f-7f6b-33624b59a02d@websitemanagers.com.au>
	<22424.50313.900162.715200@tree.ty.sabi.co.uk>
	<CAFx4rwSRYDACX631eLpX7Jr9jB2u4jbC7dr-0rdi9U1nV9og3Q@mail.gmail.com>
	<22425.63565.439521.592849@tree.ty.sabi.co.uk>
	<22426.2167.369879.756599@tree.ty.sabi.co.uk>
	<a0921a51-d841-7fbd-0f31-21f5ba8c6f4b@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a0921a51-d841-7fbd-0f31-21f5ba8c6f4b@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

>> * Replace the flash SSDs with those that are known to deliver
>>   high (at least > 10,000 single threaded) small synchronous
>>   write IOPS.

> Is there a "known" SSD that you would suggest? My problem is
> that Intel spec sheets seem to suggest that there is little
> performance difference across the range of SSD's, so it's
> really not clear which SSD model I should buy.

The links I wrote earlier have lists:

>>>   https://www.sebastien-han.fr/blog/2014/10/10/ceph-how-to-test-if-your-ssd-is-suitable-as-a-journal-device/
>>>   http://www.spinics.net/lists/ceph-users/msg25928.html
>>>   https://www.redhat.com/en/resources/ceph-pcie-ssd-performance-part-1

As one of those pages says the Samsung SM863 looks attractive,
but for historical reasons so far I have only seen Intel DCs in
similar use. There discussions of other models in various posts
related to Ceph journal SSD usage.

> Obviously it's not something I can afford to buy one of each
> and test them either.

In addition to the lists above I have justed tested my three
home flash SSDs:

* Micron M4 256GB:
    #  dd bs=4k count=100000 oflag=direct,dsync if=/dev/zero of=/var/tmp/TEST
    100000+0 records in
    100000+0 records out
    409600000 bytes (410 MB) copied, 1200.3 s, 341 kB/s
* Samsung 850 Pro 256GB:
    #  dd bs=4k count=100000 oflag=direct,dsync if=/dev/zero of=/var/tmp/TEST
    100000+0 records in
    100000+0 records out
    409600000 bytes (410 MB) copied, 1732.93 s, 236 kB/s
* Hynix SK SH910 256GB:
    #  dd bs=4k count=100000 oflag=direct,dsync if=/dev/zero of=/var/tmp/TEST
    100000+0 records in
    100000+0 records out
    409600000 bytes (410 MB) copied, 644.742 s, 635 kB/s

So I would not recommend any of them for "small sync writes"
workloads :-), but they are quite good otherwise. I do notice
they are slow on small sync writes when downloading mail, as
each message is duly 'fsync'ed.

BTW as bonus material, I have done on the SH910 an abbreviated
test with block sizes between 4KiB and 1024KiB:

  #  for N in 4k 16k 64k 128k 256k 512k 1024k; do echo -n "$N: "; dd bs=$N count=1000 oflag=dsync if=/dev/zero of=/var/tmp/TEST |& grep copied; done
  4k: 4096000 bytes (4.1 MB) copied, 6.23481 s, 657 kB/s
  16k: 16384000 bytes (16 MB) copied, 6.29379 s, 2.6 MB/s
  64k: 65536000 bytes (66 MB) copied, 6.09223 s, 10.8 MB/s
  128k: 131072000 bytes (131 MB) copied, 6.5487 s, 20.0 MB/s
  256k: 262144000 bytes (262 MB) copied, 6.93361 s, 37.8 MB/s
  512k: 524288000 bytes (524 MB) copied, 7.73957 s, 67.7 MB/s
  1024k: 1048576000 bytes (1.0 GB) copied, 12.8671 s, 81.5 MB/s

Note how the time to write 1000 blocks is essentially the same
betweeen 4KiB and 128KiB, which is quite amusing. Probably the
flash-page size is around 256KiB.

For additional bonus value the same on a "fastish" consumer 2TB
disk, a Seagate ST2000DM001:

  #  for N in 4k 16k 64k 128k 256k 512k 1024k; do echo -n "$N: "; dd bs=$N count=1000 oflag=dsync if=/dev/zero of=/fs/sdb6/tmp/TEST |& grep copied; done
  4k: 4096000 bytes (4.1 MB) copied, 44.9177 s, 91.2 kB/s
  16k: 16384000 bytes (16 MB) copied, 38.131 s, 430 kB/s
  64k: 65536000 bytes (66 MB) copied, 35.8263 s, 1.8 MB/s
  128k: 131072000 bytes (131 MB) copied, 35.8188 s, 3.7 MB/s
  256k: 262144000 bytes (262 MB) copied, 36.6838 s, 7.1 MB/s
  512k: 524288000 bytes (524 MB) copied, 37.0612 s, 14.1 MB/s
  1024k: 1048576000 bytes (1.0 GB) copied, 42.0844 s, 24.9 MB/s

>> * Relax the requirement for synchronous writes on *both* the
>>   primary and secondary DRBD servers, if feeling lucky.

> I have the following entries for DRBD which were suggested by
> linbit (which previously lifted performance from abysmal to
> more than sufficient around 2+ years ago). [ ... ]

That's an inappropriate use of "performance" here:

>          disk-barrier no;
>          disk-flushes no;
>          md-flushes no;

That "feeling lucky" list seems to me to have made performance
lower (in the sense that the performance of writing to
'/dev/null' is zero, even if the speed is really good :->).

With those settings the data sync policy is "disk-drain", which
also involves some waiting, but somewhat dangerous, except "In
case your backing storage device has battery-backed write cache"
(and "device" here means system and host adapter and disk); it
is not clear to me for metadata what "md-flushes no" gives.

BTW if you have battery-backed everything on the secondary side
you could use protocol "B".

However given those it looks likely that the bottleneck is also
on the primary DRBD side.

> Do you have any other suggestions or ideas that might assist?

* Smaller RAID5 stripes, as in 4+1 or 2+1, are cheaper in space
  than RAID10 and enormously raise the chances that a full
  stripe-write can happen (it still has the write-hole problem
  of parity RAID).

* Make sure the DRBD journal is also on a separate device that
  allows fast small sync writes.

Also, I have appended a sample DRBD configuration I have used:

----------------------------------------------------------------

resource r0
{
  device		  /dev/drbd_r0 minor 0;
  # A: "local disk and local TCP send buffer"
  # B: "local disk and remote buffer cache"
  # C: "both local and remote disk"
  protocol		  C;

  net
  {
    # As mentioned on IRC by a DRBD guy, this is not really a
    # secret, but more a "unique id" that ensures that replicas
    # of different resources don't get accidentally connected.
    # Still to be ABR-ized.
    shared-secret	    "xxxxxxxxxxxx";

    cram-hmac-alg	    sha1;
    ping-timeout	    50;

    after-sb-0pri	    discard-zero-changes;
    after-sb-1pri	    discard-secondary;
    after-sb-2pri	    disconnect;

    # http://article.gmane.org/gmane.linux.network.drbd/18348
    # http://www.drbd.org/users-guide-8.3/s-throughput-tuning.html
    # https://alteeve.ca/w/AN!Cluster_Tutorial_2_-_Performance_Tuning
    # http://fghaas.wordpress.com/2007/06/22/performance-tuning-drbd-setups/
    sndbuf-size		    0;
    rcvbuf-size		    0;
    max-buffers		    16384;
    unplug-watermark	    16384;
    max-epoch-size	    16384;
  }

  syncer
  {
    csums-alg		    sha1;
    # At 45MB/s takes 6 hour per 1TB.
    rate		    95M;

    use-rle;
  }

  startup
  {
    wfc-timeout		    15;
    degr-wfc-timeout	    15;
    outdated-wfc-timeout    15;

    # Cannot be an address, must be output of 'hostname'.
    become-primary-on	    host-1;
  }

  on host-1
  {
    address		    192.168.1.11:7788;
    disk		    /dev/md2;
    flexible-meta-disk	    /dev/local0/r0_md;
  }

  on host-2
  {
    address		    192.168.1.12:7788;
    disk		    /dev/md2;
    flexible-meta-disk	    /dev/local0/r0_md;
  }
}
