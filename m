From: Mario Giammarco <mgiammarco@virgilio.it>
Subject: Re: RAID1 VS RAID5
Date: Tue, 28 Oct 2003 11:46:57 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1067338017.1282.8.camel@cala>
References: <1067179519.1222.107.camel@cala>
	 <20031026165537.GW26480@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031026165537.GW26480@mea-ext.zmailer.org>
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Il dom, 2003-10-26 alle 17:55, Matti Aarnio ha scritto:

>  Performance boosting isn't primary goal in RAID schemes involving
>  data replication.
> 
RAID5 offers a nice performance boosts.



>  For RAID1 a suitably chosen read-interleave could be used to improve
>  _large_ file reads, of course.  Another strategy is to distribute read
>  operations to all online disks forming up the RAID1 set with elevators
>  of their own.
> 
> > Is there a patch to change raid1 behaviour?
> 
>  If it feels important, such can be made.
> 

Who will make it?


> > In linux 2.6.0 is it better?
> 
>  It can be made, if it isn't.

So? 2.6.0 have different raid1 code?


-- 
Mario Giammarco.it

