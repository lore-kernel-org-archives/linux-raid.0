From: Farkas Levente <lfarkas@bnap.hu>
Subject: highpoint rocketraid 133 kernel crash
Date: Fri, 04 Apr 2003 11:28:15 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E8D502F.4030902@bnap.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org, Redhat Devel <redhat-devel-list@redhat.com>
List-Id: linux-raid.ids

hi,
after I see in the kernel changelog that the 2.4.20 kernel already 
support HPT372A chipset I try to install rh 9's kernel to one of our rh 
8.0 machine in which we have 4 HP rocketraid 133 adapter card. until now 
I use a custom kernel (drived from rh's src.rpm, remove all HPT support,
compile HPT's "opensource" driver and use hdx=noprobe for all ide drive 
to prevent "lost interrupt"). now with the new kernel-2.4.20-8 the "lost 
interrupt" disapear, the ide drives and the raid are working for a few 
minutes, but after that the kernel stops for a few second, gives a 
registry dump (and some sort error message about ide-dma error). so IMHO 
it still better to use the hpt's deriver and disable the mainstream 
kernel's hpt support.

-- 
   Levente                               "Si vis pacem para bellum!"


