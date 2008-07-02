From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Wed, 02 Jul 2008 15:02:43 -0700
Message-ID: <486BFB03.7060100@zytor.com>
References: <484F9A3E.7020709@rabbit.us> <18512.25940.653867.623185@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18512.25940.653867.623185@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> On Wednesday June 11, rabbit+list@rabbit.us wrote:
>> Hello,
>>
>> The subject pretty much says it all - it obviously is not 0xFD, since there is 
>> nothing to autodetect. Is there some best practice/semi-standard way of 
>> marking a raid component partition as such? After reading the specs 0xDA 
>> (non-fs data) comes to mind, but I figured I'll ask here.
>>
> 
> I (almost) alway make arrays out of whole devices, not partitions, so
> I really never thought about this.
> 
> I suspect 0xDA is safest and hence best.
> I wonder if this should be suggested in the mdadm man page
> anywhere.... anyone feel like creating a patch?
> 

Why 0xDA?

As far as I know, the closest thing there is to a registry is the list 
that aeb at least used to maintain.

	-hpa
