From: "Andreas-Johann Ulvestad" <aj@nlc.no>
Subject: Problem with disks disappearing
Date: Sat, 10 May 2003 12:27:55 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <54789.195.159.42.130.1052562475.squirrel@pluto.nixia.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, I'm having trouble with a software raid array (RAID-5) consisting of 3
IDE disks connected to two 3ware controllers (thereby coming up as sda,
sdc and sdd). I think either one disk (sdc) or one of the controllers has
become unusable in one way or another, since it won't work properly. When
I have the sdc-disk connected, bootup will start md0, but everything halts
on "Checking filesystems" (Red Hat Linux 7.3 with 2.4.18 (redhat-kernel,
not vanilla)). I've even tried letting it stand like that for 12 hours, no
success.

When I unplug the disc (sdc), sdd is renamed sdb etc.. all the drives are
shifted one place down. What's the result of this? Simple - I can't get
the array online again. It would be great to just tell the array "hey, sdd
is now known as sdc", that way I'd get the array up in degraded mode and
would be able to (slowly) backup my data before I try to find out in
detail what's wrong... hopefully before the 1-year warranty expires, of
course.

So, any suggestions people?

-- 
Andreas-Johann Ulvestad
Norwegian Linux Community
Group for Political Interest
Tel +47 23 40 03 60 | Fax +47 23 40 03 61


