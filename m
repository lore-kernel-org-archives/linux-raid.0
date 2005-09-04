From: Neil Brown <neilb@suse.de>
Subject: Re: MD or MDADM bug?
Date: Sun, 4 Sep 2005 16:18:33 +1000
Message-ID: <17178.37305.857263.952767@cse.unsw.edu.au>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
	<17176.2600.694418.472339@cse.unsw.edu.au>
	<018f01c5af99$0343f6d0$c100a8c0@NCNF5131FTH>
	<17176.4401.418417.56385@cse.unsw.edu.au>
	<019601c5af9b$23d8ce50$c100a8c0@NCNF5131FTH>
	<17176.7326.892297.381537@cse.unsw.edu.au>
	<01a101c5afa2$8b3f2060$c100a8c0@NCNF5131FTH>
	<17176.9057.119383.787644@cse.unsw.edu.au>
	<01ac01c5afa6$3d4d8690$c100a8c0@NCNF5131FTH>
	<17176.13548.477061.774536@cse.unsw.edu.au>
	<001c01c5b004$64c902e0$c700a8c0@NCNF5131FTH>
	<17176.51414.689631.346198@cse.unsw.edu.au>
	<003501c5b016$cc5d68d0$c700a8c0@NCNF5131FTH>
	<17177.7688.922030.788691@cse.unsw.edu.au>
	<43195D20.1070103@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tyler on Saturday September 3
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: "David M. Strang" <dstrang@shellpower.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday September 3, pml@dtbb.net wrote:
> >Type FD doesn't work with version-1 superblocks.  The kernel will not
> >auto-assemble them at all.  Just use mdadm to assemble them (in an
> >rc.d script).
> >
> >NeilBrown
> >
> Neil, is this something that will be changed in the future, where FD 
> partition types will work with version 1 superblocks again at some point?
> 
> Tyler.

No.
I've never liked kernel autodetect, and while I won't break it, I
would like to migrate people away from it.

What will, very likely, be implemented is something in 'mdadm' which
automatically detects and assembles md arrays.

The version-1 superblocks contains a 32byte 'name' field.
I imagine something like (but probably different from) putting
   host:array
in here, e.g.
   vger:mirror
   notabene:md2
   shellpower:scratch

You run
  mdadm -As --config=partitions --hostid=notabene

then it scans all partitions for md arrays, looks at those with
'notabene' as the hostname in the 'name' field, and assembles them,
creating /dev/$array (e.g. /dev/mirror, /dev/md2, /dev/scratch).
If the name looks like mdX, then the obvious minor is chosen.
If something else, then some unused minor is chosen.

Such a command would reliably assemble all arrays with any need for a
config file, and without any risk of getting confused if arrays are
imported from another machine (which is one of my issues with
autodetect).

Then putting such a command in an appropriate 'rc' script, in an
initrd image would make everything 'just work', just like in-kernel
auto-detect, only better.

The reason why it is 'probably different from' is that there are uses
like stacking of devices (raid0 on raid1) and creation of partitions
that need to be properly understood first.

I hope you find that acceptable.

NeilBrown
