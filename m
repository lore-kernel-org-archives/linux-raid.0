From: Corey Hickey <bugfood-ml@fatooh.org>
Subject: Re: 2.6.20: reproducible hard lockup with RAID-5 resync
Date: Sun, 18 Feb 2007 13:09:53 -0800
Message-ID: <45D8C0A1.6090903@fatooh.org>
References: <45D55366.4010904@fatooh.org> <45D8219E.9080603@fatooh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45D8219E.9080603@fatooh.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Corey Hickey wrote:
> Corey Hickey wrote:
>> I think I have found an easily-reproducible bug in Linux 2.6.20. I have
>> already applied the "Fix various bugs with aligned reads in RAID5"
>> patch, and that had no effect. It appears to be related to the resync
>> process, and makes the system lock up, hard.
> 
> I now have a different build of 2.6.20 running resync without the
> reported problem. I'll try to isolate the specific difference between
> the two builds some time tomorrow.

Ok, so the difference is CONFIG_SYSFS_DEPRECATED. If that is not
defined, the kernel locks up. There's not a lot of code under
#ifdef/#ifndef CONFIG_SYSFS_DEPRECATED, but since I'm not familiar with
any of it I don't expect trying to locate the bug on my own would be
very productive.

Neil, do you have CONFIG_SYSFS_DEPRECATED enabled? If so, does disabling
it reproduce my problem? If you can't reproduce it, should it take the
problem over to linux-kernel?

Thanks,
Corey
