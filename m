From: Eric BENARD / Free <ebenard@free.fr>
Subject: MD drivers problems on 2.4.x
Date: Fri, 23 May 2003 15:35:17 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305231535.17808.ebenard@free.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I would like to know what is the md driver status on 2.4.19 and 2.4.20 kernels 
?
I ve got many problems with RAID 0 (/tmp), 1 (/, /usr/var) and 5 (/home) using 
these kernels and 4 IDE drives with ext3 partitions. In the end each time I 
lose all the data :-( 
After many tests (RAM is OK, HD don't have badblocks), I think the problems 
comes from the md layer.

May a switch to 2.4.21-rc3 solve my problems ?

Did anyone here already meet this problem ?

Many thanks and best regards

Eric
