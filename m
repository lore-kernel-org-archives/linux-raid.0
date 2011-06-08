From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: from 2x RAID1 to 1x RAID6 ?
Date: Wed, 08 Jun 2011 02:16:17 +0100
Message-ID: <4DEECD61.4030909@anonymous.org.uk>
References: <4DEE6A11.1030205@xunil.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DEE6A11.1030205@xunil.at>
Sender: linux-raid-owner@vger.kernel.org
To: lists@xunil.at
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 07/06/2011 19:12, Stefan G. Weichinger wrote:
>
> Greetings, could you please advise me how to proceed?
>
> On a server I have 2 RAID1-arrays, each consisting of 2 TB-drives:
>
> md5 : active raid1 sde1[0] sdf1[1]
>        976759936 blocks [2/2] [UU]
>
> md6 : active raid1 sdh1[1] sdg1[0]
>        976759936 blocks [2/2] [UU]
>
>
> md5 and md6 are right now physical volumes (PVs) in an LVM-volume-group.
> Nearly all the space is used right now (1.7 TB out of the ~2 TB).
>
> Now I would like to move things to a more reliable RAID6 consisting of
> all the four TB-drives ...
>
> How to do that with minimum risk?
>
> For sure it would be best to move all data aside, stop the arrays and
> build a new one ... etc
>
> Failing two drives and remove them from the RAID1s to build a new
> degraded RAID6 seems dangerous to me?
>
> Maybe I overlook a clever alternative?
>
> Suggestions welcome, thanks in advance.

There may be a clever alternative, retaining single redundancy, if you 
don't mind buying one more disc, which I'm guessing you might do soon 
anyway as you're already 85% full. Or if not, it won't do too much harm 
to have a spare drive sitting on a shelf.

You can convert a 2-drive RAID1 to a 2-drive RAID5, then add the new 
drive to double the size of the array, resize the PV, then move the PEs 
over from the other RAID1, then tear down that PV and RAID1, add one or 
both of those drives into the RAID5 and grow it to a RAID6. The only 
step at which you have a little less redundancy is while you're running 
the 3-drive RAID5 (well, it's still 1 drive but against 2 drives, 
instead of 1:1).

On the other hand it might be easier to take a backup, which you 
probably ought to do anyway!

Cheers,

John.

