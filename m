From: Mitchell Laks <mlaks@verizon.net>
Subject: 4 questions. Chieftec chassis case CA-01B, resync times, selecting ide driver module loading,  raid5 :2 drives on same ide channel
Date: Sun, 16 Jan 2005 11:19:41 -0500
Message-ID: <200501161119.41349.mlaks@verizon.net>
References: <crmt7e$8d6$1@sea.gmane.org> <Pine.LNX.4.56.0501101634250.17714@lion.drogon.net> <200501101810.49798.maarten@ultratux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-8-i"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501101810.49798.maarten@ultratux.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

HI,
I have 3 questions. 

1) Maarten, Where did you buy the big chieftec chasis (CA-01B  i think) and 
what did you pay for it?  I have been using antec sx1000 chasis and yours 
looks better and bigger. 

2) Also what are reasonable resync times for your big raid5 arrays?
I had resync time or two days by accident recently for 4x 250 hard drives 
because i did not have dma enabled. that is solved, but i had switched to 
raid1 in the interm and now i am curious what others are used to.

3) Also, i have a module driver question.
I use a asus K8V-X motherboard. It has sata and parallel ide channels. I use 
the sata for my system and use the  parallel for data storage on ide raid.
I am using  combining the 2 motherboard IDE cable channels with highpoint 
rocket133 cards to provide 2 more ide ata channels. 

I installed debian and it defaulted to using the hpt366 modules for the 
rocket133 controllers. 
I suspect (correct me if I am wrong) that the hpt302 on the highpoint website 
is the RIGHT module to use (I notice for instance that when I compare the 
hdparm settings on the western digital drives on the motherboard ide channels 
are set with more advanced dma settings "turned on" than   on the rocket133 
controllers. Perhaps this is because it is using the 'incorrect hpt366' 
module? 
 
Of course I would prefer to use the hpt302 module  (after i compile it...). So 
how do I get to insure that the system will use the hpt302 over the hpt366 
that it seems to be chosing. If I 
1) compile the module hpt302 from source 
2) dump it in the /lib/modules/2.6.9-1-386/kernel/drivers/ide/pci directory
3) put a line hpt302 in the /etc/modules file (maybe at the top?)
4) put a line hpt302 at  the top of the file /etc/mkinitd/modules.
5) run mkinitrd to generate the new initrd.img

will this insure that the module hpt302 is loaded on preference to the hpt366 
module?

4) Maarten mentioned that he had a problem with 2 different drives on the same 
channel for raid5. What was the problem exactly with that.
