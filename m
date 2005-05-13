From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: Bug report: mdadm -E oddity
Date: Sat, 14 May 2005 09:01:57 +1000
Message-ID: <17029.12773.197506.463977@cse.unsw.edu.au>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>
	<1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Friday May 13
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday May 13, dledford@redhat.com wrote:
> On Fri, 2005-05-13 at 11:44 -0400, Doug Ledford wrote:
> > If you create stacked md devices, ala:
> > 
> > [root@pe-fc4 devel]# cat /proc/mdstat
> > Personalities : [raid0] [raid5] [multipath]
> > md_d0 : active raid5 md3[3] md2[2] md1[1] md0[0]
> >       53327232 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
...
> > 
> > and then run mdadm -E --scan, then you get this (obviously wrong)
> > output:
> > 
> > [root@pe-fc4 devel]# /sbin/mdadm -E --scan
..
> > ARRAY /dev/md0 level=raid5 num-devices=4
> > UUID=910b1fc9:d545bfd6:e4227893:75d72fd8

Yes, I expect you would.  -E just looks as the superblocks, and the
superblock doesn't record whether the array is meant to be partitioned
or not.  With version-1 superblocks they don't even record the
sequence number of the array they are part of.  In that case, "-Es"
will report 
  ARRAY /dev/?? level=.....

Possibly I could utilise one of the high bits in the on-disc minor
number to record whether partitioning was used...

> OK, this appears to extend to mdadm -Ss and mdadm -A --scan as well.
> Basically, mdadm does not properly handle mixed md and mdp type devices
> well, especially in a stacked configuration.  I got it to work
> reasonably well using this config file:
> 
> DEVICE partitions /dev/md[0-3]
> MAILADDR root
> ARRAY /dev/md0 level=multipath num-devices=2
> UUID=34f4efec:bafe48ef:f1bb5b94:f5aace52 auto=md
> ARRAY /dev/md1 level=multipath num-devices=2
> UUID=bbaaf9fd:a1f118a9:bcaa287b:e7ac8c0f auto=md
> ARRAY /dev/md2 level=multipath num-devices=2
> UUID=a719f449:1c63e488:b9344127:98a9bcad auto=md
> ARRAY /dev/md3 level=multipath num-devices=2
> UUID=37b23a92:f25ffdc2:153713f7:8e5d5e3b auto=md
> ARRAY /dev/md_d0 level=raid5 num-devices=4
> UUID=910b1fc9:d545bfd6:e4227893:75d72fd8 auto=part
> 
> This generates a number of warnings during both assembly and stop, but
> works.

What warnings are they?  I would expect this configuration to work
smoothly.

> 
> One more thing, since the UUID is a good identifier, it would be nice to
> have mdadm -E --scan not print a devices= part.  Device names can
> change, and picking up your devices via UUID regardless of that change
> is preferable, IMO, to having it fail.

The output of "-E --scan" was never intended to be used unchanged in
mdadm.conf.
It simply provides all available information in a brief format that is
reasonably compatible with mdadm.conf.  As is says in the Examples
section of mdadm.8

         echo 'DEVICE /dev/hd*[0-9] /dev/sd*[0-9]' > mdadm.conf
         mdadm --detail --scan >> mdadm.conf
       This  will  create  a  prototype  config  file that describes currently
       active arrays that are known to be made from partitions of IDE or  SCSI
       drives.   This file should be reviewed before being used as it may con-
       tain unwanted detail.

However I note that the doco for --examine says

              If --brief is given, or --scan then multiple  devices  that  are
              components of the one array are grouped together and reported in
              a single entry suitable for inclusion in  /etc/mdadm.conf.

which seems to make it alright to use it directly in mdadm.conf.

Maybe the -brief version should just give minimal detail (uuid), and
 --verbose be required for the device names.


So there are little things that could be done to smooth some of this
over, but the core problem seems to be that you want to use the output
of "--examine --scan" unchanged in mdadm.conf, and that simply cannot
work.

NeilBrown
