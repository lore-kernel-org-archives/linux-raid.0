From: adfas asd <chimera_god@yahoo.com>
Subject: Re: Is My Data DESTROYED?!
Date: Fri, 23 Oct 2009 12:24:09 -0700 (PDT)
Message-ID: <170350.56146.qm@web38803.mail.mud.yahoo.com>
References: <70ed7c3e0910222014r7fee262csd67808c75a0aa179@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0910222014r7fee262csd67808c75a0aa179@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Now I'm repeatedly getting this:

This is an automatically generated mail message from mdadm
running on hex

A DegradedArray event had been detected on md device /dev/md0.

Faithfully yours, etc.

P.S. The /proc/mdstat file currently contains the following:

Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4] [multipath] 
md2 : active raid10 sdb3[0] sdc3[1]
      1868558336 blocks 1024K chunks 2 offset-copies [2/2] [UU]
      bitmap: 6/223 pages [24KB], 4096KB chunk

md1 : active (auto-read-only) raid10 sdb2[0] sdc2[1]
      6297088 blocks 256K chunks 2 offset-copies [2/2] [UU]
      bitmap: 0/193 pages [0KB], 16KB chunk

md0 : active raid1 sdb1[0]
      78654144 blocks [2/1] [U_]
      bitmap: 2/151 pages [8KB], 256KB chunk

unused devices: <none>


      
