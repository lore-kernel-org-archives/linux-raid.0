From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Tue, 19 Nov 2013 17:29:36 -0800
Message-ID: <CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
	<528BBFEB.7050202@arcor.de>
	<20131120105115.27494ab6@notabene.brown>
	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>
	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>
	<20131120114833.695fc9d4@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131120114833.695fc9d4@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Martin Wilck <mwilck@arcor.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Yes, it's in this thread already - but I'll repost here:

For cisco's server:

> mdadm --examine --scan
ARRAY metadata=ddf UUID=7ab254d0:fae71048:
404edde9:750a8a05
ARRAY container=7ab254d0:fae71048:404edde9:750a8a05 member=0
UUID=5337ab03:86ca2abc:d42bfbc8:23626c78

> mdadm --assemble --scan --no-degraded -v
mdadm: looking for devices for further assembly
mdadm: /dev/md/ddf0 is a container, but we are looking for components
mdadm: no RAID superblock on /dev/sdf
mdadm: no RAID superblock on /dev/md/MegaSR2
mdadm: no RAID superblock on /dev/md/MegaSR1
mdadm: no RAID superblock on /dev/md/MegaSR
mdadm: cannot open device /dev/sr0: No medium found
mdadm: /dev/sdd is busy - skipping
mdadm: /dev/sdc is busy - skipping
mdadm: /dev/sdb is busy - skipping
mdadm: /dev/sda is busy - skipping
mdadm: /dev/sde is busy - skipping
mdadm: looking for devices for further assembly
mdadm: looking in container /dev/md/ddf0
mdadm: member /md127/0 in /dev/md/ddf0 is already assembled
mdadm: Cannot assemble mbr metadata on /dev/sdf
mdadm: Cannot assemble mbr metadata on /dev/md/MegaSR2
mdadm: Cannot assemble mbr metadata on /dev/md/MegaSR1
mdadm: Cannot assemble mbr metadata on /dev/md/MegaSR
mdadm: cannot open device /dev/sr0: No medium found
mdadm: /dev/sdd has wrong uuid.
mdadm: /dev/sdc has wrong uuid.
mdadm: /dev/sdb has wrong uuid.
mdadm: /dev/sda has wrong uuid.
mdadm: /dev/sde has wrong uuid.




On Tue, Nov 19, 2013 at 4:48 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 19 Nov 2013 16:35:44 -0800 "David F." <df7729@gmail.com> wrote:
>>
>> Also, was Cisco's information useful for why their cisco server (using
>> lsi)  RAID5 won't assembly?  Do you think the patch deals with that as
>> well?
>>
>>
>
> You did say something about Cisco in the original post but it wasn't at all
> clear what you were asking or what the context was.
>
> Could you please spell it all out.  You said something about dmraid reporting
> something.  Showing the output of dmraid in that case wouldn't hurt.
> And show the output of "mdadm --examine /dev/device" for any relevant device
> is often a good idea.
>
> NeilBrown
