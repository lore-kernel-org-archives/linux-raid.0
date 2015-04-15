From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: mdadm raid 5 one disk overwritten file system failed
Date: Wed, 15 Apr 2015 14:38:39 +0200 (CEST)
Message-ID: <alpine.DEB.2.02.1504151432250.16871@uplift.swm.pp.se>
References: <020601d04c17$08c10290$1a4307b0$@johnandre.net> <alpine.DEB.2.02.1502191218140.4007@uplift.swm.pp.se> <021f01d04c4c$5def1740$19cd45c0$@johnandre.net> <alpine.DEB.2.02.1502191521450.4007@uplift.swm.pp.se>
 <00b901d07771$f56c0010$e0440030$@johnandre.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <00b901d07771$f56c0010$e0440030$@johnandre.net>
Sender: linux-raid-owner@vger.kernel.org
To: John Andre Taule <post@johnandre.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 15 Apr 2015, John Andre Taule wrote:

> The guy that did this to us got 3 months jail.
>
> His argument was that we should have failed the system manually (removed the
> disk that he targeted with "dd"), and the raid should have magically fixed
> itself. Anyone think this would have worked?
> It was 5 hours of heavy write and deletes to the file system (ext4) and all
> that time the dd command where running.

Not a chance, after 5 hours dd basically had overwritten 1/3 of the data 
spread out across a large portion of the volume. We're talking massive 
file and filesystem corruption.

I don't know enough about zfs, but I am under the impression that zfs 
perhaps could have detected the bad information (because checksum would no 
longer match on those blocks) if you would have had native zfs to create 
the raid5. I don't have personal experience with zfs though, someone else 
might be able to answer that part.

It's really hard to protect against this kind of intentional sabotage. 
Even if you would have run zfs instead, he could have just dd:ed to the 
actual raid volume instead.



