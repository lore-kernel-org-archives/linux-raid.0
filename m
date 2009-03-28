From: Patrick Ringl <patrick.ringl@gmx.de>
Subject: Re: 2.6.29 - raid10 issue - spares do not get synched automatically
Date: Sat, 28 Mar 2009 23:21:48 +0100
Message-ID: <49CEA2FC.8020505@gmx.de>
References: <49CE19F0.5040809@gmx.de> <b5623e48a92119937c6527b7f9564ed4.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b5623e48a92119937c6527b7f9564ed4.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

NeilBrown wrote:
> Linux RAID10 with
>
>      Raid Level : raid10
>    Raid Devices : 4
>          Layout : near=2, far=1
>
> Will layout data like this:
>
>    disk0   disk1   disk2   disk3
>      A       A       B       B
>      C       C       D       D
>      E       E       F       F
>
> You have removed disk0 and disk1, so A,C,E don't exist
> any more.  You should get IO errors when you try to access
> that data.
>   
Sorry, but I removed loop0 and loop2 so that would be disk0 and disk2 - 
so ACE as well as BDF should still exist and recover. Could you explain 
this, I am I just getting you wrong?
> There is nothing that can be recovered, so the drives remain
> as spares.
>
> NeilBrown
>   
regards,
Patrick
