From: Paul Clements <Paul.Clements@SteelEye.com>
Subject: Re: Fatal: map file must be on the boot RAID partition
Date: Wed, 07 May 2003 13:01:41 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EB93BF5.4E3912EE@SteelEye.com>
References: <1052325714.1551.137.camel@zrr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: zdavatz@generika.cc
Cc: Linux-Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Zeno Davatz wrote:

> When I run lilo I get:
> 
> Fatal: map file must be on the boot RAID partition.
> 
> Why would that be?

you need to tell lilo the real (physical) disk for your boot partition:

boot=/dev/hda

or similar

--
Paul
