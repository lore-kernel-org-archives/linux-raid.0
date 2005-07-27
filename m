From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: bug report: mdadm-devel-2 , superblock version 1
Date: Wed, 27 Jul 2005 12:08:51 +1000
Message-ID: <17126.60595.794344.181886@cse.unsw.edu.au>
References: <009401c58ae6$65b57870$c200a8c0@NCNF5131FTH>
	<17114.54800.132155.142544@cse.unsw.edu.au>
	<00e101c58b25$6f5c06c0$c200a8c0@NCNF5131FTH>
	<17114.62108.319878.983091@cse.unsw.edu.au>
	<010701c58b32$ee423830$c200a8c0@NCNF5131FTH>
	<17115.149.130115.176372@cse.unsw.edu.au>
	<001601c58b37$620c69d0$c200a8c0@NCNF5131FTH>
	<17115.1749.370942.838069@cse.unsw.edu.au>
	<42DB0F41.7030806@dtbb.net>
	<17124.13318.958372.399899@cse.unsw.edu.au>
	<42E460EA.3020707@dtbb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Tyler on Sunday July 24
Sender: linux-raid-owner@vger.kernel.org
To: Tyler <pml@dtbb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday July 24, pml@dtbb.net wrote:
> Neil Brown wrote:
> > On Sunday July 17, pml@dtbb.net wrote:
> > 
> >># uname -a
> >>Linux server 2.6.12.3 #3 SMP Sun Jul 17 14:38:12 CEST 2005 i686 GNU/Linux
> >># ./mdadm -V
> >>mdadm - v2.0-devel-2 - DEVELOPMENT VERSION NOT FOR REGULAR USE - 7 July 2005
> >>
> > ...
> > 
> >>root@server:~/dev/mdadm-2.0-devel-2# cat /proc/mdstat
> >>Personalities : [raid5]
> >>md1 : active raid5 sdc2[3] sdb2[1] sda2[0]
> >>      128384 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
> >>
> >>unused devices: <none>
> >>
> >>** mdstat mostly okay, except sdc2 is listed as device3 instead of 
> > 
> > Hmmm, yes....  It is device number 3 in the array, but it is playing
> > role-2 in the raid5.  When using Version-1 superblocks, we don't moved
> > devices around, in the "list of all devices".  We just assign them
> > different roles. (device-N or 'spare').
> > 
> 
> So if I were to add (as an example) 7 spares to a 3 disk raid-5 array, 
> and later removed them for use elsewhere, a raid using a v1.x superblock 
> would keep a permanent listing of those drives even after being
> removed? 

No.  A device retains it's slot number only while it is a member of
the array.  Once it is removed from the array it is forgotten.  If it
is re-added, it appears simply as a new drive and is allocated the
first free slot.


>    Is there a possibility (for either asthetics, or just keeping things 
> easier to read and possibly diagnose at a later date during manual 
> recoveries) of adding a command line option to "re-order and remove" old 
> devices that are marked as removed, that could only function if the 
> array was clean, and non-degraded?  (this would be a manual feature we 
> would run, especially if automatically doing this might actually confuse 
> us during times of trouble-shooting?)

I'd rather change the output of mdadm to display the important
information (role in array) more prominently that the less important
info (position in array).
> >>
> >>    Number   Major   Minor   RaidDevice State
> >>       0       8        2        0      active sync   /dev/.static/dev/sda2
> >>       1       8       18        1      active sync   /dev/.static/dev/sdb2
> >>       2       0        0        -      removed
> >>
> >>       3       8       34        2      active sync   /dev/.static/dev/sdc2
> >>
> >>** reports version 01.00.01 superblock, but reports as if there were 4 
> >>devices used
> > 
> > Ok, this output definitely needs fixing.  But as you can see, there
> > are 3 devices playing roles (RaidDevice) 0, 1, and 2.  They reside in
> > slots 0, 1, and 3 of the array.
> 
> Depending on your answer to the first question up above, a new question 
> based on your comment here comes to mind... if we assume, as you say 
> above that it is normal for v1 superblocks to keep old removed drives 
> listed, but down here you say the output needs fixing, which output is 
> wrong in the example showing 0,1,2,3 devices, with device #2 removed, 
> and device 3 acting as raiddevice 2 ?  If the v1 superblocks are 
> designed to keep removed drives listed, then the above output makes 
> sense.. now that you've pointed out the "feature".

It should look more like:

    Number   Major   Minor   RaidDevice State
       0       8        2        0      active sync   /dev/.static/dev/sda2
       1       8       18        1      active sync   /dev/.static/dev/sdb2
       3       8       34        2      active sync   /dev/.static/dev/sdc2

i.e. printing something that is 'removed' is pointless.  And the list
should be sorted by 'RaidDevice', not 'Number'.


> 
> >>root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1
> >>Segmentation fault
> >>
> >>** try to assemble the array
> > 
> > This is not how you assemble an array.  You need to tell mdadm which
> > component devices to use, either on command line or in /etc/mdadm.conf
> > (and give --scan).
> 
> I failed to mention that I had an up to date mdadm.conf file, with the 
> raid UUID in it, and (I will have to verify this) I believe the command 
> as I typed it above, works with the 1.12 mdadm.  The mdadm.conf file has 
> a DEVICE=/dev/hd[b-z] /dev/sd* line at the beginning of the config file, 
> and then the standard options (but no devices= line).  Does -A still 
> need *some* options even if the config file is up to date??  (as I said, 
> I'll have to verify if 1.12 works with just the -A).

mdadm won't look at the config file unless you tell it too (with
--scan or --configfile).  At least that is what I intended.



> 
> Also, if -A requires some other options on the command line, should it 
> not complain, instead of segfaulting? :D

Certainly!


> 
> >>root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -D /dev/md1
> >>mdadm: md device /dev/md1 does not appear to be active.
> >>
> >>** check if its active at all
> >>
> >>root@server:~/dev/mdadm-2.0-devel-2# ./mdadm -A /dev/md1 /dev/sda2 
> >>/dev/sdb2 /dev/sdc2
> >>mdadm: device 1 in /dev/md1 has wrong state in superblock, but /dev/sdb2 
> >>seems ok
> >>mdadm: device 2 in /dev/md1 has wrong state in superblock, but /dev/sdc2 
> >>seems ok
> >>mdadm: /dev/md1 has been started with 3 drives.
> >>
> >>** try restarting it with drive details, and it starts
> > 
> > Those message are a bother though.  I think I know roughly what is
> > going on.  I'll look into it shortly.
> 
> Is this possibly where the v1 superblocks are being mangled, and so it 
> reverts back to the v0.90 superblocks that it finds on the disk?

I'm not sure until I look carefully through the code.

NeilBrown
