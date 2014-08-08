From: mdraid.pkoch@dfgh.net (Peter Koch)
Subject: parallel access to RAID10-array
Date: Fri, 8 Aug 2014 19:31:35 +0200
Message-ID: <201408081731.s78HVZbJ018183@portal.naev.de>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: 
References: 
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear readers,

I created 4 raid1-array and besides the different devices the
mdadm command was exactly the same for all 4 arrays:

md1 : active raid1 sdo1[1] sda1[0]
      504768 blocks [2/2] [UU]

md2 : active raid1 sdo2[1] sda2[0]
      8000448 blocks [2/2] [UU]

md3 : active raid1 sdo3[1] sda3[0]
      4996032 blocks [2/2] [UU]

md4 : active raid1 sdo4[1] sda4[0]
      147332160 blocks [2/2] [UU]
      bitmap: 0/2 pages [0KB], 65536KB chunk

md4 has a bitmap while md1,2,3 do not. I'm
using mdadm 3.3 with a 3.14.12 kernel.

Is that a new feature of mdadm 3.3?
Any other explanation?

Kind regards

Peter Koch
