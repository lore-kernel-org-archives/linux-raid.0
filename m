From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: 4 questions. Chieftec chassis case CA-01B, resync times, selecting ide driver module loading,  raid5 :2 drives on same ide channel
Date: Sun, 16 Jan 2005 14:39:43 -0500
Message-ID: <200501161937.j0GJbn925823@www.watkins-home.com>
References: <200501161119.41349.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200501161119.41349.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mitchell Laks' <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If your rebuild seems too slow, make sure you increase the speed limit!
Details in "man md".

echo 100000 > /proc/sys/dev/raid/speed_limit_max

I added this to /etc/sysctl.conf
# RAID rebuild min/max speed K/Sec per device
dev.raid.speed_limit_min = 1000
dev.raid.speed_limit_max = 100000

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Mitchell Laks
Sent: Sunday, January 16, 2005 11:20 AM
To: maarten
Cc: linux-raid@vger.kernel.org
Subject: 4 questions. Chieftec chassis case CA-01B, resync times, selecting
ide driver module loading, raid5 :2 drives on same ide channel

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
I suspect (correct me if I am wrong) that the hpt302 on the highpoint
website 
is the RIGHT module to use (I notice for instance that when I compare the 
hdparm settings on the western digital drives on the motherboard ide
channels 
are set with more advanced dma settings "turned on" than   on the rocket133 
controllers. Perhaps this is because it is using the 'incorrect hpt366' 
module? 
 
Of course I would prefer to use the hpt302 module  (after i compile it...).
So 
how do I get to insure that the system will use the hpt302 over the hpt366 
that it seems to be chosing. If I 
1) compile the module hpt302 from source 
2) dump it in the /lib/modules/2.6.9-1-386/kernel/drivers/ide/pci directory
3) put a line hpt302 in the /etc/modules file (maybe at the top?)
4) put a line hpt302 at  the top of the file /etc/mkinitd/modules.
5) run mkinitrd to generate the new initrd.img

will this insure that the module hpt302 is loaded on preference to the
hpt366 
module?

4) Maarten mentioned that he had a problem with 2 different drives on the
same 
channel for raid5. What was the problem exactly with that.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

