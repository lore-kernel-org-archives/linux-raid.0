From: ddx <ddx@xs4all.nl>
Subject: slow raid5 performance kernel 2.6 vs 2.4
Date: Sun, 12 Dec 2004 21:18:38 +0100 (CET)
Message-ID: <20041212211330.M51235-100000@xs3.xs4all.nl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

system :

P4 2.4GHz HT, 1GB DDR
8*  S-ATA 250GB Hitachi on 2 Si3114 controllers

bonnie performance with 2.4 :
block input 126MB/sec

with 2.6 :
block input 90MB/sec

saw another posting about slow read performance with raid5 and 2.6
any ideas yet how to fix this ?


