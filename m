From: Matt Callaghan <matt_callaghan@sympatico.ca>
Subject: Growing Array (More Devices) - new devices are slightly smaller than
 the existing drives, unable to shrink array
Date: Sat, 28 Sep 2013 10:49:49 -0400
Message-ID: <BLU0-SMTP69424F8624CF692DCD2AD7812A0@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello mdadm Linux-RAID experts;

My Goal: Expand (grow) my array from 6xHDD (RAID6) to 8xHDD (RAID6)

This is my root cause problem: when I went to try to add the new drive 
(already formatted for Linux RAID partition):

fermulator@fermmy-server:~$ sudo mdadm --add /dev/md2000 /dev/sdq1
mdadm: /dev/sdq1 not large enough to join array

As I have researched and learned, I need to:
  A) shrink the filesystem (ext4) -- done (shrunk by a generous 1.6GB)
  B) shrink the array size -- incomplete (unable to proceed, the --grow 
command doesn't do anything)

I've been following this guide: 
http://webapp5.rrz.uni-hamburg.de/SuSe-Dokumentation/manual/sles-manuals_en/manual/raidresize.html#resizedecrraid 


This pastebin shows my array details, the 'existing' drives (fdisk) and 
'new' drives (fdisk) - http://pastebin.com/U04VJpE4

Any ideas?

~Matt
