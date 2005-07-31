From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: One disk busy in RAID5?
Date: Sun, 31 Jul 2005 16:33:15 +1000
Message-ID: <17132.28843.756415.335241@cse.unsw.edu.au>
References: <1122736907.2963.26.camel@lian.jtfltd.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Scott White on Saturday July 30
Sender: linux-raid-owner@vger.kernel.org
To: Scott White <scott-raid@riskboys.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday July 30, scott-raid@riskboys.com wrote:
> I'm doing a big rsync to my 5 disk RAID 5 partition and am seeing an
> uneven loading of my disks.  The files are almost all huge video files.
> Has anyone got any idea what I could have done wrong?
> 
> md6 : active raid5 sdi1[4] sdh1[3] sdg1[2] sdf1[1] sde1[0]
>       976783360 blocks level 5, 128k chunk, algorithm 2 [5/5] [UUUUU]
> 
> The filesystem is ext3 created with 
> mkfs.ext3 -R stride=32 /dev/md6

I suggest you ask on ext3-users@redhat.com.
I have seen references to this sort of thing before.  I think some
metadata gets aligned despite the '-R stride=' flag.
Also, I think the stride should be 128 (32 fs-blocks per chunk, 4
chunks per stripe).

NeilBrown
