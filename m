From: Hank Barta <hbarta@gmail.com>
Subject: Re: disk failed, operator error: Now can't use RAID
Date: Thu, 14 Jul 2005 18:05:11 -0500
Message-ID: <75007249050714160559cc2588@mail.gmail.com>
References: <7500724905071314574a13d966@mail.gmail.com>
	 <7500724905071317297f7277a7@mail.gmail.com>
	 <17110.3677.293133.503161@cse.unsw.edu.au>
Reply-To: Hank Barta <hbarta@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17110.3677.293133.503161@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7/14/05, Neil Brown <neilb@cse.unsw.edu.au> wrote:
> On Wednesday July 13, hbarta@gmail.com wrote:
> >
> > I would very much appreciate suggestions on how to get the raid
> > running again.
> 
> Remove the
> >    devices=/dev/hde1,/dev/sdd1,/dev/sdc1,/dev/sdb1,/dev/sda1
> 
> line from mdadm.conf (it is wrong and un-needed).
> 
> Then
>   mdadm -S /dev/md0  # just to be sure
>   mdadm -A /dev/md0 -f /dev/sd[abcd]1 /dev/hd[eg]1
> 
> and see if that works.

Yes, Thanks!

Results are:

oak:~# mdadm -S /dev/md0
oak:~# mdadm -A /dev/md0 -f /dev/sd[abcd]1 /dev/hd[eg]1
mdadm: forcing event count in /dev/sda1(0) from 1271893 upto 2816178
mdadm: /dev/md0 has been started with 4 drives (out of 5) and 1 spare.
oak:~# cat /proc/mdstat
Personalities : [raid5]
md0 : active raid5 sda1[0] hde1[5] sdd1[3] sdc1[2] sdb1[1]
      781433344 blocks level 5, 32k chunk, algorithm 2 [5/4] [UUUU_]
      [>....................]  recovery =  0.1% (389320/195358336)
finish=280.4min speed=11585K/sec
unused devices: <none>
oak:~#

Now... After this is through rebuilding, I need to replace the failed
drive. (Creating one partition and setting it to type 0xFD (Linux raid
autodetect)

What's the best way to get this in service with one drive as a spare?
Can I convert my current spare (/dev/hde1) to a regular disk and add
the new disk as a spare?

Or should I add the new disk as an active drive and if so, will it be
rebuilt and the spare (/dev/hde1) be relegated back as a spare?

thanks again,
hank

-- 
Beautiful Sunny Winfield, Illinois
