From: "Loris-Guillaume Minoia" <miguillo@hotmail.com>
Subject: moving softraid5 from a computer to another
Date: Mon, 22 Sep 2003 23:52:01 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <BAY2-F54lGRIgSekrVr00022e54@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
perhaps some of you could help me
this week-end, the server crashed (in fact processor burned) but raid has 
nothing (i hope)
The problem is that i cant have access to the data:

old config (amd850MHz on asus a7v)
number in array: 0 primary master on second ide host (ultraata100)
number in array: 1 primary slave on second ide host (ultraata100)
number in array: 2 secondary master on second ide host (ultraata100)
new config (p2 on asus p2b) (i know it's older that the old config)
number in array: 0 primary slave on first ide host
number in array: 1 secondary master on first ide host
number in array: 2 secondary slave on first ide host

when i try to start the raid (raidstart --all) it recognise only 1 (one) 
disk as member of the array but i can found which (neither in the log nor on 
screen "dump") and it don't whant to do anything because there is not enough 
membre.
so my question is: how do i say to the array that old config are now (on the 
temp computer) the new (disk name changed)?
so i called my best friend in such case (google) to help me. Except the 
"software raid linux howto" (SRLH) where the 2 disk failure dont inspirate 
me, i found 
http://www.mathematik.uni-marburg.de/sys/os/linux/install/raid.html that 
says the same thing as SRLH about superblock.
another question: is that a problem of superblock? what should i do?

Loris

PS: sorry for using hotmail (no more other mail) and sorry again for my 
english

_________________________________________________________________
Frustrated with dial-up? Get high-speed for as low as $29.95/month 
(depending on the local service providers in your area).  
https://broadband.msn.com

