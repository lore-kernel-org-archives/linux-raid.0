From: andy liebman <andyliebman@aol.com>
Subject: Re: Real Time Mirroring of a NAS
Date: Fri, 07 Apr 2006 12:50:18 -0400
Message-ID: <4436984A.9020803@aol.com>
References: <44364336.7060704@aol.com> <8110058661.20060407200418@2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8110058661.20060407200418@2ka.mipt.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Jim Klimov <klimov@2ka.mipt.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

klimov@2ka.mipt.ru wrote:
> Hello andy,
> 
> al> Can I export NAS B as a SAN or ISCSI target, connect the two machines
> Am I right in the assumption that your NASes are Linux boxes? :)
> 
> Did you take a look at Linux "Network block devices" (nbd/enbd)? They
> might be what you need: you'd get a raw device on one of the servers
> to use in a mirror along with a local device. The NBD page mentioned
> some setups for high-availability services where an active server
> clones itself to a backup server and vice-versa, whichever was active
> most recently.
> 
> I'm not sure about performance though...
> 
> al> with, say, mryinet cards or 10 GbE TOE cards, mount the NAS B volume on
> al> NAS A, and create a RAID-1 mirror of the two volumes? Is this kind of
> al> thing done?
> 
> Are you sure you need 10GbE? My experience with a 10-drive 3Ware 8506
> array in RAID5 shows that reads from it usually fit in 500-700Mbit/s.
> And it's a very busy popular fileserver, so I guess it's close to the
> hardware limits of our array.
> 

Thanks for your reply, and the suggestions of others. I'm going to look 
into both NBD and DRBD.

Actually, I see that my idea to export an iSCSI target from Server B, 
mount it on A, and just create a RAID1 array with the two block devices 
must be very similar to what DRBD is doing, but my guess is that DRBD, 
with it's "heartbeat" signal, is probably more robust at error handling. 
I'd love to hear from somebody who has experience with DRBD.

By the way, I use 3ware 9550SX cards. On a 16 drive RAID-5 SATA array, I 
can get sequential reads that top 600 MBs/sec. That's megabytes, not 
megabits. And write speeds are close to 400 MB/sec with the new faster 
on-board XOR processing. And random reads are at least 200 MB/sec. So, 
10 GbE is a must, really.

Andy
