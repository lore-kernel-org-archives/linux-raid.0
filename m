From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: mdadm and raid5 hot-rebuild problem on 2.5.67
Date: Wed, 16 Apr 2003 11:57:30 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16028.47242.348607.436021@notabene.cse.unsw.edu.au>
References: <1050536716.13739.6.camel@testlin.hades>
	<16028.46697.488363.56989@notabene.cse.unsw.edu.au>
	<1050544298.13739.9.camel@testlin.hades>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stef Telford on  April 16
To: Stef Telford <stef@chronozon.artofdns.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On  April 16, stef@chronozon.artofdns.com wrote:
> On Tue, 2003-04-15 at 21:48, Neil Brown wrote:
> > On  April 16, stef@chronozon.artofdns.com wrote:
> > > 
> > > [root@survivor root]# mdadm --manage /dev/md0 -a
> > > /dev/ide/host4/bus0/target0/lun0/part2
> > > mdadm: add new device failed for /dev/ide/host4/bus0/target0/lun0/part2:
> > > Device or resource busy
> > 
> > Do you get any kernel messages at the same time as this error?
> > 
> 
> hello again neil, sorry to be yet more of a 'pain' ;)
> 
> this time my problem -doesnt- have any 'oops' or kernel fault.
> that being said, please find attached the output from when
> raidstart is re-run (after a raidstop of course ;)

raidstart!  Horrible tool.  Throw it away.

...
> md: running:
> <ide/host4/bus1/target0/lun0/part1><ide/host2/bus1/target0/lun0/part1><ide/host2/bus0/target0/lun0/part6>
> md: md0: raid array is not clean -- starting background reconstruction
> md0: max total readahead window set to 768k
> md0: 3 data-disks, max readahead per data-disk: 256k
> md0: setting max_sectors to 128, segment boundary to 32767
> raid5: device ide/host4/bus1/target0/lun0/part1 operational as raid disk
> 3
> raid5: device ide/host2/bus1/target0/lun0/part1 operational as raid disk
> 1
> raid5: device ide/host2/bus0/target0/lun0/part6 operational as raid disk
> 0
> raid5: cannot start dirty degraded array for md0

You will need
   mdadm --assemble --force ....
to start this array as it seems to have suffered an unclean shutdown
while degraded.

> 
> 
> is there anything else you need or would like ?

Well, an answer to my original question would be nice:-)  You should
have kernel logs of the time when you got "device busy" from "mdadm -a". 

NeilBrown
