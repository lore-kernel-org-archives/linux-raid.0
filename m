From: "Brett I. Holcomb" <brettholcomb@charter.net>
Subject: Adaptec 3210S commands
Date: Sat, 2 Apr 2005 20:57:45 -0500
Message-ID: <Pine.LNX.4.62.0504022030300.9514@gandalf>
Reply-To: sxs.lists.linux-users@charter.net
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a 3210S with six drives.  I've created two RAID1 arrays with two 
drives each and now I want to do a RAID0 with these two RAID1 arrays.  I'm 
trying to use the raidutil on the Adaptec boot CD - because it appears 
the GUI won't do it - but keep getting an error "RAID component tag" when I do

        raidutil -d 0 -l 0 -g +d0b0t0d0,+d0b0t1d0

The addresses above are the what raidutil -L array shows for the array 
addresses but also correspond to the first drive in each RAID 1.

I've tried various combinations, checked the docs, googled, and searched 
Adaptec's site but no luck.

What am I doing wrong.

Thanks.

-- 
Brett I. Holcomb
brettholcomb@R777charter.net
Registered Linux User #188143
Remove R777 to email

