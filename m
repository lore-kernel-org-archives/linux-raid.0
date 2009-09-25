From: "Sunpyo Hong" <sunpyo.hong@amac.com>
Subject: RE: Raid 5 Issue, cannot recognize EXT3 File system.
Date: Fri, 25 Sep 2009 12:35:27 -0400
Message-ID: <200909251235135.SM04440@trainer>
References: <70ed7c3e0909221714n1ad1ef80oedf329f17f7dad1c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909221714n1ad1ef80oedf329f17f7dad1c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "'Majed B.'" <majedb@gmail.com>
Cc: 'Robin Hill' <robin@robinhill.me.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Needed some help with confirming something before I tried it. After
analyzing my /dev/md2 with Testdisk, I was able to see parts of the old
filesystem on my NAS! Very exciting seeing as I wasn't able to see anything
for the past month or so. However I don't see any of the important files in
any of the directory. It also seems to skip from 00% to 99% in seconds. This
can't be possible since my HD size is 5.5TBs. When trying "Deeper Search" an
error occurs and my raid fails. However when I recreate the raid, it's in a
clean-degraded condition. (Which it originally was since one of the disks is
missing.) I also get this saying:

"Partition sector doesn't have the endmark 0xAA55"

After reading around I heard that you're able to write a standard MBR and
that would fix this problem. Only thing is I'm worried that by writing a
standard MBR I would be deleting data.

Another error I get when running testdisk is I get a warning about the
geometry:

"Warning: the current number of heads per cylinder is 2 but the correct
value may be 32.
You can use the Geometry menu to change this value. It's something to try if
-Some partition are not found by testdisk"

I heard changing your geometry is something that can potentially make your
HDD unreadable, so I'm saving that for last. But any more clarifications on
this error or anything else would be appreciated. I think I'm close, but
this has been a long and arduous journey... Thanks.

-Sunpyo


-----Original Message-----
From: Majed B. [mailto:majedb@gmail.com] 
Sent: Tuesday, September 22, 2009 8:14 PM
To: Sunpyo Hong
Cc: Robin Hill; linux-raid@vger.kernel.org
Subject: Re: Raid 5 Issue, cannot recognize EXT3 File system.

If you are sure that you have created the array with the proper order
of disks (They MUST be in the correct order! Your disks may have
changed their names for some reason -- verify that they are in
order!!) and that you have assembled them properly, I would suggest
you run a tool called "testdisk"

You may have a corrupt filesystem, and testdisk would try to fix it.
Also, to make sure that you have assembled the array in the correct
order, and if the filesystem can't be fixed if it's corrupt, use a
file-recovery tool like foremost or magicrescue and see if they
recover your data.

