From: Peter Rabbitson <rabbit@rabbit.us>
Subject: Re: XFS sunit/swidth for raid10
Date: Thu, 22 Mar 2007 13:05:08 +0100
Message-ID: <460270F4.1080604@rabbit.us>
References: <4601BE85.8050005@rabbit.us> <Pine.LNX.4.64.0703220108270.13419@twinlark.arctic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0703220108270.13419@twinlark.arctic.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

dean gaudet wrote:
> On Thu, 22 Mar 2007, Peter Rabbitson wrote:
> 
>> Hi,
>> How does one determine the XFS sunit and swidth sizes for a software raid10
>> with 3 copies?
> 
> mkfs.xfs uses the GET_ARRAY_INFO ioctl to get the data it needs from 
> software raid and select an appropriate sunit/swidth...
>
> although i'm not sure i agree entirely with its choice for raid10:

So do I, especially as it makes no checks for the amount of copies (3 in 
my case, not 2).

>it probably doesn't matter.

This was essentially my question. For an array -pf3 -c1024 I get swidth 
= 4 * sunit = 4MiB. Is it about right and does it matter at all?
