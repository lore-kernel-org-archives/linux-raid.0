From: Mark Watts <m.watts@eris.qinetiq.com>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Fri, 30 Jul 2004 11:16:42 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407301116.42676.m.watts@eris.qinetiq.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1


>> With the performance issues I'm seeing with the 8506-4LP's I have, I 
>wouldn't 
>> recommend them to anyone currently...
>> 
>> The thread on LKML from a few days ago about mke2fs -j and 8506-4LP says it 
>> all, but basically and reasonable amount of I/O brings a Dual Opteron 
>system 
>> to its knees.
>> And by reasonable I mean copying ISO images from a usb2 drive to a raid 5 
>(4 x 
>> 250GB maxtor) or even just formatting a 600MB partition.
>
>I've been able to get nearly 1.5 Gbits/sec off of an 8506-8, with 8
>250GB disks...  of course those are all 1 megabyte reads (but from
>random locations).  Is your problem related to # of IO's, or size of
>transfer?

# hdparm -tT /dev/sda

/dev/sda:
 Timing buffer-cache reads:   2232 MB in  2.00 seconds = 1115.61 MB/sec
 Timing buffered disk reads:  190 MB in  3.03 seconds =  62.76 MB/sec

bonnie++ concurs with this and gives us about 22MB/sec write performance.

Basically anything involving I/O is causing the system to crawl.
I can reliably reproduce this by doing:

	mke2fs -j /dev/sda7

Where sda7 is a 600GB partition.

Basically the system load goes orbital and responsivness goes out the window.
gkrellm only shows ~1MB/sec of disk activity and the processors (Dual Opteron) 
are twiddling their thumbs (top shows 100% 'wa' state for both processors), 
yet I can hardly do anything with any open applications.

Kernel is a 2.6.8rc1 kernel.org job.

- -- 
Mark Watts
Senior Systems Engineer
QinetiQ Trusted Information Management
Trusted Solutions and Services group
GPG Public Key ID: 455420ED

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.2.4 (GNU/Linux)

iD8DBQFBCiAKBn4EFUVUIO0RAsmIAJ4zaXUPemotyUDFTjj9soa4ZSD+GwCfYQMg
jxmu5wO9o4XXh+0p54zKVio=
=zWAH
-----END PGP SIGNATURE-----
