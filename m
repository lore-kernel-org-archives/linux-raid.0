From: NeilBrown <neilb@suse.de>
Subject: Re: Raid5 to another raid level??
Date: Fri, 2 Sep 2011 12:19:59 +1000
Message-ID: <20110902121959.173a1aa9@notabene.brown>
References: <-7094796685559591664@unknownmsgid>
	<CAFsPQ_97jNixHoYbMfxg9=FqXPWrsz_F1ZPSu1LTdGJA7N7Zcg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAFsPQ_97jNixHoYbMfxg9=FqXPWrsz_F1ZPSu1LTdGJA7N7Zcg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Busby <michael.a.busby@gmail.com>
Cc: john.robinson@anonymous.org.uk, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 2 Sep 2011 01:54:49 +0100 Michael Busby <michael.a.busby@gmail.com>
wrote:

> As could not sleep, have just tested and works fine...here is what i have done
> 
> sdd and sde are the 2 new disks
> 
> mdadm -C /dev/md1 -l4 -n3 -e 1.0 /dev/sdd /dev/sde missing
> 
> not sure if worth now using 1.2 as this seems the default setting if
> not specified??
> 
> sdb and sdc are the old raid 5 disks
> 
> echo frozen > /sys/block/md0/md/sync_action
> mdadm /dev/md0 --add /dev/sdb
> mdadm --grow --force /dev/md0 --raid-disks=4
> 
> echo frozen > /sys/block/md0/md/sync_action
> mdadm /dev/md0 --add /dev/sdc
> mdadm --grow --force /dev/md0 --raid-disks=5

You can do all this in one step - 3 to 5.

> echo frozen > /sys/block/md0/md/sync_action
> mdadm /dev/md0 --add /dev/sdb
> mdadm /dev/md0 --add /dev/sdc
> mdadm --grow --force /dev/md0 --raid-disks=5

NeilBrown



> 
> echo raid0 > /sys/block/md0/md/level
> 
> then resize the fs...job done :)
> 
> 
> 
> On 2 September 2011 00:50, Michael Busby <michael.a.busby@gmail.com> wrote:
> > Will test tomorrow once back in the office, hope the 4tb sync will be
> > finished by then
> >
> > I will report back my findings
> >
> >
> >
> > -- Sent from my HP TouchPadOn 1 Sep 2011 11:34 PM,
> > <john.robinson@anonymous.org.uk> wrote:
> > On 01/09/2011 22:50, Michael Busby wrote:
> >> I have found the following and see that you can convert from raid4 to
> >> raid0 fairly easy
> >>
> >>
> >> http://ubuntuforums.org/showpost.php?p=10412231&postcount=20
> >>
> >> i have a 2 disk raid5 and want to be able to convert this to raid0, i
> >> was thinking of adding a extra 2 disk and setting them up as raid0,
> >> moving the data over then adding the original raid5 disks to the raid0
> >> setup, but i see that you are unable to add disk to a raid0 setup,
> >> would it be possible to setup a raid4 with 2 disks and 1 missing, move
> >> the data from the raid5 to raid4 then add both of the original disks
> >> to the raid4 the downgrade this to raid0???
> >
> > Off the top of my head, feeling slightly sozzled (been for a few beers),
> > this might work, but as your linked post referring to a list reply from
> > Neil Brown says, you should test first. You could use some USB sticks,
> > or alternatively loopback devices are ideal for this kind of test.
> >
> > Cheers,
> >
> > John.
> >
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

