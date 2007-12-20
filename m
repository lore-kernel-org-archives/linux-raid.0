From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Linux RAID Partition Offset 63 cylinders / 30% performance hit?
Date: Thu, 20 Dec 2007 10:18:09 -0500
Message-ID: <476A87B1.10403@tmr.com>
References: <Pine.LNX.4.64.0712190926150.2468@p34.internal.lan> <Pine.GSO.4.64.0712191558290.1549@montezuma.acc.umu.se> <Pine.LNX.4.64.0712191002580.2468@p34.internal.lan> <476957A7.5010805@tmr.com> <Pine.LNX.4.64.0712191253180.2468@p34.internal.lan> <47696E98.8080103@tmr.com> <Pine.LNX.4.64.0712191629190.21347@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712191629190.21347@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Mattias Wadenstein <maswan@acc.umu.se>, linux-raid@vger.kernel.org, apiszcz@solarrain.com
List-Id: linux-raid.ids

Justin Piszcz wrote:
>
>
> On Wed, 19 Dec 2007, Bill Davidsen wrote:
>
>> I'm going to try another approach, I'll describe it when I get 
>> results (or not).
>
> http://home.comcast.net/~jpiszcz/align_vs_noalign/
>
> Hardly any difference at whatsoever, only on the per char for 
> read/write is it any faster..?

Am I misreading what you are doing here... you have the underlying data 
on the actual hardware devices 64k aligned by using either the whole 
device or starting a partition on a 64k boundary? I'm dubious that you 
will see a difference any other way, after all the translations take place.

I'm trying creating a raid array using loop devices created with the 
"offset" parameter, but I suspect that I will wind up doing a test after 
just repartitioning the drives, painful as that will be.
>
> Average of 3 runs taken:
>
> $ cat align/*log|grep ,
> p63,8G,57683,94,86479,13,55242,8,63495,98,147647,11,434.8,0,16:100000:16/64,1334210,10,330,2,120,1,3978,10,312,2 
>
> p63,8G,57973,95,76702,11,50830,7,62291,99,136477,10,388.3,0,16:100000:16/64,1252548,6,296,1,115,1,7927,20,373,2 
>
> p63,8G,57758,95,80847,12,52144,8,63874,98,144747,11,443.4,0,16:100000:16/64,1242445,6,303,1,117,1,6767,17,359,2 
>
>
> $ cat noalign/*log|grep ,
> p63,8G,57641,94,85494,12,55669,8,63802,98,146925,11,434.8,0,16:100000:16/64,1353180,8,314,1,117,1,8684,22,283,2 
>
> p63,8G,57705,94,85929,12,56708,8,63855,99,143437,11,436.2,0,16:100000:16/64,12211519,29,297,1,113,1,3218,8,325,2 
>
> p63,8G,57783,94,78226,11,48580,7,63487,98,137721,10,438.7,0,16:100000:16/64,1243229,8,307,1,120,1,4247,11,313,2 
>
>


-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


