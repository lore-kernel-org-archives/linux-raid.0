From: Jonas Nickel <jonas.nickel@tu-berlin.de>
Subject: Filesystem did not grow with my RAID 5 array
Date: Tue, 22 Oct 2002 16:32:09 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200210221632.09276.jonas.nickel@tu-berlin.de>
Reply-To: jonas.nickel@tu-berlin.de
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

I used raidreconf to expand a RAID 5 array with three disks (no spares) to one 
with four disks (no spares). The tool seemed to work fine, a check with 

e2fsck -f /dev/md0 

showed no errors. However, a 

df  .

in the directory of the array still shows the old size. Did I miss anything 
obvious and how do I expand the filesystem to the whole array?

Thanks in  advance,

Jonas Nickel

---------------------------------------------------
TU Berlin
Fachgebiet Verbrennungskraftmaschinen
Carnotstr. 1A
10587 Berlin

Tel.: +49 (0) 30 314-22607
Fax.: +49 (0) 30 314-26105
Web: http://www.vkm.tu-berlin.de
---------------------------------------------------
