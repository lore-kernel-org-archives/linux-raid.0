From: "Raz Ben-Jehuda(caro)" <raziebe@gmail.com>
Subject: raid 0 read performance
Date: Thu, 29 Dec 2005 02:10:30 -0800
Message-ID: <5d96567b0512290210q2f4b63c5tc91a49523c93e4df@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
Cc: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

Neil hello.

I have tested the overhead of linux raid0.
I used two scsi atlas maxtor disks ( 147 MB) and combined them to single
raid0 volume.
The raid is striped in 256K stripes.

I filled the raid0 up to the maximum with files over xfs file system.
I've checked the peformance of reading 60 files like that:

while need to read
 for every file
     read 0.5 M from file


I got 50 MB/s .

Armed with this knowledge i went and did the same test over
one disk and i got 32 MB/s .

Question:
 why is this perfomance drop ?


thank  you
--
Raz
