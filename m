From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Date: Thu, 28 Jun 2007 04:07:36 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan>
 <46832E60.9000006@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46832E60.9000006@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

mdadm --create \
       --verbose /dev/md3 \
       --level=5 \
       --raid-devices=10 \
       --chunk=1024 \
       --force \
       --run
       /dev/sd[cdefghijkl]1

Justin.


On Thu, 28 Jun 2007, Peter Rabbitson wrote:

> Justin Piszcz wrote:
>> The results speak for themselves:
>> 
>> http://home.comcast.net/~jpiszcz/chunk/index.html
>> 
>
>
> What is the array layout (-l ? -n ? -p ?)
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
