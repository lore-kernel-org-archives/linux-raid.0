From: "Robin Bowes" <robin-lists@robinbowes.com>
Subject: RE: AW: Raid 1 vs 5 ?
Date: Wed, 9 Jun 2004 17:19:21 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <34292.194.60.85.4.1086797961.squirrel@194.60.85.4>
References: <27453.194.60.85.4.1086793052.squirrel@194.60.85.4>
    <200406091559.i59FxC317954@watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200406091559.i59FxC317954@watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'Mauricio' <raub@afn.org>, 'LinuxRaid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, June 9, 2004 16:59, Guy said:
> You said:
> "Now consider RAID5. Here, with a hardware controller all of the data is
> written to the RAID card which in turn calculates parity and stripes the
> data over the disks. With software RAID, the software calculates parity and
> writes the data across all the mirrored drives. The only additional bus
> traffic for software RAID is the parity data."
>
> I believe this is wrong:

[snip]

Like I also said:

>>
>> I'm not expert but...
>>

Hmm. I can't spell either! :o)

> About your swap plans...
> If you were going to use 4 disks, create 2 RAID1 arrays, give both to swap.
> Swap will strip to both arrays.  I believe this would give better
> performance over creating a single RAID1/0 array.
>

I came to the same conclusion myself 30 secs after hitting "send".

Thanks for the suggestion.

R.
-- 
http://robinbowes.com

