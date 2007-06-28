From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Date: Thu, 28 Jun 2007 07:19:18 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0706280718120.2402@p34.internal.lan>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan>
 <46832E60.9000006@rabbit.us> <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan>
 <46837056.4050306@rabbit.us> <20070628090551.GG4504@mea-ext.zmailer.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070628090551.GG4504@mea-ext.zmailer.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matti Aarnio <matti.aarnio@zmailer.org>
Cc: Peter Rabbitson <rabbit@rabbit.us>, linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids



On Thu, 28 Jun 2007, Matti Aarnio wrote:

> On Thu, Jun 28, 2007 at 10:24:54AM +0200, Peter Rabbitson wrote:
>> Interesting, I came up with the same results (1M chunk being superior)
>> with a completely different raid set with XFS on top:
>>
>> mdadm	--create \
>> 	--level=10 \
>> 	--chunk=1024 \
>> 	--raid-devices=4 \
>> 	--layout=f3 \
>> 	...
>>
>> Could it be attributed to XFS itself?

If anyone is interested, I also did a 2048k, 1024k definitely results in
the most optimal configuration.

p34-128k-chunk,15696M,77236.3,99,445653,86.3333,192267,34.3333,78773.7,99,524463,41,594.9,0,16:100000:16/64,1298.67,10.6667,5964.33,17.3333,3035.67,18.3333,1512,13.6667,5334.33,16,2634.67,19
p34-512k-chunk,15696M,78383,99,436842,86,162969,27,79624,99,486892,38,583.0,0,16:100000:16/64,2019,17,9715,29,4272,23,2250,22,17095,45,3691,30
p34-1024k-chunk,15696M,77672.3,99,455267,87.3333,183772,29.6667,79601.3,99,578225,43.3333,595.933,0,16:100000:16/64,2085.67,18,12953,39,3908.33,23.3333,2375.33,23.3333,18492,51.6667,3388.33,27
p34-2048k-chunk,15696M,76822,98,435439,86,164140,26.3333,77065.3,99,582948,44,631.467,0,16:100000:16/64,1795.33,15,17612.3,49.3333,3668.67,20.6667,2040.67,19,13384,38,3255.33,25
p34-4096k-chunk,15696M,33791.1,43.5556,176630,37.3333,72235.1,11.5556,34424.9,44,247925,18.2222,271.644,0,16:100000:16/64,560,4.88889,2928,8.88889,1039.56,5.77778,571.556,5.33333,1729.78,5.33333,1289.33,9.33333

http://home.comcast.net/~jpiszcz/chunk/

Justin.

