From: Bryan Mark Mesich <bmesich@atlantis.cc.ndsu.nodak.edu>
Subject: Useful benchmarking tools for RAID
Date: Wed, 12 Mar 2008 17:27:58 -0500
Message-ID: <1205360878.30451.134.camel@atlantis.cc.ndsu.nodak.edu>
Reply-To: bryan.mesich@ndsu.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Good afternoon,

I've been sitting back quietly reading posts over the past few months
regarding RAID performance.  My ultimate goal is to increase the
performance of our IMAP mail servers that have storage on-top RAID 5.
During peek times of the day, a single IMAP box might have 500+ imapd
processes running simultaneously.  As a result, the load increases as
does the users blood pressure.

I'm currently testing with the following:

Intel SE7520BD2 motherboard
(2) 3Ware PCI-E 9550SX 8 port SATA card
1 GB of memory
(2) Core2Duo 3.0GHz
(16) Segate 750GB Barracuda ES drives
RHEL 5.1 server (stock 2.6.18)

I've setup 3 RAID5 arrays arranged in a 3+1 layout.  I created them with
different chunk sizes (64k, 128k, and 256k) for testing purposes.
Write-caching has been disabled (no battery) on the 3Ware cards and I'm
using ext3 as my filesystem.  When creating the filesystems, I used
sensible stride sizes and disabled directory indexing.

I ran bonnie 1.4 on 2 of the filesystems with the following results:

### Chunk size = 64k
./Bonnie -d /mnt/64/ -s 1024 -y -u -o_direct

MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU   /sec %CPU
1*1024 59185 50.9 21849  7.5 14490  5.0 16377 24.1212812 25.3 267.8  1.5

### Chunk size = 256k
./Bonnie -d /mnt/256/ -s 1024 -y -u -o_direct

MB K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU K/sec %CPU   /sec %CPU
1*1024 47650 40.6 22561  6.8 19019  6.9 16872 22.2209770 23.7 267.2  1.5


OK...so now I have some benchmarks, but I'm not sure if it remotely
relates to normal IO on a busy IMAP server.  I would expect an IMAP
server to have many relatively small random reads and writes.  Looking
at the output of 'iostat' on one of the mail servers, I can see that the
average IO request size (avgrq-sz) is 77 and 87 (sectors?) on disks that
are members of a RAID1 array.  If I understand this correctly, the
average I/O request to the block device is around 40k.  Can a larger
chunk size help out when random I/O is prevalent?

With this said, has anyone ever tried tuning a RAID5 array to a busy
mail server (or similar application)?  An ever better question would be
how a person can go about benchmarking different storage configurations
that can be applied to a specific application.  At this point, I'm not
sure which benchmarking tool(s) would serve useful in this situation and
how that testing should be conducted.  Should I measure throughput or
smiling email users :)

Thanks in advance,

~Bryan
