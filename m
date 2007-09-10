From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Sun, 09 Sep 2007 19:11:15 -0700
Message-ID: <46E4A7C3.1040902@amfes.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com> <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46E4A5F0.9090407@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Scobie wrote:
> Daniel L. Miller wrote:
>
>> And you didn't ask, but my mdadm.conf:
>> DEVICE partitions
>> ARRAY /dev/.static/dev/md0 level=raid10 num-devices=4 
>> UUID=9d94b17b:f5fac31a:577c252b:0d4c4b2a
>
> Try adding
>
> auto=part
>
> at the end of you mdadm.conf ARRAY line.
Thanks - will see what happens on my next reboot.

Daniel
