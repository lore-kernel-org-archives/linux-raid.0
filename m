From: "John Andre Taule" <post@johnandre.net>
Subject: SV: mdadm raid 5 one disk overwritten file system failed
Date: Thu, 19 Feb 2015 17:21:25 +0100
Message-ID: <022401d04c60$1be68d10$53b3a730$@johnandre.net>
References: <020601d04c17$08c10290$1a4307b0$@johnandre.net> <alpine.DEB.2.02.1502191218140.4007@uplift.swm.pp.se> <021f01d04c4c$5def1740$19cd45c0$@johnandre.net> <alpine.DEB.2.02.1502191521450.4007@uplift.swm.pp.se> <54E5F5A7.3090609@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54E5F5A7.3090609@websitemanagers.com.au>
Content-Language: no
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

How common would this knowledge be? 

Personally I would never do something like this on a live system just
because there is too many unknown variables in play. I know what the
different raids do. I am not working on this full time, my day to day work
is toward the user end of the application stack. Usually we use Areca
hardware raids, but this particular raid used mdadm, well because that's
what was available at the time. Its been stable enough, I think its survived
2 or 3 failed drives, of course not at the same time.

I would like to thank the list for confirming my suspicion that there was
something else at play here that made the /dev/zero do more damage then the
"hacker" believed it would do.

//Regards

-----Opprinnelig melding-----
Fra: Adam Goryachev [mailto:mailinglists@websitemanagers.com.au] 
Sendt: 19. februar 2015 15:40
Til: John Andre Taule
Kopi: linux-raid@vger.kernel.org
Emne: Re: mdadm raid 5 one disk overwritten file system failed


On 20/02/2015 01:23, Mikael Abrahamsson wrote:
> On Thu, 19 Feb 2015, John Andre Taule wrote:
>
>> I'm a bit surprised that overwriting anything on the physical disk 
>> should corrupt the file system on the raid. I would think that would 
>> be similar to a disk crashing or failing in other ways.
>
> Errr, in raid5 you have data blocks and parity blocks. WHen you 
> overwrite one of the component drives with zeroes, you're effectively 
> doing the same as writing 0:es to a non-raid drive every 3 
> $stripesize. You're zero:ing a lot of the filesystem information.
>
>> What you say that Linux might not have seen the disk as failing is 
>> interesting. This could explain why the file system got corrupted.
>
> Correct. There is no mechanism that periodically checks the contents 
> of the superblock and fails the drive if it's not there anymore. So 
> the drive is never failed.
>
In addition, there is no checking of the data when read to confirm that the
data on the first 4 disks = the checksum on the 5th disk (assuming a
5 disk raid5). This applies equally to all raid levels as currently working
from linux md raid. While there are some use cases where it would be nice to
confirm that the data read is correct, this has not yet been implemented
(for live operation, you can schedule a check at periodic intervals).

Even if MD noticed that the value of the first 4 disks did not equal the
checksum on the 5th disk, it has no method to determine which disk contained
the wrong value (could be any of the data stripes, or the parity stripe).
raid6 begins to allow for this type of check, and I remember a lot of work
being done on this, however, I think that was still an offline tool more
useful for data recovery from partially failed multiple drives.

 From memory, there are filesystems which will do what you are asking (check
that the data received from disk is correct, use multiple 'disks' 
and ensure protection from x failed drives, etc. I am certain zfs and btrfs
both support this. (I've never used either due to stability concerns, but I
read about them every now and then....)

Regards,
Adam

