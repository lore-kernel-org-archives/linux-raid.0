From: "T. Ermlich" <pelegrine@gmx.net>
Subject: Broken harddisk
Date: Sat, 29 Jan 2005 01:22:23 +0100
Message-ID: <41FAD73F.1070504@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello there,

I just got here from http://cgi.cse.unsw.edu.au/~neilb/Contact ...
Hopefully I'm more/less right here.

Several month ago I set-up an raid1 using mdadm.
Two drives (/dev/sda & /dev/sdb, each one is an 160GB Samsung SATA 
disks) are used, and provide now /dev/md0, /dev/md1, /dev/md2 & 
/dev/md3. In november 2004 I upgraded to mdadm 1.8.1.
This afternoon, about 9 hours ago, /dev/sda broke down ... no chnace to 
get it working again .. :(

My question now is: what does I have to do now?
The system is up and running, so I'd do an actual backup of the most 
important data ... but how to 'replace' the broken drive, and 'restore' 
the data content there (sorry, as english is not my native language I 
have no idea how to explain it correctly).
Is there a way to do so, or does I have to create an raid1 from scratch, 
and copy all data from /dev/md0-3 there manually?

Thanks in advance
Torsten

