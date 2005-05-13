From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bug report: mdadm -E oddity
Date: Fri, 13 May 2005 13:11:07 -0400
Message-ID: <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2005-05-13 at 11:44 -0400, Doug Ledford wrote:
> If you create stacked md devices, ala:
> 
> [root@pe-fc4 devel]# cat /proc/mdstat
> Personalities : [raid0] [raid5] [multipath]
> md_d0 : active raid5 md3[3] md2[2] md1[1] md0[0]
>       53327232 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> 
> md3 : active multipath sdm1[1] sdi1[0]
>       17775808 blocks [2/2] [UU]
> 
> md2 : active multipath sdl1[1] sdh1[0]
>       17775808 blocks [2/2] [UU]
> 
> md1 : active multipath sdk1[1] sdg1[0]
>       17775808 blocks [2/2] [UU]
> 
> md0 : active multipath sdj1[0] sdf1[1]
>       17775808 blocks [2/2] [UU]
> 
> unused devices: <none>
> [root@pe-fc4 devel]#
> 
> and then run mdadm -E --scan, then you get this (obviously wrong)
> output:
> 
> [root@pe-fc4 devel]# /sbin/mdadm -E --scan
> ARRAY /dev/md0 level=multipath num-devices=2
> UUID=34f4efec:bafe48ef:f1bb5b94:f5aace52
>    devices=/dev/sdj1,/dev/sdf1
> ARRAY /dev/md1 level=multipath num-devices=2
> UUID=bbaaf9fd:a1f118a9:bcaa287b:e7ac8c0f
>    devices=/dev/sdk1,/dev/sdg1
> ARRAY /dev/md2 level=multipath num-devices=2
> UUID=a719f449:1c63e488:b9344127:98a9bcad
>    devices=/dev/sdl1,/dev/sdh1
> ARRAY /dev/md3 level=multipath num-devices=2
> UUID=37b23a92:f25ffdc2:153713f7:8e5d5e3b
>    devices=/dev/sdm1,/dev/sdi1
> ARRAY /dev/md0 level=raid5 num-devices=4
> UUID=910b1fc9:d545bfd6:e4227893:75d72fd8
> 
> devices=/dev/md3,/dev/md2,/dev/md1,/dev/md0,/dev/md3,/dev/md2,/dev/md1,/dev/md0
> [root@pe-fc4 devel]#
> 
> This is with mdadm-1.11.0.

OK, this appears to extend to mdadm -Ss and mdadm -A --scan as well.
Basically, mdadm does not properly handle mixed md and mdp type devices
well, especially in a stacked configuration.  I got it to work
reasonably well using this config file:

DEVICE partitions /dev/md[0-3]
MAILADDR root
ARRAY /dev/md0 level=multipath num-devices=2
UUID=34f4efec:bafe48ef:f1bb5b94:f5aace52 auto=md
ARRAY /dev/md1 level=multipath num-devices=2
UUID=bbaaf9fd:a1f118a9:bcaa287b:e7ac8c0f auto=md
ARRAY /dev/md2 level=multipath num-devices=2
UUID=a719f449:1c63e488:b9344127:98a9bcad auto=md
ARRAY /dev/md3 level=multipath num-devices=2
UUID=37b23a92:f25ffdc2:153713f7:8e5d5e3b auto=md
ARRAY /dev/md_d0 level=raid5 num-devices=4
UUID=910b1fc9:d545bfd6:e4227893:75d72fd8 auto=part

This generates a number of warnings during both assembly and stop, but
works.

One more thing, since the UUID is a good identifier, it would be nice to
have mdadm -E --scan not print a devices= part.  Device names can
change, and picking up your devices via UUID regardless of that change
is preferable, IMO, to having it fail.
-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


