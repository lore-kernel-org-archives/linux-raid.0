From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm: SET_ARRAY_INFO failed for /dev/md0: File exists
Date: Tue, 4 May 2004 14:10:24 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16535.6064.902073.522523@cse.unsw.edu.au>
References: <012001c430c5$a3e12b70$6705a8c0@a30>
	<16534.64220.901221.482562@cse.unsw.edu.au>
	<014601c4317e$b083e250$6705a8c0@a30>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from me@heyjay.com on Monday May 3
To: me@heyjay.com
Cc: Neil Brown <neilb@cse.unsw.edu.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday May 3, me@heyjay.com wrote:
> > What does
> >   cat /proc/mdstat
> > show?  I suspect /dev/md0 has already been assembled somehow.
> 
> platinum:~# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid5]
> md3 : active raid1 hdc1[1]
>       20000768 blocks [2/1] [_U]
> 
> md1 : active raid1 hdc2[1]
>       40001728 blocks [2/1] [_U]
> 
> md2 : active raid1 hdc3[1]
>       40001728 blocks [2/1] [_U]
> 
> unused devices: <none>
> 
> But how??? I didn't build it.  Is it possible to remain after
> installs?  

If the partitions are marked as "Linux RAID Autodetect", or if some
startup script used mdadm or raidstart to start the arrays, then they
will reappear after reboot.

NeilBrown


