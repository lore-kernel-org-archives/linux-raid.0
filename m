From: Stephan van Hienen <raid@a2000.nu>
Subject: readahead (blockdev --setra) with sw raid(5)?
Date: Sat, 27 Nov 2004 23:31:56 +0100 (CET)
Message-ID: <Pine.LNX.4.61.0411272328270.16979@adsl.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

just saw a 3ware document with some hints for hardware raid5
they advice to use blockdev --setra 16384

since i'm not using 3ware hardware raid
(i'm using 2*7500 3ware's with sw raid5 over 14 disks)
i'm wondering if --setra can still improve my raid performance

any hints about this ?
or some other hints, improvements on filesystem ?
i'm currently using blocksize 128, maybe switching to 256 helps ? (with 
large files)
