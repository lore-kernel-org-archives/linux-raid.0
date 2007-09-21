From: Daniel Santos <daniel.dlds@gmail.com>
Subject: raid5 post mortem analisys
Date: Fri, 21 Sep 2007 17:25:19 +0100
Message-ID: <46F3F06F.1060008@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I had a raid 5 array with 3 drives. (on a USB 2.0 bus :)). After some 
time, on drive failed. After some more time another drive failed and the 
array stopped running.
I know that the usage pattern from the first failure to the second was 
read-only, i.e as a user only reads were performed.
I also know that the cause of the drive's failures was that they just 
dissapeared from the USB bus (probably from a bug in the hard drive's 
enclosure's USB to IDE bridge)

I trashed the array anyway, but since I am new to linux md devices, I 
was wishing that you could help me understand if there was any 
possibility of getting it back up assuming that there was no data 
corruption.
I run kernel 2.6.17 on a debian system and use mdadm for controlling the 
array from user space.

Daniel Santos
