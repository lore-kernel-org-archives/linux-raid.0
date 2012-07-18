From: Asdo <asdo@shiftmail.org>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Wed, 18 Jul 2012 18:28:59 +0200
Message-ID: <5006E44B.50402@shiftmail.org>
References: <a62c8158-aae7-4924-8408-e0302ff4e9b3@zmail15.collab.prod.int.phx2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <a62c8158-aae7-4924-8408-e0302ff4e9b3@zmail15.collab.prod.int.phx2.redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jaromir Capik <jcapik@redhat.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/18/12 13:01, Jaromir Capik wrote:
> Hello.
>
> I'd like to ask you to implement the following ...
>
> The current RAID1 solution is not robust enough to protect the data
> against random data corruptions. Such corruptions usually happen
> when an unreadable sector is found by the drive's electronics
> and when the drive's trying to reallocate the sector to the spare area.
> There's no guarantee that the reallocated data will always match
> the original stored data since the drive sometimes can't read the data
> correctly even with several retries. That unfortunately completely masks
> the issue, because the sector can be read by the OS without problems
> even if it doesn't contain correct data. Would it be possible
> to implement chunk checksums to avoid such data corruptions?
> If a corrupted chunk is encountered, it would be taken from the second
> drive and immediately synced back. This would have a small performance
> and capacity impact (1 sector per chunk to minimize performance impact
> caused by unaligned granularity = 0.78% of the capacity with 64k chunks).
>
> Please, let me know if you find my request reasonable or not.
>
> Thanks in advance.
>
> Regards,
> Jaromir.
>

This is a very invasive change that you ask, conceptually, 
man-hours-wise, performance-wise, ondisk-format wise, space-wise and 
also it really should stay at another layer, preferably below the RAID 
(btrfs and zfs do this above though). This should probably be a DM/LVM 
project.

Drives do this already, they have checksums (google for reed-solomon). 
If the checksums are not long enough you should use different drives. 
But in my life I never saw a "silent data corruption" like the one you say.

Also, statistically speaking, if one disk checksum returns false 
positive the drive is very likely dying, because it takes very many bit 
flips to bypass the reed-solomon check, so other sectors on the same 
drive have almost certainly given read error and you should have 
replaced the drive long ago already.


