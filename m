From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: 2.6.20: reproducible hard lockup with RAID-5 resync
Date: Sun, 18 Feb 2007 16:06:53 -0800
Message-ID: <45D8EA1D.3070100@fatooh.org>
References: <45D55366.4010904@fatooh.org>	<45D8219E.9080603@fatooh.org>	<45D8C0A1.6090903@fatooh.org> <17880.52611.569535.56180@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17880.52611.569535.56180@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
>> Ok, so the difference is CONFIG_SYSFS_DEPRECATED. If that is not
>> defined, the kernel locks up. There's not a lot of code under
>> #ifdef/#ifndef CONFIG_SYSFS_DEPRECATED, but since I'm not familiar with
>> any of it I don't expect trying to locate the bug on my own would be
>> very productive.
>>
>> Neil, do you have CONFIG_SYSFS_DEPRECATED enabled? If so, does disabling
>> it reproduce my problem? If you can't reproduce it, should it take the
>> problem over to linux-kernel?
> 
> # CONFIG_SYSFS_DEPRECATED is not set
> 
> No, it is not set, and yet it all still works for me.

Dang, again. :)

> It is very hard to see how this CONFIG option can make a difference.
> Have you double checked that setting it removed the problem and
> clearing it causes the problem?

Yes, it seems odd to me too, but I have double-checked. If I build a
kernel with CONFIG_SYSFS_DEPRECATED enabled, it works; if I disable that
option and rebuild the kernel, it locks up.

I just tried running 'make defconfig' and then enabling only RAID,
RAID-0, RAID-1, and RAID-4/5/6. If I then disable
CONFIG_SYSFS_DEPRECATED, there aren't any problems. ...so, I'll try to
isolate the problem some more later.

Thanks,
Corey
