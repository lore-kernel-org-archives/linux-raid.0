From: Kresimir Kukulj <madmax@iskon.hr>
Subject: Re: problems with raid6, mdadm: RUN_ARRAY failed
Date: Mon, 5 Jun 2006 10:07:08 +0200
Message-ID: <20060605080708.GA20548@max.zg.iskon.hr>
References: <20060602212212.GA14530@max.zg.iskon.hr> <17539.27434.353344.175098@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <17539.27434.353344.175098@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Quoting Neil Brown (neilb@suse.de):
> On Friday June 2, madmax@iskon.hr wrote:
> > I have some old controler Mylex Acceleraid 170LP with 6 SCSI 36GB disks on
> > it. Running hardware raid5 resulted with very poor performance (7Mb/sec in
> > sequential writing, with horrid iowait).
> > 
> > So I configured it to export 6 logical disks and tried creating raid6 and see
> > if I can get better results. Trying to create an array with a missing component
> > results in:
> > 
> > ~/mdadm-2.5/mdadm -C /dev/md3 -l6 -n6 /dev/rd/c0d0p3  /dev/rd/c0d2p3 /dev/rd/c0d3p3 /dev/rd/c0d4p3 /dev/rd/c0d5p3 missing
> > mdadm: RUN_ARRAY failed: Input/output error
> 
> There should have been some messages in the kernel log when this
> happened.  Can you report them too?

Ok. 
I tried this again and:
~/mdadm-2.5/mdadm -v -C /dev/md3 -l6 -n6 /dev/rd/c0d0p3 /dev/rd/c0d2p3 /dev/rd/c0d3p3 /dev/rd/c0d4p3 /dev/rd/c0d5p3 missing
mdadm: layout defaults to left-symmetric
mdadm: chunk size defaults to 64K
mdadm: size set to 30595712K
mdadm: RUN_ARRAY failed: Input/output error

Jun  5 10:04:07 www1 kernel: md: bind<rd/c0d0p3>
Jun  5 10:04:07 www1 kernel: md: bind<rd/c0d2p3>
Jun  5 10:04:07 www1 kernel: md: bind<rd/c0d3p3>
Jun  5 10:04:07 www1 kernel: md: bind<rd/c0d4p3>
Jun  5 10:04:07 www1 kernel: md: bind<rd/c0d5p3>
Jun  5 10:04:07 www1 kernel: md: md3: raid array is not clean -- starting background reconstruction
Jun  5 10:04:07 www1 kernel: raid6: device rd/c0d5p3 operational as raid disk 4
Jun  5 10:04:07 www1 kernel: raid6: device rd/c0d4p3 operational as raid disk 3
Jun  5 10:04:07 www1 kernel: raid6: device rd/c0d3p3 operational as raid disk 2
Jun  5 10:04:07 www1 kernel: raid6: device rd/c0d2p3 operational as raid disk 1
Jun  5 10:04:07 www1 kernel: raid6: device rd/c0d0p3 operational as raid disk 0
Jun  5 10:04:07 www1 kernel: raid6: cannot start dirty degraded array for md3
Jun  5 10:04:07 www1 kernel: RAID6 conf printout:
Jun  5 10:04:07 www1 kernel:  --- rd:6 wd:5 fd:1
Jun  5 10:04:07 www1 kernel:  disk 0, o:1, dev:rd/c0d0p3
Jun  5 10:04:07 www1 kernel:  disk 1, o:1, dev:rd/c0d2p3
Jun  5 10:04:07 www1 kernel:  disk 2, o:1, dev:rd/c0d3p3
Jun  5 10:04:07 www1 kernel:  disk 3, o:1, dev:rd/c0d4p3
Jun  5 10:04:07 www1 kernel:  disk 4, o:1, dev:rd/c0d5p3
Jun  5 10:04:07 www1 kernel: raid6: failed to run raid set md3
Jun  5 10:04:07 www1 kernel: md: pers->run() failed ...
Jun  5 10:04:07 www1 kernel: md: md3 stopped.
Jun  5 10:04:07 www1 kernel: md: unbind<rd/c0d5p3>
Jun  5 10:04:07 www1 kernel: md: export_rdev(rd/c0d5p3)
Jun  5 10:04:07 www1 kernel: md: unbind<rd/c0d4p3>
Jun  5 10:04:07 www1 kernel: md: export_rdev(rd/c0d4p3)
Jun  5 10:04:07 www1 kernel: md: unbind<rd/c0d3p3>
Jun  5 10:04:07 www1 kernel: md: export_rdev(rd/c0d3p3)
Jun  5 10:04:07 www1 kernel: md: unbind<rd/c0d2p3>
Jun  5 10:04:07 www1 kernel: md: export_rdev(rd/c0d2p3)
Jun  5 10:04:07 www1 kernel: md: unbind<rd/c0d0p3>
Jun  5 10:04:07 www1 kernel: md: export_rdev(rd/c0d0p3)

I tried creating raid6 with 5 disks (no missing member) and md started
constructing array...

-- 
Kresimir Kukulj                      madmax@iskon.hr
+--------------------------------------------------+
Remember, if you break Debian, you get to keep both parts.
