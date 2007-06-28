From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: Fastest Chunk Size w/XFS For MD Software RAID = 1024k
Date: Thu, 28 Jun 2007 10:24:54 +0200
Message-ID: <46837056.4050306@rabbit.us>
References: <Pine.LNX.4.64.0706271918010.29111@p34.internal.lan> <46832E60.9000006@rabbit.us> <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0706280406520.1406@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, xfs@oss.sgi.com, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> mdadm --create \
>       --verbose /dev/md3 \
>       --level=5 \
>       --raid-devices=10 \
>       --chunk=1024 \
>       --force \
>       --run
>       /dev/sd[cdefghijkl]1
> 
> Justin.

Interesting, I came up with the same results (1M chunk being superior) 
with a completely different raid set with XFS on top:

mdadm	--create \
	--level=10 \
	--chunk=1024 \
	--raid-devices=4 \
	--layout=f3 \
	...

Could it be attributed to XFS itself?

Peter

