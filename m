From: Zeno Davatz <zdavatz@generika.cc>
Subject: Re: Fatal: map file must be on the boot RAID partition
Date: 07 May 2003 19:09:41 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1052327381.649.140.camel@zrr>
References: <1052325714.1551.137.camel@zrr> <3EB93BF5.4E3912EE@SteelEye.com>
Reply-To: zdavatz@generika.cc
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EB93BF5.4E3912EE@SteelEye.com>
To: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 2003-05-07 at 19:01, Paul Clements wrote:
> Zeno Davatz wrote:
> 
> > When I run lilo I get:
> > 
> > Fatal: map file must be on the boot RAID partition.
> > 
> > Why would that be?
> 
> you need to tell lilo the real (physical) disk for your boot partition:
> 
> boot=/dev/hda
Yes, ok. I did that but after a reboot 'df' gives me:

/dev/hdc2 instead of /dev/md0

Why would that be?

Thanks for your time and help.

Zeno

