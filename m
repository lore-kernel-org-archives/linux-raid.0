From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: strange performance of raid0
Date: Sun, 15 Feb 2004 11:04:32 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040215100432.GA19002@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I have some strange performance results on a raid0
I have 4 IDE disks on two controllers, the one on the 
motherboard of the duron 1 GHz mackine, the other a promise TX2 plus 
SATA + PATA controller. I run kernel 2.4.22

The disks and hdparm -t on each of them

/dev/hdc1 seagate 80 GB                   16 MB/s
/dev/sda1 maxtor sata 200 GB              50 MB/s
/dev/sdb7 maxtor 160 GB                   54 MB/s

The partitions are al about 5 GB each.

If I make a raid0 device of all of them I get a thruput of 45 MB/s
IIf I exclude the hdc1 partition, I get around 75 MB/s.
The system is a little loaded - but that would be normal operating
conditions. CPU is 90 % idle. I have about 100 MB free RAM.

Why is it slower with 3 disks in the raid0 than
2 disks? Why don't I get approx 100 MB/s out of just the two?

Best regards
Keld

