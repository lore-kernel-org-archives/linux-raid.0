From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Perhaps this has been answered before...
Date: Wed, 21 Aug 2002 19:41:17 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D63D0BD.50005@hum.auc.dk>
References: <Pine.OSF.4.30.0208212024340.15250-100000@soul.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Mikael Johansson <mpjohans@pcu.helsinki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mikael Johansson wrote:

> 
> On 21 Aug 2002, Chris Zimmerman wrote:
> 
> 
>>/dev/md0       swap        swap        defaults   0   0
>>
> 
>>raiddev /dev/md0
>>        raid-level              1
>>
> 
> Having your swap space as RAID-1 is redundant indeed :-) You will be
> better off changing it to RAID-0.


Only if you don't care what happens when a disk crashes. With RAID-1, 
you'll be able to survive, with RAID-0 your system will crash, when it 
can't access the swap partition.

 
> I however do not see why this should freeze your machine.


Me neither. Swap on RAID-1 works fine for me (though on 2.4).

Regards,
Mads

