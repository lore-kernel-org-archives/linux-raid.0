From: Maurice Hilarius <maurice@harddata.com>
Subject: Re: Tiobench results LOWER with more threads
Date: Thu, 17 Oct 2002 20:52:35 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.1.6.2.20021017205027.06ac59a0@mail.harddata.com>
References: <20021017215014.GA7875@unthought.net>
 <3DABCFE7.9070701@webmail.co.za>
 <20021017215014.GA7875@unthought.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20021018023137.GC18294@peeps.cable.rcn.com>
To: Gregory Leblanc <gleblanc@linuxweasel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With regards to your message at 08:31 PM 10/17/02, Gregory Leblanc. Where 
you stated:

>Err, so are you saying that a single sequential I/O is slower on RAID
>1 when compared with a single disk?  That doesn't make a lot of
>sense.  There -are- instances where parallel I/O is required.  In
>these cases, any RAID-1 should be much faster than a single disk, as
>should RAID 10.  I'm not sure that RAID 5 should give a similar
>benefit, but given the cost of disks, I don't care about RAID 5.

Of course RAID1 should be slower.
We are doing more WORK!
We have to generate two writes, and manage them and the RAID.
With a single disk we are doing much less, and there is _much_ less overhead.
In an ideal world RAID10 will gain us back the loss because of the RAID0 
element which DOES gain us some performance back.
But even then the CPU load will be much more, as we are still writing more 
data.


With our best regards,

Maurice W. Hilarius       Telephone: 01-780-456-9771
Hard Data Ltd.               FAX:       01-780-456-9772
11060 - 166 Avenue        mailto:maurice@harddata.com
Edmonton, AB, Canada      http://www.harddata.com/
    T5X 1Y3

Ask me about NAS and near-line storage

