From: berk walker <berk@panix.com>
Subject: Re: Re-map disk sectors in userspace when rewriting after read errors
Date: Tue, 15 Sep 2009 02:45:29 -0400
Message-ID: <4AAF3809.7080802@panix.com>
References: <h8nbt5$n8p$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <h8nbt5$n8p$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Matthias Urlichs <matthias@urlichs.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthias Urlichs wrote:
> Hi,
>
> my problem is that I have a bunch of crappy disks which seem unable to
> reliably remap bad areas after a read error.
>
> This obviously makes the read error rewrite feature of our beloved 
> RAID5/6 code somewhat less than useful.
>
> What I would like to do is to re-map these sectors in userspace -- either 
> by browbeating the disk into it, or by using the Device Mapper. So I'd 
> need a way to tell a userspace daemon "this device+block is unreadable", 
> and wait until said daemon tells the RAID core to go ahead.
>
> I can do the userspace side easily, but my time to dig through the RAID 
> code and implement that sort of channel in a maintainable way is somewhat 
> limited. (Plus, I need that code sooner rather than later.)
>
> Would somebody be able to help out? There may be some money in it ...
>
>   
I can not believe the question.  What file system might this be?



