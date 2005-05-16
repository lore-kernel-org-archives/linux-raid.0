From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bug report: mdadm -E oddity
Date: Mon, 16 May 2005 12:46:51 -0400
Message-ID: <1116262011.13780.79.camel@compaq-rhel4.xsintricity.com>
References: <1115999051.3974.14.camel@compaq-rhel4.xsintricity.com>
	 <1116004267.3974.35.camel@compaq-rhel4.xsintricity.com>
	 <17029.12773.197506.463977@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17029.12773.197506.463977@cse.unsw.edu.au>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, 2005-05-14 at 09:01 +1000, Neil Brown wrote:
> On Friday May 13, dledford@redhat.com wrote:
> > On Fri, 2005-05-13 at 11:44 -0400, Doug Ledford wrote:
> > > If you create stacked md devices, ala:
> > > 
> > > [root@pe-fc4 devel]# cat /proc/mdstat
> > > Personalities : [raid0] [raid5] [multipath]
> > > md_d0 : active raid5 md3[3] md2[2] md1[1] md0[0]
> > >       53327232 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]
> ...
> > > 
> > > and then run mdadm -E --scan, then you get this (obviously wrong)
> > > output:
> > > 
> > > [root@pe-fc4 devel]# /sbin/mdadm -E --scan
> ..
> > > ARRAY /dev/md0 level=raid5 num-devices=4
> > > UUID=910b1fc9:d545bfd6:e4227893:75d72fd8
> 
> Yes, I expect you would.  -E just looks as the superblocks, and the
> superblock doesn't record whether the array is meant to be partitioned
> or not.  With version-1 superblocks they don't even record the
> sequence number of the array they are part of.  In that case, "-Es"
> will report 
>   ARRAY /dev/?? level=.....
> 
> Possibly I could utilise one of the high bits in the on-disc minor
> number to record whether partitioning was used...

Does that mean with version 1 superblocks you *have* to have an ARRAY
line in order to get some specific UUID array started at the right minor
number?  If so, people will complain about that loudly.

> which seems to make it alright to use it directly in mdadm.conf.
> 
> Maybe the -brief version should just give minimal detail (uuid), and
>  --verbose be required for the device names.
> 
> 
> So there are little things that could be done to smooth some of this
> over, but the core problem seems to be that you want to use the output
> of "--examine --scan" unchanged in mdadm.conf, and that simply cannot
> work.

Well, also keep in mind that the documentation on mdadm touts the fact
that is meant to be run without a config file.  I'm perfectly happy to
do that, but -A mode combined with --scan mode only assembles and starts
arrays in the config file.  As I mentioned in a previous email, I guess
I could do something like mdadm -Es | mdadm -c - -As -device=partitions
but that just seems kinda silly given that all that is needed is for the
assemble mode to start all devices found and we already know how to find
them in the -E mode.  Maybe either changing -As mode to assemble
everything regardless of config file or adding another flag to assemble
mode to do the same.

-- 
Doug Ledford <dledford@redhat.com>
http://people.redhat.com/dledford


