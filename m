From: adfas asd <chimera_god@yahoo.com>
Subject: Disappointing RAID10 Performance
Date: Fri, 16 Oct 2009 10:32:14 -0700 (PDT)
Message-ID: <364346.70897.qm@web38808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I was hoping to get better performance with RAID10 than from the raw disks, but that's turned out to not be the case.  Experimenting with the readahead buffer I get these bandwidths with the following command:
# time dd if={somelarge}.iso of=/dev/null bs={readahead size}

/dev/sd?
 1024 71.3 MB/s
 2048 71.2 MB/s
 4096 77.7 MB/s
 8192 69.4 MB/s
 16384 76.6 MB/s

/dev/md2
 1024  67.1
 2048  69.1
 4096  75.7
 8192  64.9
 16384 69.0

Using RAID10offset2 on 2 WD 2TB drives, and always the same input file.

Why would RAID10 performance be -poorer-? 
If it weren't for mirroring, this wouldn't be worth it.


 


      
