From: Matthias Dahl <ml_linux_raid@mortal-soul.de>
Subject: RAID5 and barrier support
Date: Thu, 25 Feb 2010 13:53:56 +0100
Message-ID: <201002251353.57127.ml_linux_raid@mortal-soul.de>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi.

Since w/ 2.6.33 software raid 5 now supports barriers, has anyone already done 
some benchmarks or gained some experience with regard to performance and 
latency (stalls, ...)? I guess the following two cases would be the most 
interesting w/ a decent fs (ext4?):

 - component drives w/ write cache and barriers enabled
 - component drives w/ write cache and barriers disabled (like in pre-2.6.33)

So long,
matthias.
