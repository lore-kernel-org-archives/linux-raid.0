From: Asdo <asdo@shiftmail.org>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 21:25:45 +0100
Message-ID: <4B785C49.7010105@shiftmail.org>
References: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
 <4877c76c1002111752h23e14f7aibe58a89181e6f493@mail.gmail.com>
 <4B77044B.1020609@zytor.com>
 <alpine.DEB.2.00.1002131507260.31103@p34.internal.lan>
 <4B7719C1.1060400@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B7719C1.1060400@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Michael Evans <mjevans1983@gmail.com>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

H. Peter Anvin wrote:
> On 02/13/2010 12:07 PM, Justin Piszcz wrote:
>   
> 0.90 has a very bad problem, which is that it is hard to distinguish
> between a RAID partition at the end of volume and a full RAID device.
> This is because 0.90 doesn't actually tell you the start of the device.
>
> Then, of course, there are a lot of limitations on size, number of
> devices, and so on in 0.90.
>
> 	-hpa
>   
I don't understand...
In a system we have, the root filesystem on a raid-6 which is on second 
(and last) partitions of many disks.
It always assembled correctly, it never tried to assemble the whole device.
(on the first partition there is a raid1 with boot)
So what's the problem exactly with not marking the beginning?
