From: Mental Patient <mental@neverlight.com>
Subject: ataraid in 2.6?
Date: Mon, 20 Oct 2003 22:08:18 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3F949512.30907@neverlight.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Forgive me if this is a faq, but I'm trying to get my high point raid 
controler working under 2.6. For various reasons (mainly support for my 
kt400 agp chipset) 2.4 isn't going to work for me.

I've done some looking and grepping through the code, but ataraid is 
nowhere to be found. The docs I've found regarding the high point 
controler indicate that I should be enabling ataraid in the same section 
where ide support is in the kernel config.

http://lists.insecure.org/lists/linux-kernel/2003/Sep/5600.html

This message indicates that 2.6 doesnt have ata-raid (yet) and that the 
device mapper can be used instead. Is this correct? Is this in any way 
related to the md driver used for software raid? Would a different card 
be better supported? Something from 3ware perhaps?

http://www.spinics.net/lists/raid/msg03448.html

This message also points me towards the device mapper. Has/is anyone 
using a high point 372 under linux 2.6.0-test???

If some kind soul could point me in the right direction, I would greatly 
appreciate it. Please cc me as I'm not on the list.

Thanks much.

-- 
Jason

