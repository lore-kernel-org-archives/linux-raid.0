From: Stef Telford <stef@chronozon.artofdns.com>
Subject: Re: mdadm and raid5 hot-rebuild problem on 2.5.67
Date: 16 Apr 2003 21:51:38 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1050544298.13739.9.camel@testlin.hades>
References: <1050536716.13739.6.camel@testlin.hades>
	 <16028.46697.488363.56989@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16028.46697.488363.56989@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2003-04-15 at 21:48, Neil Brown wrote:
> On  April 16, stef@chronozon.artofdns.com wrote:
> > 
> > [root@survivor root]# mdadm --manage /dev/md0 -a
> > /dev/ide/host4/bus0/target0/lun0/part2
> > mdadm: add new device failed for /dev/ide/host4/bus0/target0/lun0/part2:
> > Device or resource busy
> 
> Do you get any kernel messages at the same time as this error?
> 

hello again neil, sorry to be yet more of a 'pain' ;)

this time my problem -doesnt- have any 'oops' or kernel fault.
that being said, please find attached the output from when
raidstart is re-run (after a raidstop of course ;)


md: md0 stopped.
md: unbind<ide/host4/bus1/target0/lun0/part1>
md: export_rdev(ide/host4/bus1/target0/lun0/part1)
md: unbind<ide/host2/bus1/target0/lun0/part1>
md: export_rdev(ide/host2/bus1/target0/lun0/part1)
md: unbind<ide/host2/bus0/target0/lun0/part6>
md: export_rdev(ide/host2/bus0/target0/lun0/part6)
md: autorun ...
md: considering ide/host4/bus1/target0/lun0/part1 ...
md:  adding ide/host4/bus1/target0/lun0/part1 ...
md:  adding ide/host2/bus1/target0/lun0/part1 ...
md:  adding ide/host2/bus0/target0/lun0/part6 ...
md: created md0
md: bind<ide/host2/bus0/target0/lun0/part6>
md: bind<ide/host2/bus1/target0/lun0/part1>
md: bind<ide/host4/bus1/target0/lun0/part1>
md: running:
<ide/host4/bus1/target0/lun0/part1><ide/host2/bus1/target0/lun0/part1><ide/host2/bus0/target0/lun0/part6>
md: md0: raid array is not clean -- starting background reconstruction
md0: max total readahead window set to 768k
md0: 3 data-disks, max readahead per data-disk: 256k
md0: setting max_sectors to 128, segment boundary to 32767
raid5: device ide/host4/bus1/target0/lun0/part1 operational as raid disk
3
raid5: device ide/host2/bus1/target0/lun0/part1 operational as raid disk
1
raid5: device ide/host2/bus0/target0/lun0/part6 operational as raid disk
0
raid5: cannot start dirty degraded array for md0
RAID5 conf printout:
 --- rd:4 wd:3 fd:1
 disk 0, o:1, dev:ide/host2/bus0/target0/lun0/part6
 disk 1, o:1, dev:ide/host2/bus1/target0/lun0/part1
 disk 3, o:1, dev:ide/host4/bus1/target0/lun0/part1
raid5: failed to run raid set md0
md: pers->run() failed ...
md :do_md_run() returned -22
md: md0 still in use.
md: ... autorun DONE.



is there anything else you need or would like ?

regards 
Stef Telford <stef@chronozon.artofdns.com>

