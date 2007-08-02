From: Neil Brown <neilb@suse.de>
Subject: Re: RAID6 --grow won't restart after disk failure
Date: Thu, 2 Aug 2007 13:09:53 +1000
Message-ID: <18097.19201.261521.678783@notabene.brown>
References: <46B112C0.8040509@zetafleet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Colin Snover on Wednesday August 1
Sender: linux-raid-owner@vger.kernel.org
To: Colin Snover <linux-raid@zetafleet.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday August 1, linux-raid@zetafleet.com wrote:
> 
> # cat /proc/mdstat # AFTER array restart
> Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5]
> [raid4] [raid10]
> md0 : active(auto-read-only) raid6 sdb1[1] sdf1[5] sde1[4] sdd1[3] sdc1[2]
              ^^^^^^^^^^^^^^^^
>       1953053696 blocks super 0.91 level 6, 64k chunk, algorithm 2 [7/5]
> [_UUUUU_]
> 
> unused devices: <none>
> 

Reshape won't restart while the array is auto-read-only.
You can start it simply by mounting the filesystem, or with
  mdadm /dev/md0 --readwrite

NeilBrown
