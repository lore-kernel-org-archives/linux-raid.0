From: "Majed B." <majedb@gmail.com>
Subject: Re: Is My Data DESTROYED?!
Date: Fri, 23 Oct 2009 05:43:15 +0300
Message-ID: <70ed7c3e0910221943v50d62cecg2a8741a7928ec064@mail.gmail.com>
References: <70ed7c3e0910221912h70b33ca0m3df9eedd9a54c459@mail.gmail.com>
	<151153.66698.qm@web38804.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <151153.66698.qm@web38804.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I don't know exactly what went wrong with your setup, so I can't tell
why it's not mounting.

Did you check the output of dmesg | tail after a failed mount?

I'd suggest that you don't touch the disks, cables, nor the array.

Try running sudo fsck /dev/md0

On Fri, Oct 23, 2009 at 5:18 AM, adfas asd <chimera_god@yahoo.com> wrot=
e:
>
> I don't understand exactly what it is to be done. =C2=A0If I can moun=
t using a different superblock, do I then remove one of the drives from=
 the array so I can put that drive away with my data until I can buy an=
other drive to back up the data to? =C2=A0If so, how?
>
> How is it that the superblock on -both- drives got destroyed? =C2=A0I=
sn't RAID10 supposed to be mirrored?
>
> --- On Thu, 10/22/09, Majed B. <majedb@gmail.com> wrote:
>
> > From: Majed B. <majedb@gmail.com>
> > Subject: Re: Is My Data DESTROYED?!
> > To: "adfas asd" <chimera_god@yahoo.com>
> > Cc: linux-raid@vger.kernel.org
> > Date: Thursday, October 22, 2009, 7:12 PM
> > If you have bad sectors here
> > & there, and you didn't read the areas where the bad
> > sectors are, you won't get read errors.
> >
> > That's why you should always have smartd running along
> > with periodic sync_action -> check to force mdadm to
> > check the array.
> >
> >
> >
> > There's still hope in recovering your data. Don't
> > despair.
> >
> > On Fri, Oct 23, 2009 at 5:04 AM,
> > adfas asd <chimera_god@yahoo.com>
> > wrote:
> >
> >
> > How could this possibly have
> > happened? =C2=A0The whole idea of RAID is so something like this
> > won't happen.
> >
> >
> >
> >
> >
> > I was using JFS.
> >
> >
> >
> > I've lost confidence now in mdadm. =C2=A0I have too much
> > data to back up practically, and am now at a loss.
> >
> >
> >
> >
> >
> > --- On Thu, 10/22/09, Majed B. <majedb@gmail.com>
> > wrote:
> >
> >
> >
> > > From: Majed B. <majedb@gmail.com>
> >
> > > Subject: Re: Is My Data
> > DESTROYED?!
> >
> > > To: "adfas asd" <chimera_god@yahoo.com>
> >
> > > Cc: linux-raid@vger.kernel.org
> >
> > > Date: Thursday, October 22, 2009, 6:40 PM
> >
> > > Seems like your
> > filesystem is
> >
> > > corrupted. Some filesystems have alternative
> > superblocks.
> >
> > >
> >
> > > you can mount your filesystem using an alternative
> >
> > > superblock using: mount -o sb=3D<offset>
> >
> > > You find the offset value by running a dry-run (test)
> > of
> >
> > > mkfs on your drives. It will print multiple offsets
> > for
> >
> > > superblocks.
> >
> > >
> >
> > >
> >
> > >
> >
> > > On Fri, Oct 23, 2009 at 4:36 AM,
> >
> > > adfas asd <chimera_god@yahoo.com>
> >
> > > wrote:
> >
> > >
> >
> > >
> >
> > > Today I went in to my HTPC, to find it was hung and
> > the
> >
> > > drive light was stuck on. =C2=A0After all attempts to
> > revive it
> >
> > > or switch to terminal 2 or 3 had failed I reset the
> > system.
> >
> > >
> >
> > >
> >
> > >
> >
> > > It rebooted to tell me that it cannot mount /home,
> > the
> >
> > > RAID10offset2 device.
> >
> > >
> >
> > >
> >
> > >
> >
> > > When I reboot in recovery mode and try to mount
> > /dev/md0
> >
> > > manually it informs me there is an invalid superblock!
> > =C2=A0I
> >
> > > shut down and unplugged each drive in turn, and
> > /proc/mdstat
> >
> > > shows the appropriate volume gone, but still can't
> > mount
> >
> > > the array.
> >
> > >
> >
> > >
> >
> > >
> >
> > >
> >
> > >
> >
> > > What has happened here? =C2=A0Is all my data destroyed?
> >
> > >
> >
> > >
> >
> > >
> >
> > >
> >
> > >
> >
> > >
> >
> > >
> >
> > > --
> >
> > >
> >
> > > To unsubscribe from this list: send the line
> >
> > > "unsubscribe linux-raid" in
> >
> > >
> >
> > > the body of a message to majordomo@vger.kernel.org
> >
> > >
> >
> > > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-inf=
o.html
> >
> > >
> >
> > >
> >
> > >
> >
> > >
> >
> > > --
> >
> > > =C2=A0 =C2=A0 =C2=A0 =C2=A0Majed B.
> >
> > >
> >
> > >
> >
> > >
> >
> >
> >
> >
> >
> >
> >
> > --
> >
> > To unsubscribe from this list: send the line
> > "unsubscribe linux-raid" in
> >
> > the body of a message to majordomo@vger.kernel.org
> >
> > More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.=
html
> >
> >
> >
> >
> > --
> > =C2=A0 =C2=A0 =C2=A0 =C2=A0Majed B.
> >
> >
> >
>
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml



--
=C2=A0 =C2=A0 =C2=A0 Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
