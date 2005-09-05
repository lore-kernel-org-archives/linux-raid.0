From: Molle Bestefich <molle.bestefich@gmail.com>
Subject: Re: MD or MDADM bug?
Date: Mon, 5 Sep 2005 18:45:30 +0200
Message-ID: <62b0912f05090509457a790e22@mail.gmail.com>
References: <015901c5af3b$e0885710$c100a8c0@NCNF5131FTH>
	 <17176.9057.119383.787644@cse.unsw.edu.au>
	 <01ac01c5afa6$3d4d8690$c100a8c0@NCNF5131FTH>
	 <17176.13548.477061.774536@cse.unsw.edu.au>
	 <001c01c5b004$64c902e0$c700a8c0@NCNF5131FTH>
	 <17176.51414.689631.346198@cse.unsw.edu.au>
	 <003501c5b016$cc5d68d0$c700a8c0@NCNF5131FTH>
	 <17177.7688.922030.788691@cse.unsw.edu.au> <43195D20.1070103@dtbb.net>
	 <17178.37305.857263.952767@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17178.37305.857263.952767@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> No.
> I've never liked kernel autodetect, and while I won't break it, I
> would like to migrate people away from it.
[snippet]
> I hope you find that acceptable.

I won't go as far as to insinuate that I know what is acceptable and
what is not.
But I definitely like autodetection a lot.

I'm having troubling seeing why you'd like every MD user out there to
start fiddling with mdadm commands in their initrd when it can all be
done automatically behind the scenes.
I'm a big fan of letting computers do manual labour (especially MY
manual labour), and preferably doing it intelligently.

I hope you have the time to enlighten me! :-).

> What will, very likely, be implemented is something in 'mdadm' which
> automatically detects and assembles md arrays.

If that implies that all that distros have to do is put 'mdadm
--auto-assemble' into initrd, and it will do the same as kernel
autodetection does, I for one would be happy happy.

> You run
>   mdadm -As --config=partitions --hostid=notabene
> 
> then it scans all partitions for md arrays, looks at those with
> 'notabene' as the hostname in the 'name' field, and assembles them,

So if you change your hostname, you have to modify your initrd?
I fail to see what the added complexity might bring of good things to the table.

> Such a command would reliably assemble all arrays with any need for a
> config file, and without any risk of getting confused if arrays are
> imported from another machine (which is one of my issues with
> autodetect).

Who's confused?
MD or the user?

If the user is confused with the messages stating that h(is/er) array
cannot be assembled, the easy solution would be to stop swapping RAID
disks between boxes :-).

If MD is confused, then fix MD?
Could you elaborate?  (I do apologize if I'm the only one who's not
getting it..)

I heed the trouble if you take a 4-disk RAID6 and put two disks in one
box and 2 in another and start working on them, and thereafter put
them back together again.  If there's only a sequential counter to
tell which disks are fresh and which has to be rebuilt, the counters
could end up the same and cause MD to barf.  If that's the problem,
how about stuffing a 32-bit random number down there each time the
sequential counter is written, thus if the counters match but the
random number doesn't, the disks are from different machines and MD
should do a complete rebuild from whichever pair it chooses (or
perhaps better yet deny assembling them and let the user choose.  Or
whatever.).

(The counter could also be completely replaced by a random number, but
then you wouldn't know which disks is newer..)


> Then putting such a command in an appropriate 'rc' script, in an
> initrd image would make everything 'just work', just like in-kernel
> auto-detect, only better.

What's better about having to type more commands to get things done?
Still confused..


> The reason why it is 'probably different from' is that there are uses
> like stacking of devices (raid0 on raid1) and creation of partitions
> that need to be properly understood first.

The current implementation in MD needs a brush up in those areas too,
doesn't it?
Would something like

[pseudo]

// nFATLOAT: newlyFoundArraysThatLookOkAndThusShouldBeAssembled
MdDevice[] nFATLOAT = null;
do {
    if (nFATLOAT != null) assembleArrays(nFATLOAT);
    nFATLOAT = findUnassembledButOkArrays();
} while (nFATLOAT.length > 0);

[/pseudo]

work?

I'm curious about what the current status of layered MD device detection is!
