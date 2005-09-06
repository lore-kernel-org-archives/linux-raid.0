From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: MD or MDADM bug?
Date: Tue, 6 Sep 2005 11:38:21 +1000
Message-ID: <17180.62221.163087.348031@cse.unsw.edu.au>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
	<17176.9057.119383.787644@cse.unsw.edu.au>
	<01ac01c5afa6$3d4d8690$c100a8c0@NCNF5131FTH>
	<17176.13548.477061.774536@cse.unsw.edu.au>
	<001c01c5b004$64c902e0$c700a8c0@NCNF5131FTH>
	<17176.51414.689631.346198@cse.unsw.edu.au>
	<003501c5b016$cc5d68d0$c700a8c0@NCNF5131FTH>
	<17177.7688.922030.788691@cse.unsw.edu.au>
	<43195D20.1070103@dtbb.net>
	<17178.37305.857263.952767@cse.unsw.edu.au>
	<62b0912f05090509457a790e22@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Molle Bestefich on Monday September 5
Sender: linux-raid-owner@vger.kernel.org
To: Molle Bestefich <molle.bestefich@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday September 5, molle.bestefich@gmail.com wrote:
> Neil Brown wrote:
> > No.
> > I've never liked kernel autodetect, and while I won't break it, I
> > would like to migrate people away from it.
> [snippet]
> > I hope you find that acceptable.
> 
> I won't go as far as to insinuate that I know what is acceptable and
> what is not.
> But I definitely like autodetection a lot.

Have you head the lines by Henry Wadsworth Longfellow:	 
   There was a little girl
   Who had a little curl
   Right in the middle of her forehead;
   And when she was good
   She was very, very good,
   But when she was bad she was horrid.

That's how I feel about in-kernel-autodetection.  When it works, it's
fine.  When it doesn't, you lose.  Probably it hasn't happened to you.
The problem occurs if you move drives from one machine to another.  It
might transparently assemble the wrong array.

That's why I want to included the hostname in the info in the
superblock.  But you cannot be sure that the hostname will be
available in the kernel at any given time.  So the decision on exactly
how to assemble the array's has to be left to the system-integrator.
Just as the decision about which filesystem is the root filesystem.

> 
> I'm having troubling seeing why you'd like every MD user out there to
> start fiddling with mdadm commands in their initrd when it can all be
> done automatically behind the scenes.
> I'm a big fan of letting computers do manual labour (especially MY
> manual labour), and preferably doing it intelligently.
> 
> I hope you have the time to enlighten me! :-).
> 

It cannot be done with 100% reliability behind the scenes.  People
have reported problems with autodetect when moving drives from one
machine to another.


> > What will, very likely, be implemented is something in 'mdadm' which
> > automatically detects and assembles md arrays.
> 
> If that implies that all that distros have to do is put 'mdadm
> --auto-assemble' into initrd, and it will do the same as kernel
> autodetection does, I for one would be happy happy.
> 

That's generally the goal, yes.

> > You run
> >   mdadm -As --config=partitions --hostid=notabene
> > 
> > then it scans all partitions for md arrays, looks at those with
> > 'notabene' as the hostname in the 'name' field, and assembles them,
> 
> So if you change your hostname, you have to modify your initrd?

No.  hostid can be a kernel parameter.  Or it can be extracted from
the hardware somehow (MAC address).


> I fail to see what the added complexity might bring of good things to the table.
> 
> > Such a command would reliably assemble all arrays with any need for a
> > config file, and without any risk of getting confused if arrays are
> > imported from another machine (which is one of my issues with
> > autodetect).
> 
> Who's confused?
> MD or the user?

First MD - which of these two arrays should I assemble as md0?
and then the user - why didn't it assemble the right array just
   because I plugged a couple of extra drives in?

> 
> If the user is confused with the messages stating that h(is/er) array
> cannot be assembled, the easy solution would be to stop swapping RAID
> disks between boxes :-).

I have two boxed with raid arrays.  One dies.  I plug the drives
into the other and reboot it.  It comes up with some bits from one
machines and some bits from the other.

 
> If MD is confused, then fix MD?

I'm working on it, but removing providing a reliable alternative to
in-kernel autodetection.

> The current implementation in MD needs a brush up in those areas too,
> doesn't it?
> Would something like
> 
> [pseudo]
> 
> // nFATLOAT: newlyFoundArraysThatLookOkAndThusShouldBeAssembled
> MdDevice[] nFATLOAT = null;
> do {
>     if (nFATLOAT != null) assembleArrays(nFATLOAT);
>     nFATLOAT = findUnassembledButOkArrays();
> } while (nFATLOAT.length > 0);
> 
> [/pseudo]
> 
> work?
> 

Should a raid5 be assembled when you have found n-1 devices, or do you
wait for all n?  If you assemble as soon as you find n-1, what do you
do when the n'th  turns up?

I've had thoughts about allowing read-only assembly to which drives
can be added if they are found, but nothing concrete yet.

> I'm curious about what the current status of layered MD device detection is!

You put the entries in mdadm.conf in the right order and it should
work.

Why is it that people never complain about having to put information
in /etc/fstab about what to mount, but they cannot cope with having to
put similar information in /etc/mdadm.conf about what to assemble??

NeilBrown
