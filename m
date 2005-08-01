From: Forrest Taylor <ftaylor@redhat.com>
Subject: Re: One disk busy in RAID5?
Date: Mon, 01 Aug 2005 08:30:59 -0600
Message-ID: <1122906658.9548.4.camel@x1-6-00-0d-60-fd-e8-4c>
References: <1122736907.2963.26.camel@lian.jtfltd.co.uk>
	 <17132.28843.756415.335241@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17132.28843.756415.335241@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, 2005-07-31 at 00:33, Neil Brown wrote:
> On Saturday July 30, scott-raid@riskboys.com wrote:
> > I'm doing a big rsync to my 5 disk RAID 5 partition and am seeing an
> > uneven loading of my disks.  The files are almost all huge video files.
> > Has anyone got any idea what I could have done wrong?
> > 
> > md6 : active raid5 sdi1[4] sdh1[3] sdg1[2] sdf1[1] sde1[0]
> >       976783360 blocks level 5, 128k chunk, algorithm 2 [5/5] [UUUUU]
> > 
> > The filesystem is ext3 created with 
> > mkfs.ext3 -R stride=32 /dev/md6
> 
> I suggest you ask on ext3-users@redhat.com.
> I have seen references to this sort of thing before.  I think some
> metadata gets aligned despite the '-R stride=' flag.
> Also, I think the stride should be 128 (32 fs-blocks per chunk, 4
> chunks per stripe).
> 
> NeilBrown

Speaking of which, how does one determine the stride size?  If I do:
  mdadm -C /dev/md0 -l 5 -c 64 -n 2 /dev/sd{ab}1
  mke2fs -j -b 4096 -R stride=???  /dev/md0

What should the stride size be--64x4?  Is the default chunk size still
64K?

Thanks,

Forrest

