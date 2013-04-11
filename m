From: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Subject: Odd --examine output
Date: Thu, 11 Apr 2013 12:47:31 +0000
Message-ID: <CD8C2921.40FB6%michael.vanhorn@wright.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Content-ID: <C9C8F1EA7DAC59448043602D76232066@prod.exchangelabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


These two disks are (or, at least, were) part of my failed level 6 array.
What does this output indicate?

# mdadm --examine /dev/sdg
/dev/sdg:
   MBR Magic : aa55
Partition[0] :   3907024002 sectors at           63 (type fd)
# mdadm --examine /dev/sdh
/dev/sdh:
   MBR Magic : aa55
Partition[0] :   3907024002 sectors at           63 (type fd)

Why doesn't it instead give the same sort of metadata that the other disks
show? It's as if there is no raid superblock on these two disks, but how
is this possible if the disks have been part of a working array?


---
Mike VanHorn
Senior Computer Systems Administrator
College of Engineering and Computer Science
Wright State University
265 Russ Engineering Center
937-775-5157
michael.vanhorn@wright.edu
http://www.cecs.wright.edu/~mvanhorn/




