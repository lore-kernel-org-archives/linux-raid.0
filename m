From: Kim =?ISO-8859-1?Q?=20=22H=F8jgaard-Hansen?=
	 =?ISO-8859-1?Q?=22?= <hi_fibrian@yahoo.com>
Subject: kernel 2.6 hardware RAID
Date: Wed, 24 Sep 2003 04:55:07 -0700 (PDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030924115507.75871.qmail@web14307.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a problem trying to run linux 2.6.0 test5 on my
onboard Highpoint RAID controller

What is the naming convention for partitions on a
hardware RAID array when using devfs?

in kernel 2.4 xx it should be something like
/dev/ataraid/disc0/partX or /dev/ataraid/dXpY but this
doesn't seem to work with the 2.6 kernel 

I don't know what to pass as the root kernel
parameter.

I THINK i have enabled all the things needed for
hardware RAID, but i'm not sure, so could someone tell
me what has to be enabled in the 2.6 kernel

__________________________________
Do you Yahoo!?
Yahoo! SiteBuilder - Free, easy-to-use web site design software
http://sitebuilder.yahoo.com
