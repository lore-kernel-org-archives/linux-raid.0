From: Danilo Godec <danci@agenda.si>
Subject: Multiple disk failure - recover?
Date: Wed, 10 Jul 2002 15:10:22 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.30.0207101505480.25329-100000@duplo.agenda.si>
References: <3D2C1993.ABA5EEA0@upb.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3D2C1993.ABA5EEA0@upb.de>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

I have (had) a three disk RAID5 array. One of the disks (sdb2) has failed,
however, under circumstances, two of the diskes were kicked out of the
array.

I tried re-assembling the array using 'mdadm --assemble --force /dev/md1
/dev/sda2 /dev/sdc2 /dev/sdb2', but it always takes the sdc2 & sdb2 as OK
disks and sda2 as failed.

Of course, when the reconstruction hits the bad area on sdb2, it all fails
again.

How can I tell mdadm that /dev/sda2 and /dev/sdc2 are the disks I want as
'good'!?

Thanks, D.



