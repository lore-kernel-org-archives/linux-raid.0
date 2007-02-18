From: Neil Brown <neilb@suse.de>
Subject: Re: 2.6.20: reproducible hard lockup with RAID-5 resync
Date: Mon, 19 Feb 2007 09:04:51 +1100
Message-ID: <17880.52611.569535.56180@notabene.brown>
References: <45D55366.4010904@fatooh.org>
	<45D8219E.9080603@fatooh.org>
	<45D8C0A1.6090903@fatooh.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Corey Hickey on Sunday February 18
Sender: linux-raid-owner@vger.kernel.org
To: Corey Hickey <bugfood-ml@fatooh.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday February 18, bugfood-ml@fatooh.org wrote:
> 
> Ok, so the difference is CONFIG_SYSFS_DEPRECATED. If that is not
> defined, the kernel locks up. There's not a lot of code under
> #ifdef/#ifndef CONFIG_SYSFS_DEPRECATED, but since I'm not familiar with
> any of it I don't expect trying to locate the bug on my own would be
> very productive.
> 
> Neil, do you have CONFIG_SYSFS_DEPRECATED enabled? If so, does disabling
> it reproduce my problem? If you can't reproduce it, should it take the
> problem over to linux-kernel?

# CONFIG_SYSFS_DEPRECATED is not set

No, it is not set, and yet it all still works for me.
It is very hard to see how this CONFIG option can make a difference.
Have you double checked that setting it removed the problem and
clearing it causes the problem?
If so, then maybe an email to linux-kernel would be appropriate.
Include the full config..

NeilBrown
