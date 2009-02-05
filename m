From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: How to start SW raid later in boot?
Date: Thu, 05 Feb 2009 13:44:52 -0500
Message-ID: <498B33A4.3090505@tmr.com>
References: <20090204193039.M36676@estone.ca> <498A0D0E.70000@musmo.com> <20090205112014.M278@estone.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090205112014.M278@estone.ca>
Sender: linux-raid-owner@vger.kernel.org
To: michael <michael@estone.ca>
Cc: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

michael wrote:
> On Wed, 04 Feb 2009 22:47:58 +0100, KwangErn Liew wrote
>
>   
>> Do you have initrd enabled?
>>
>>     
>
> I believe I do, its a standard install of Debian stable.
> For now, I suppose I can do as the last poster suggested and 
> run a startup script to assemble the array, and mount it.
>
> I will look more into the driver as its a 3rd party loaded module.
> Perhaps it can be setup to load earlier in the boot.
>   

If you put the module into the initrd (see man mkinitrd) you can get it 
loaded early. You may be able to prevent early start by changing the 
partition types (unlikely) or keeping the md device out of fstab and 
starting and mounting it from rc.local. I would go initrd.

-- 
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will still
  be valid when the war is over..." Otto von Bismark 


