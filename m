From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: 3ware 7500-12, bad write speed
Date: Wed, 25 Sep 2002 22:23:38 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.2.20020925222027.03eb9710@mail.harddata.com>
References: <Pine.LNX.4.44.0209252237100.23239-100000@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0209252237100.23239-100000@uplift.swm.pp.se>
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 02:43 PM 9/25/02, Mikael Abrahamsson. Where 
you stated:

>I have a 6 drive (120 gig drives) RAID5 using a 3ware 7500-12. I have the
>latest firmware (7.5.1), latest driver etc, everything looks up to spec. I
>get great read speeds (60-80 megabyte/s), but I get very erratic write
>speeds (average 15 megabyte/s or so).
Not so surprising.

>Anyone seen this and solved it? I currently get better write speeds to a
>single IBM 7200rpm 75 gig drive (~25-30 meg/s) than to the 6 drive RAID5
>volume (I use the 3ware card to create the volume, no software raid).
Yes, don't use the 3Ware BIOS RAID.
Run it in JBOD mode, and use Linux RAID.
Neil's md tools make this very nice, and if you go to the 3Ware site and 
look in the downloads they have CLI tools to support hotswap and other 
useful things.
On a set of 16 Maxtor 160GB disk, and a pair of 3Ware 8 port cards we 
regularly get RAID5 writes (using a 4GB block/file size measured by 
bonnie++) of over 75MB/sec and reads over 160MB/sec.

I do think you should be seeing better results with the card and it's 
native BIOS RAID, but I still think that software Linux RAID is a lot 
faster and more flexible.


With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

2.3TB RAID5 NAS server - dual AthlonMP CPU, Linux, $10,995 CAD / $6850 USD

