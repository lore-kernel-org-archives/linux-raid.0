From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: performance problems with raid10,f2
Date: Sat, 15 Mar 2008 00:11:51 +0100
Message-ID: <20080314231151.GA14568@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi

I have a 4 drive array with 1 TB Hitachi disks, formatted as raid10,f2

I had some strange observations:

1. while resyncing I could get the raid to give me about 320 MB/s in
sequential read, which was good. After resync had been done, and with
all 4 drives active, I only get 115 MB/s.

2. while resyncing, the IO rate on each disk is about 27 MB/s - and the 
rate of each sdisk is about 82 MB/s. Why is this?

best regards
keld
