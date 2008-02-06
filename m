From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: which raid level gives maximum overall speed? (raid-10,f2 vs.
 raid-0)
Date: Wed, 06 Feb 2008 10:06:14 +0100
Message-ID: <47A97886.6080802@rabbit.us>
References: <20080130192133.17b254bf@szpak>	<20080130220007.GG20173@rap.rap.dk>	<20080130233639.5d46b044@szpak>	<20080131015506.GB6617@rap.rap.dk>	<20080205161036.GA30326@rap.rap.dk>	<alpine.DEB.1.00.0802051152500.9790@p34.internal.lan>	<20080205200423.GB17621@rap.rap.dk>	<alpine.DEB.1.00.0802051726510.10352@p34.internal.lan> <20080205235215.750ea879@szpak>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080205235215.750ea879@szpak>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> writing on raid10 is supposed to be half the speed of reading. That's
> because it must write to both mirrors.
> 

I am not 100% certain about the following rules, but afaik any raid 
configuration has a theoretical[1] maximum read speed of the combined speed of 
all disks in the array and a maximum write speed equal to the combined speed 
of a disk-length of a stripe. By disk-length I mean how many disks are needed 
to reconstruct a single stripe - the rest of the writes are redundancy and are 
essentially non-accountable work. For raid5 it is N-1. For raid6 - N-2. For 
linux raid 10 it is N-C+1 where C is the number of chunk copies. So for -p n3 
-n 5 we would get a maximum write speed of 3 x <single drive speed>. For raid1 
the disk-length of a stripe is always 1.

So the statement
> IMHO raid5 could perform good here, because in *continuous* write
> operation the blocks from other HDDs were just have been written,
> they stay in cache and can be used to calculate xor. So you could get
> close to almost raid-0 performance here.
is quite incorrect. You will get close to raid-0 if you have many disks, but 
will never beat raid0, since once disk is always busy writing parity which is 
not part of the write request submitted to the mdX device in the first place.

[1] Theoretical since any external factors (busy CPU, unsuitable elevator, 
random disk access, multiple raid levels on one physical device) would all 
contribute to take you further away from the maximums.
