From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Linux mdadm superblock question.
Date: Thu, 11 Feb 2010 18:00:23 -0500 (EST)
Message-ID: <alpine.DEB.2.00.1002111758350.12031@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I may be converting a host to ext4 and was curious, is 0.90 still the only 
superblock version for mdadm/raid-1 that you can boot from without having 
to create an initrd/etc?

Are there any benefits to using a superblock > 0.90 for a raid-1 boot 
volume < 2TB?

Justin.
