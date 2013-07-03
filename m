From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Mdadm server eating drives
Date: Wed, 03 Jul 2013 12:05:56 -0500
Message-ID: <51D459F4.7050309@hardwarefreak.com>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com> <51BA7B28.9030808@turmel.org> <CAPSPcXgMxOF-C2Szu_nf4ZLDC8p+yJFOtvLPu7xy1DTW9VAHjg@mail.gmail.com> <CAPSPcXh8C87whdXdzWgh97qiwLNZOjSB2OD_nxKCfmRL2GZ=Jg@mail.gmail.com> <CAPSPcXgVEEAB1UZ1R73zTRgC=VxQ8fhOwR+EJd_7bCW6D2h0fg@mail.gmail.com> <51BB8A67.5000605@turmel.org> <51BB8B86.9050803@turmel.org> <CAPSPcXi-SZjGusAtL4dj4cNNvovRcNR-uFAwAt7-9G8YRmGHkw@mail.gmail.com> <alpine.DEB.2.00.1306180609260.4696@uplift.swm.pp.se> <CAPSPcXiXo=pVfmp770==Vvj+yMU1sLMVxNf1dwCoh0At1zz3vQ@mail.gmail.com> <51CC72A4.4040508@jungers.net> <CAPSPcXhZosdmKiG-rhQXu+NcNJ2yLjfT1hAor1cCHWi1kM08aA@mail.gmail.com> <51D233A5.504@hardwarefreak.com> <CAPSPcXjOPben0xGqcUKwyZn4pX403uFbp5f57f=LEV371ZuDjw@mail.gmail.com> <51D32DBB.8030401@hardwarefr
 eak.com> <CAPSPcXg_fy-YYfwa1w4=3ZzA3sb71V+Kvai7qHAXNfiS3WAXGQ@mail.gmail.com> <51D38354.6090001@hardwarefreak.com> <CAPSPcXjn4=mxMLtu=88Fm9kFvh6_ujLwrTvQeqQuef3BG_c26Q@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXjn4=mxMLtu=88Fm9kFvh6_ujLwrTvQeqQuef3BG_c26Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Phil Turmel <philip@turmel.org>
List-Id: linux-raid.ids

On 7/3/2013 12:26 AM, Barrett Lewis wrote:
...
> This is all about my dedicated server.  The external enclosure with
> the 4 drives, 3 of which in a raid0 is just something I used for
> creating an emergency backup, and was plugged directly into the server
> via USB, (has it's own power supply too).  The server is using the
> onboard video card on the Asrock z77 extreme 4.

Got it.
...
> The other 2 drives in the picture are the source drives that had the
> original data that the array was initially populated with.

Got it.  These questions were simply to get a handle on how much +12V
power you needed before recommending a PSU.

...
> I have been really curious about this "beeping" issue since
> it is so bizarre.  Anyway like I said only 2 of those original 6 (they
> were seagate ST2000DM001) remain.

When power supplies go bad you may witness all kinds of weird things.
If the voltage to the speaker drive circuit fluctuates wildly it can
cause leakage on the output drive, which causes the speaker to make
random noises.

> Cheap alternate PSU seemed to work OK so I went to buy a decent
> permanent replacement.  I couldn't find either of the two you
> suggested at the store (they were closing and I wanted to get this
> done).  So I ended up going with a 750w corsair CX750M.  Like magic,
> with a new power supply most of the drives seem to be back working,
> except the first two that failed out yesterday.  It seems like maybe
> the event counters (or something) are too far behind to assemble them
> back.  That said, md0 mounts fine and fsck returned clean, so that
> deserves some kinda hooray!

The key thing is whether drives keep showing errors in dmesg and
dropping.  If not your problem is likely solved.  :)

> Here is some data about the two (sdd and sdf) that won't socialize
> with the other disks.
> 
> sudo mdadm --assemble --force --verbose /dev/md0 /dev/sd[a-f]
> mdadm: looking for devices for /dev/md0
> mdadm: /dev/sda is identified as a member of /dev/md0, slot 4.
> mdadm: /dev/sdb is identified as a member of /dev/md0, slot 0.
> mdadm: /dev/sdc is identified as a member of /dev/md0, slot 5.
> mdadm: /dev/sdd is identified as a member of /dev/md0, slot 1.
> mdadm: /dev/sde is identified as a member of /dev/md0, slot 3.
> mdadm: /dev/sdf is identified as a member of /dev/md0, slot 2.
> mdadm: added /dev/sdd to /dev/md0 as 1 (possibly out of date)
> mdadm: added /dev/sdf to /dev/md0 as 2 (possibly out of date)
> mdadm: added /dev/sde to /dev/md0 as 3
> mdadm: added /dev/sda to /dev/md0 as 4
> mdadm: added /dev/sdc to /dev/md0 as 5
> mdadm: added /dev/sdb to /dev/md0 as 0
> mdadm: /dev/md0 has been started with 4 drives (out of 6).
> 
> 
> and from dmesg
> [ 4481.356723] md: bind<sdd>
> [ 4481.356850] md: bind<sdf>
> [ 4481.357007] md: bind<sde>
> [ 4481.357134] md: bind<sda>
> [ 4481.357248] md: bind<sdc>
> [ 4481.357365] md: bind<sdb>
> [ 4481.357395] md: kicking non-fresh sdf from array!
> [ 4481.357400] md: unbind<sdf>
> [ 4481.374480] md: export_rdev(sdf)
> [ 4481.374484] md: kicking non-fresh sdd from array!
> [ 4481.374488] md: unbind<sdd>
> [ 4481.394486] md: export_rdev(sdd)
> [ 4481.396164] md/raid:md0: device sdb operational as raid disk 0
> [ 4481.396168] md/raid:md0: device sdc operational as raid disk 5
> [ 4481.396171] md/raid:md0: device sda operational as raid disk 4
> [ 4481.396173] md/raid:md0: device sde operational as raid disk 3
> [ 4481.396571] md/raid:md0: allocated 6384kB
> [ 4481.396805] md/raid:md0: raid level 6 active with 4 out of 6
> devices, algorithm 2
> [ 4481.396808] RAID conf printout:
> [ 4481.396810]  --- level:6 rd:6 wd:4
> [ 4481.396812]  disk 0, o:1, dev:sdb
> [ 4481.396814]  disk 3, o:1, dev:sde
> [ 4481.396815]  disk 4, o:1, dev:sda
> [ 4481.396817]  disk 5, o:1, dev:sdc
> [ 4481.396848] md0: detected capacity change from 0 to 8001056407552
> [ 4481.426011]  md0: unknown partition table
> 
> sudo mdadm -E /dev/sd[a-f] | nopaste
> http://pastie.org/8105693
> 
> sudo smartctl -x /dev/sdd | nopaste
> http://pastie.org/8105706
> 
> sudo smartctl -x /dev/sdf | nopaste
> http://pastie.org/8105707
> 
> 
> Are sdd and sdf just too out of sync?  Should I zero the superblocks
> and re-add them to the array?  Or I could replace them (I have two
> unopened WD reds here, but I'd like to return them if I don't really
> need them right now).

I'm not an expert on recovery when things go this far South.  Phil and
others are much more knowledgeable with this so I'll pass the thread
back to them now.

> Thanks for the advice about the PSU, I would have never dreamed it
> would cause behaviour like that.

You're welcome.  I've spent a just little time around hardware, as you
might have guessed based on my email address.  Started in 1986, so
that's, what, 26 years now?  Damn I'm getting old...

-- 
Stan

