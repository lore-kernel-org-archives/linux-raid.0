From: Neil Brown <neilb@suse.de>
Subject: Re: mdadm: making a spare actie
Date: Fri, 20 Jun 2008 10:33:25 +1000
Message-ID: <18522.64213.285243.770425@notabene.brown>
References: <485A259B.9040106@blueyonder.co.uk>
	<18522.18111.182249.694308@notabene.brown>
	<485ADC8D.2010708@blueyonder.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Jon Buckingham on Thursday June 19
Sender: linux-raid-owner@vger.kernel.org
To: jbuckingham@blueyonder.co.uk
Cc: linux-raid@vger.kernel.org, Jon Buckingham <jon.buckingham@hp.com>
List-Id: linux-raid.ids

On Thursday June 19, jbuckingham@blueyonder.co.uk wrote:
> Neil Brown wrote:
> > On Thursday June 19, jbuckingham@blueyonder.co.uk wrote:
> >> I have also done
> >> mdadm /dev/md0 -a /dev/sdb5
> >> and this results in a recovery...
> >>
> >> nas:~ # cat /proc/mdstat
> >> Personalities : [raid6] [raid5] [raid4]
> >> md0 : active raid5 sdb5[4] sda5[0] sdd5[3] sdc5[2]
> >>        733142016 blocks level 5, 64k chunk, algorithm 2 [4/3] [U_UU]
> >>        [=>...................]  recovery =  7.3% (17900780/244380672) finish=174.1min speed=21666K/sec
> >>
> >> unused devices: <none>
> >>
> >> Which I've been through before, but still ends up as a spare.
> > 
> > That suggests that it hits some IO error during recovery and aborts.
> > 
> > Are there any kernel log messages during the time that it is
> > recovering?
> > 
> > NeilBrown
> > 
> > 
> No.
> After the "add" completed, and a reboot it seems it is still a
> "spare".
> Strange.

What would be interesting to see is the --examine output and the dmesg
just as the recovery after the add has completed.  i.e. just before
the reboot.

The dmesg you have included is after the reboot.  It confirms that
sdb5 is non-refresh, presumably the event count is behind for some
reason (as can be seen from the --examine output you send in the first
email).  However it doesn't contain any hint as to why.

NeilBrown


> 
> Then from dmesg:
> 
> device-mapper: ioctl: 4.11.0-ioctl (2006-10-12) initialised: dm-devel@redhat.com
> md: md0 stopped.
> md: bind<sdc5>
> md: bind<sdd5>
> md: bind<sdb5>
> md: bind<sda5>
> md: kicking non-fresh sdb5 from array!
> md: unbind<sdb5>
> md: export_rdev(sdb5)
> raid5: automatically using best checksumming function: pIII_sse
>     pIII_sse  :  5640.000 MB/sec
> raid5: using function: pIII_sse (5640.000 MB/sec)
> 
> raid5: device sda5 operational as raid disk 0
> raid5: device sdd5 operational as raid disk 3
> raid5: device sdc5 operational as raid disk 2
> raid5: allocated 4204kB for md0
> raid5: raid level 5 set md0 active with 3 out of 4 devices, algorithm 2
> RAID5 conf printout:
>   --- rd:4 wd:3
>   disk 0, o:1, dev:sda5
>   disk 2, o:1, dev:sdc5
>   disk 3, o:1, dev:sdd5
> 
> I am tempted to rebuild the whole thing now, since I have tried
> quite a few variations and not solved it. There must be some deeper rooted problem that
> is causing this issue on the disk.
> 
> Thanks again,
> 
> Jon B
