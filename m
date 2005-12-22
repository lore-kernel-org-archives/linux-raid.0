From: Andrew Burgess <aab@cichlid.com>
Subject: Re: First RAID Setup
Date: Thu, 22 Dec 2005 09:03:02 -0800
Message-ID: <200512221703.jBMH32RW008977@cichlid.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>Since I'll be recreating the array anyway, I might as
>well split /, /home, and /var into three RAID5's.

Consider LVM2 which allows you to change the sizes of those
three partitions.

