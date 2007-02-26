From: jahammonds prost <gmitch64@yahoo.com>
Subject: Re: trouble creating array
Date: Mon, 26 Feb 2007 06:16:22 -0800 (PST)
Message-ID: <951660.37205.qm@web55812.mail.re3.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rebooted and checked that there were no arrays defined. I have 2 cards in the server - one is a VIA based card, with a single Maxtor, the other this a Promise based card, with 2 Maxtors by Seagate on it. I've been into the config utilites on both cards, and none of them have arrays defined on them.

----- Original Message ----
From: Neil Brown <neilb@suse.de>
To: jahammonds prost <gmitch64@yahoo.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>; linux-raid@vger.kernel.org
Sent: Sunday, 25 February, 2007 11:40:26 PM
Subject: Re: trouble creating array


On Sunday February 25, gmitch64@yahoo.com wrote:
> 
> 
> Any ideas how to find out what has it open? I can happily write all over the disk with dd... I can create and delete the partition, and it's all good... I will try deleting the sd{b,c}1 partitions, reboot, and see what happens.
> 

ls -l /sys/block/*/holders/* ??

NeilBrown


		
___________________________________________________________ 
The all-new Yahoo! Mail goes wherever you go - free your email address from your Internet provider. http://uk.docs.yahoo.com/nowyoucan.html
