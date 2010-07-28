From: Tim Small <tim@seoss.co.uk>
Subject: Re: Pending sectors in valid array - how to proceed?
Date: Wed, 28 Jul 2010 19:41:08 +0100
Message-ID: <4C5079C4.2050308@seoss.co.uk>
References: <4C506CF5.2080307@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C506CF5.2080307@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Stefan G. Weichinger wrote:
> md3 : active raid5 sdd3[3](S) sdc3[2] sdb3[1] sda3[0]
>       15647104 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>   

...

> smartctl shows for /dev/sdb:
>
>   5 Reallocated_Sector_Ct   0x0033   100   100   036    Pre-fail  Always
>       -       0
> 195 Hardware_ECC_Recovered  0x001a   058   039   000    Old_age   Always
>       -       146754005
> 197 Current_Pending_Sector  0x0012   100   100   000    Old_age   Always
>       -       13
> 198 Offline_Uncorrectable   0x0010   100   100   000    Old_age
> Offline      -       13
>
> (relevant lines as far as I understand ...)
>   

Do you have any high-fly writes?  Are there lots of
Hardware_ECC_Recovered on all the drives?  Is vibration likely to be an
issue?  What's the drive/chassis?
> I also read of a way of removing and re-adding a drive to get rid of
> these sectors?
>
> Is this a recommended thing to do?
> What would you recommend me to do?
>   

I think you should trigger a check, this should attempt to read these
pending sectors (assuming they are within the boundaries of the array),
along with every other sector in the array, and scrub them when the read
fails (i.e. reconstruct the data from the other array members, and write
them to the pending sectors on sdb - thus triggering reallocation of
those sectors).

echo check > /sys/block/md1/md/sync_action

etc.

Personally, I'd then wait to see if/how the reallocated count goes up -
if the sectors are the result of a one-off event, then no-problem, but
if they steadily climb, then the drive is probably on its way out -
those ECC_Recovered counts look a bit naff to me.  If you're nervous of
losing a drive during resync, the the check is a good thing to do first,
but you could also consider migrating the array to RAID6, to give you
double redundancy...

Cheers,

Tim.
