From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Fatal: map file must be on the boot RAID partition
Date: Wed, 07 May 2003 13:15:57 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB93F4D.501B2106@SteelEye.com>
References: <1052325714.1551.137.camel@zrr> <3EB93BF5.4E3912EE@SteelEye.com> <1052327381.649.140.camel@zrr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: zdavatz@generika.cc
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Zeno Davatz wrote:

> Yes, ok. I did that but after a reboot 'df' gives me:
> 
> /dev/hdc2 instead of /dev/md0
> 
> Why would that be?

did you change your /etc/fstab? what does /proc/mdstat say?

--
Paul
