From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Date: Thu, 28 Jun 2007 04:27:15 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706280426500.1406@p34.internal.lan>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan>
 <46832E60.9000006@rabbit.us> <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan>
 <46837056.4050306@rabbit.us>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46837056.4050306@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit@rabbit.us>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Thu, 28 Jun 2007, Peter Rabbitson wrote:

> Justin Piszcz wrote:
>> mdadm --create \
>>       --verbose /dev/md3 \
>>       --level=5 \
>>       --raid-devices=10 \
>>       --chunk=1024 \
>>       --force \
>>       --run
>>       /dev/sd[cdefghijkl]1
>> 
>> Justin.
>
> Interesting, I came up with the same results (1M chunk being superior) with a 
> completely different raid set with XFS on top:
>
> mdadm	--create \
> 	--level=10 \
> 	--chunk=1024 \
> 	--raid-devices=4 \
> 	--layout=f3 \
> 	...
>
> Could it be attributed to XFS itself?
>
> Peter
>

Good question, by the way how much cache do the drives have that you are 
testing with?

Justin.
