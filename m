From: Mitchell Laks <mlaks@verizon.net>
Subject: convert degraded raid1 drive to ext3 format
Date: Mon, 10 Jan 2005 02:02:50 -0500
Message-ID: <200501100202.50532.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Only a newbie could ask this question. Guess what, I really am!

I have 4 hard drives on my ssytem to store data. currently i use raid5.

I am seriously considering using raid1 instead of raid5. 
But  I only need raid1 while data is being initially collected on the server. 
So  I would like to use raid1 (with ext3 format) initially and then convert 
to standard ext3 drives.if this is possible.

i have 4 drives  
/dev/hda, /dev/hdc, /dev/hde, /dev/hdg

What I would like to do is use 
stage 1)     /hda and /hdg as  a raid initially and leave /dev/hdc, /dev/hde 
alone
then use
stage 2)    /hdc and /hdg as a raid and use "/hda as if it were a ext3 drive"
then use
stage 3)   /hde and  /hdg as a raid and use "/hda and /hdc as if there were 
ext3 drives"

Now i see easily that I can run at stage3) 

/dev/md0 --      /hda alone in degraded mode
/dev/md1 ----  /hdc alone in degraded mode
/dev/md2 ---    /hde and /hdg together.

if i do raidsetfaulty to /dev/hdg and raidhotremove /dev/hdg each time and add 
it to the new /dev/md1 and /dev/md2 as I need them.

But i would prefer REAL ext3 drives instead of degraded /dev/md0 and /dev/md1 
(i think???). In place of /dev/md0 and /dev/md1.

So my question is: I s it possible to "convert a degraded raid1  consisting of 
a single hard drive over to a standard ext3 format drive (ie /dev/md0 is only 
one drive so can it become ext3) ?" without doing something like rsync of the 
data on /dev/md0  to a fresh drive "the new /dev/hda" ???

Thanks,
Mitchell Laks


