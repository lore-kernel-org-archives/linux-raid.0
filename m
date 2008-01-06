From: Jim <jim@fayettedigital.com>
Subject: Re: Raid 1, can't get the second disk added back in.
Date: Sun, 06 Jan 2008 11:49:07 -0500
Message-ID: <47810683.80804@fayettedigital.com>
References: <477FAAAC.2090107@fayettedigital.com>	<20080105210002.t5syxhjahwocks4g@cakebox.homeunix.net>	<4780B7C2.3030909@fayettedigital.com> <20080106173106.x7wngh3ccgwwsk00@cakebox.homeunix.net>
Reply-To: jim@fayettedigital.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080106173106.x7wngh3ccgwwsk00@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Nagilum wrote:
> ----- Message from jim@fayettedigital.com ---------
>     Date: Sun, 06 Jan 2008 06:13:06 -0500
>     From: Jim <jim@fayettedigital.com>
>
>> root@chinaberry:~# mdadm  /dev/md0 --re-add /dev/hdb5
>> mdadm: Cannot open /dev/hdb5: Device or resource busy
>
> Have you tried stopping (-S) /dev/md0 and then re-assemble the array 
> (-A)?
Yes, I did that yesterday.  Something is holding on to /dev/hdb5, 'cause 
I got the device busy message from that attempt too.  I think I'm going 
to remove the partition and see what happens.

Thanks,
Jim.
