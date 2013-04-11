From: "Vanhorn, Mike" <michael.vanhorn@wright.edu>
Subject: Re: Odd --examine output
Date: Thu, 11 Apr 2013 20:31:08 +0000
Message-ID: <CD8C946E.4111D%michael.vanhorn@wright.edu>
References: <CD8C2921.40FB6%michael.vanhorn@wright.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CD8C2921.40FB6%michael.vanhorn@wright.edu>
Content-Language: en-US
Content-ID: <92ACBFEB5A72B4408AD3465E9F010355@prod.exchangelabs.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


>Why doesn't it instead give the same sort of metadata that the other disks
>show? It's as if there is no raid superblock on these two disks, but how
>is this possible if the disks have been part of a working array?

Update: by chance, I discovered that if I

 mdadm -e /dev/sdg1

then I get the output of the superblock. That is, the superblock is found
on the partition (apparently) but not on the disk device. This also works
for disk sdh, for which I couldn't find a superblock, either. However, for
the rest of the disks from the array (sd[cdefi]), there is no such device
as "sdc1", for example.

I have also discovered that for the drives where mdadm -e /dev/sdc (just
the disk) works, the version of the metadata is 0.90.00, where as those
other two where the superblock is on the partition (i.e. sdg1), the
version is 1.2. This makes more sense, since I create the array originally
(back in December) with the following command:

 mdadm --create --verbose /dev/md0 --metadata=1.2 --level=6
--raid-devices=7 /dev/sdc1 /dev/sdd1 /dev/sde1 /dev/sdf1 /dev/sdg1
/dev/sdh1 /dev/sdi1 --spare-devices=1 /dev/sdj1


So, if I created the array using version 1.2 of the metadata and the
devices specified are sd[cdefghij]1, then why am I not able to see that
metadata now?

I am really confused.

---
Mike VanHorn
Senior Computer Systems Administrator
College of Engineering and Computer Science
Wright State University
265 Russ Engineering Center
937-775-5157
michael.vanhorn@wright.edu
http://www.cecs.wright.edu/~mvanhorn/




