From: Miroslaw Mieszczak <mirek@mieszczak.com.pl>
Subject: Propose of enhancement of raid1 driver
Date: Tue, 17 Oct 2006 08:51:26 +0200
Message-ID: <45347D6E.3000600@mieszczak.com.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I would like to propose an enhancement of raid 1 driver in linux kernel.
The enhancement would be speedup of data reading on mirrored partitions.
The idea is easy.
If we have mirrored partition over 2 disks, and these disk are in sync, there is
possibility of simultaneous reading of the data from both disks on the same way
as in raid 0. So it would be chunk1 read from master, chunk2 read from slave at
the same time. 
As result it would give significant speedup of read operation (comparable with
speed of raid 0 disks).

