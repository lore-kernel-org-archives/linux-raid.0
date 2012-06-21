From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Stacked array data recovery
Date: Thu, 21 Jun 2012 22:44:10 +0000 (UTC)
Message-ID: <js083q$kdu$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi all

I had a media server at home with a raid5 array containing four disks 
where I ran out of space. The solution with a separate NAS was nothing I 
liked so I wanted to enlarge my server.

I bought a Norco case with 20 hot swap slots.

With the kind help of Stan Hoeppner I was able to find good hardware to 
connect the disks.
Maybe it's not important but it's a LSI MegaRAID SAS 9240-4i, an Intel SAS 
expander and the mainboard is a Asus P7P55D.
I use Debian Squeeze with the backported 3.2.0-2-amd64 kernel.
The mdadm package version is "v3.1.4 - 31st August 2010"
(More information about the drives are below in the pastebins.)

The plan was to setup several RAID5 as members of a linear raid.

Unfortunately I was too stupid to cool the disks so probably they are 
damaged and I will have to replace them (hopefully still under warranty).

I set up md1 with four WD greens 2 TB (mdadm -C /dev/md1 -c 128 -n4 -l5 /
dev/sd[abcd]) and added it as a single device to the linear array md0 
(mdadm -C /dev/md0 --force -n1 -l linear /dev/md1).
Then I copied the data from the old raid to it (btw the filesystem on md0 
is xfs if this is relevant).
During this process the disks weren't cooled.
They are about 1-2 years old and mdadm marked some of them as faulty. I 
thought this was because they were green drives and bought four new WD 
black 2TB drives.

I tried the same again and this time it worked well.
Then I took the four Samsung 1.5 TB drives from the old server and added 
them to the Norco case. With them I created the RAID5 array md2, grew the 
linear array md0 and its filesystem.

Until then I thought it would be wise to use the array already when it 
still syncing the disks.
During this process the disks of md1 made strange noises and were set 
faulty as well as some disks of md2.

Here are the mails I got from mdadm:
http://pastebin.com/raw.php?i=ftpmfSpv

Now I have solved the cooling problem and want to replace the disks. But 
I'd like to try to rescue the data on md0.

I did a smartctl readout of the disks. Here's a summary of the disks I 
have:

/dev/sd[abcd] WD blacks md1
/dev/sd[efgh] Samsungs md2
/dev/sd[jklm] WD green md3 (not yet created)

This is the output of "smartctl -l error" for each of the disks:
http://pastebin.com/raw.php?i=JtYkweNp

and "smartctl -x":
http://pastebin.com/raw.php?i=QFK6dyZs

and "smartctl -H":
http://pastebin.com/raw.php?i=hAEdyvCz

When I start the system md2 gets started and is syncing the disks. But 
md1 is stopped.

Is it possible to start md1 again to be able to start the linear array 
md0 so that I can accesss the data?

Thanks in advance for any help.


Best regards
Ramon

