From: Salatiel Filho <salatiel.filho@gmail.com>
Subject: Raid over USB disks and eject
Date: Mon, 12 Nov 2012 09:44:04 -0300
Message-ID: <CAGmni9rBn9V0kEqirNnLR1iGdaXc48+afuL1NbTg8R5Cr1q9hw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi guys,  i have an external USB enclosure with 4 disks  in RAID5 mode
using mdadm. I dont know exactly why but if i use this disks for
massive I/O for lots of hours (over 12 hours), linux usually eject
some or all disks (causing a faulty in the raid) and remaps them: sdb
-> sdf , sdc -> sdg , sdd -> sdh , sde -> sdi
Well , this was never exactly a problem because most of the time those
disks are idle (just backup), but i had a real disk failure and i will
replace the disk. But probably the rebuild process will take a lot
more than 12 hours so the chances are that some disk will be ejected
and i will be in a trouble situation where a raid5 rebuilding process
will probably be stopped by an apparently failure. So my question is:

If i get into that situation , will i be able to disassemble and
reassemble the disk using the three disks i know are 'fine' and
restart the rebuild process from where it stopped ? I have internal
bitmap enabled.

Is it possible to somehow freeze the rebuild process ? So i could
pause the process for a few hours after 8 hours of work for example.

The raid will be assembled but umounted during the rebuild proccess.

I am using kernel 3.2.30.

Thanks !!!


[]'s
Salatiel
