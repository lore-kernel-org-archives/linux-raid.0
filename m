From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: 3ware 7500-8 confusion
Date: 23 Feb 2003 00:53:41 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.2.20030222232508.039dbda0@mail.harddata.com>
References: <Pine.LNX.3.96.1030222210002.29904A-100000@Maggie.Linux-Consulting.com>
	 <Pine.LNX.3.96.1030222210002.29904A-100000@Maggie.Linux-Consulting.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1045980219.2132.16.camel@gregdell>
To: Gregory Leblanc <gleblanc@linuxweasel.com>
List-Id: linux-raid.ids

With regards to your message at 11:03 PM 2/22/03, Gregory Leblanc. Where 
you stated:
>There is a way to configure the 3ware card to just work as JBOD.  I
>don't recall what it is offhand (I've got an older card with only 4
>ports as well).  It doesn't seem to make much sense to buy a pretty nice
>RAID card like this one and then not use it's RAID features, though.
>HTH,
>         Greg

Actually it makes tons of sense.
If you are using it for RAID5 you will get at least twice the performance.
Yes, to echo an earlier message, you will get higher CPU load.
That is to be expected when your writes take half as long.
AND, as a bonus, if you partition each drive, leave a small partition at 
the beginning of each disk you gain two things:
1) You can make your system boot off the disks without the md RAID driver 
being loaded, so emergency recovery is simpler
2) If you lose a disk at a later date, you don;t have to worry about 
getting the same exact drive to replace it with.

What you lose is:
1) 3Wares nifty 3DM tool

Still, you get most of its functionality with their CLI utility.


With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3


