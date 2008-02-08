From: michael@estone.ca
Subject: Re: mdadm 2.6 creates slow RAID 5 while mdadm 2.5.6 rocks
Date: Fri, 08 Feb 2008 08:16:49 -0800
Message-ID: <20080208081649.rfx07p98ckcgc0sg@estone.ca>
References: <47AC7463.7000502@free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset=ISO-8859-1;
	DelSp="Yes";
	format="flowed"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47AC7463.7000502@free.fr>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Hubert Verstraete <hubskml@free.fr>:

> Hi All,
>
> My RAID 5 array is running slow.
> I've made a lot of test to find out where this issue is laying.
> I've come to the conclusion that once the array is created with mdadm
> 2.6.x (up to 2.6.4), whatever the kernel you run, whatever the mdadm
> you use to re-assemble the array, the array's performance is very
> degraded.
>
> Would this be a bug in mdadm 2.6 ?
> Are you seeing this issue too ?

I may have seen this before too.
What happens if you don't make an array that is partitionable?
Just create an /dev/mdx device, or, if you must use a partitionable array,
what happens to your benchmarks on your 2nd partition of your array?
Say, /dev/md_d0p2 ?

My symptons were similar that any partitionable Raid 5 array would be  
slower, but ony on the first partition.
mdadm version 2.5.6
kernel 2.6.18

Mike
