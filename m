From: "Sean Kormilo" <skormilo@nortelnetworks.com>
Subject: Re: [PATCH] md - 1 of 12 - Missing mddev_put in md resync code
Date: 17 Mar 2003 08:47:30 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1047908849.30791.76.camel@wmery000.ca.nortel.com>
References: <E18sxOy-0004pf-00@notabene.cse.unsw.edu.au>
	 <1047491327.30792.3.camel@wmery000.ca.nortel.com>
	 <15983.43970.946123.962678@notabene.cse.unsw.edu.au>
	 <1047563289.30797.13.camel@wmery000.ca.nortel.com>
	 <15985.16771.885438.47395@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15985.16771.885438.47395@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil,

> > Yes in fact, that is the one I was seeing.
> > 
> 
> That one *should* be fixed in 2.4.-current-bk, but probably not
> completely.  It is actually rather hard to get it just-right in 2.4.
> I substantially reworked the 2.5 code so that proper locking could be
> done so that this sort of problem could be avoided.  
> 2.4 will porbably have to stay with "close-enough".

I'm fairly certain I already had any relevent patches applied when I saw
the panic, but there were 1 or 2 that I didn't already have. At any
rate, I seem to have been able to work around it.

> > 
> > I have an odd problem where the first rebuild performs as expected
> > (about 40MB/s), but any subsequent rebuild plods along at about 6-7MB/s.
> > There is no IO activity on the system other than the rebuild during my
> > tests.
> 
> Does upping /proc/sys/dev/raid/speed_limit_min affect the speed?
> 
> Does increasing the magic "32" in is_mddev_idle help

I tried increasing it to 128, and no, it didn't make any difference,
however...

this just got really interesting now... found something I hadn't
noticed.

I've determined that the performance issues I'm seeing only happen when
I'm rebuilding from the second disk in the array to the first. ie: if I
remove disk0, and then re-insert it, the performance is lousy. If I
remove disk1 and then re-insert it, the performance is good.

I've played with both speed_limit_min and speed_limit_max... it makes no
difference. My speed_limit_min was set to 15000, but was still only
getting 7MB/s.

cat /proc/sys/dev/raid/speed_limit_max 
100000
cat /proc/sys/dev/raid/speed_limit_min 
15000

Good speed results: (sdb1/2 were failed, removed, and inserted)

cat /proc/mdstat
Personalities : [raid1] 
read_ahead 1024 sectors
md0 : active raid1 sdb1[1] sda1[0]
      104320 blocks [2/2] [UU]
      
md1 : active raid1 sdb2[2] sda2[0]
      35455360 blocks [2/1] [U_]
      [===========>.........]  recovery = 55.8% (19804352/35455360) finish=4.7min speed=55372K/sec
unused devices: <none>


Poor speed results: (sda1/2 were failed, removed and inserted)
cat /proc/mdstat
Personalities : [raid1] 
read_ahead 1024 sectors
md0 : active raid1 sda1[0] sdb1[1]
      104320 blocks [2/2] [UU]
      
md1 : active raid1 sda2[2] sdb2[1]
      35455360 blocks [2/1] [_U]
      [>....................]  recovery =  0.2% (88000/35455360) finish=86.9min speed=6769K/sec
unused devices: <none>

Any pointers as to where I should look now based on this? Possible SCSI
device driver issue?

Sean.


-- 

Sean C. Kormilo, STORM Software Architect, Nortel Networks
              email: skormilo@nortelnetworks.com
  

