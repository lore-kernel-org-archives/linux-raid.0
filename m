From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: raid10 on centos 5
Date: Fri, 4 May 2007 13:57:08 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0705041356570.10003@p34.internal.lan>
References: <463B5DB3.6020502@istandfor.com>
 <CE7B1A4EF22E704CBFFD9A35BA5C82221E00D2@ausx3mpc110.aus.amer.dell.com>
 <463B6536.1010505@istandfor.com> <Pine.LNX.4.64.0705041323330.9571@p34.internal.lan>
 <463B6D22.3040202@istandfor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <463B6D22.3040202@istandfor.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ruslan Sivak <rsivak@istandfor.com>
Cc: Patrick_Boyd@Dell.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Compile into the kernel, boot new kernel then create your RAID 10 volume 
with mdadm :)


On Fri, 4 May 2007, Ruslan Sivak wrote:

> Justin Piszcz wrote:
>> cat /proc/mdstat
>> 
>> is the raid10 personality installed?
>> 
> No, it's not.  How would I go about installing it?
>
> Personalities: [raid0] [raid1] [raid6] [raid5] [raid4]
>
> Russ
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
