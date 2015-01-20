From: Xiao Ni <xni@redhat.com>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Tue, 20 Jan 2015 02:16:46 -0500 (EST)
Message-ID: <1063248306.12205209.1421738206544.JavaMail.zimbra@redhat.com>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com> <20141117100349.1d1ae1fa@notabene.brown> <54B663EC.8090607@redhat.com> <20150115082210.31bd3ea5@jlaw-desktop.mno.stratus.com> <2054919975.10444188.1421385612513.JavaMail.zimbra@redhat.com> <20150116101031.30c04df3@jlaw-desktop.mno.stratus.com> <1924199853.11308787.1421634830810.JavaMail.zimbra@redhat.com> <20150119125650.22a75dd3@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150119125650.22a75dd3@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "Joe Lawrence" <joe.lawrence@stratus.com>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org, "Bill Ku=
zeja" <william.kuzeja@stratus.com>
> Sent: Tuesday, January 20, 2015 1:56:50 AM
> Subject: Re: RAID1 removing failed disk returns EBUSY
>=20
> On Sun, 18 Jan 2015 21:33:50 -0500
> Xiao Ni <xni@redhat.com> wrote:
>=20
> >=20
> >=20
> > ----- Original Message -----
> > > From: "Joe Lawrence" <joe.lawrence@stratus.com>
> > > To: "Xiao Ni" <xni@redhat.com>
> > > Cc: "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org, "Bil=
l
> > > Kuzeja" <william.kuzeja@stratus.com>
> > > Sent: Friday, January 16, 2015 11:10:31 PM
> > > Subject: Re: RAID1 removing failed disk returns EBUSY
> > >=20
> > > On Fri, 16 Jan 2015 00:20:12 -0500
> > > Xiao Ni <xni@redhat.com> wrote:
> > > >=20
> > > > Hi Joe
> > > >=20
> > > >    Thanks for reminding me. I didn't do that. Now it can remove
> > > >    successfully after writing
> > > > "idle" to sync_action.
> > > >=20
> > > >    I thought wrongly that the patch referenced in this mail is =
fixed
> > > >    for
> > > >    the problem.
> > >=20
> > > So it sounds like even with 3.18 and a new mdadm, this bug still
> > > persists?
> > >=20
> > > -- Joe
> > >=20
> > > --
> >=20
> > Hi Joe
> >=20
> >    I'm a little confused now. Does the patch
> >    45eaf45dfa4850df16bc2e8e7903d89021137f40 from linux-stable
> > resolve the problem?
> >=20
> >    My environment is:
> >=20
> > [root@dhcp-12-133 mdadm]# mdadm --version
> > mdadm - v3.3.2-18-g93d3bd3 - 18th December 2014  (this is the newes=
t
> > upstream)
> > [root@dhcp-12-133 mdadm]# uname -r
> > 3.18.2
> >=20
> >=20
> >    My steps are:
> >=20
> > [root@dhcp-12-133 mdadm]# lsblk
> > sdb                       8:16   0 931.5G  0 disk
> > =E2=94=94=E2=94=80sdb1                    8:17   0     5G  0 part
> > sdc                       8:32   0 186.3G  0 disk
> > sdd                       8:48   0 931.5G  0 disk
> > =E2=94=94=E2=94=80sdd1                    8:49   0     5G  0 part
> > [root@dhcp-12-133 mdadm]# mdadm -CR /dev/md0 -l1 -n2 /dev/sdb1 /dev=
/sdd1
> > --assume-clean
> > mdadm: Note: this array has metadata at the start and
> >     may not be suitable as a boot device.  If you plan to
> >     store '/boot' on this device please ensure that
> >     your boot-loader understands md/v1.x metadata, or use
> >     --metadata=3D0.90
> > mdadm: Defaulting to version 1.2 metadata
> > mdadm: array /dev/md0 started.
> >=20
> >    Then I unplug the disk.
> >=20
> > [root@dhcp-12-133 mdadm]# lsblk
> > sdc                       8:32   0 186.3G  0 disk
> > sdd                       8:48   0 931.5G  0 disk
> > =E2=94=94=E2=94=80sdd1                    8:49   0     5G  0 part
> >   =E2=94=94=E2=94=80md0                   9:0    0     5G  0 raid1
> > [root@dhcp-12-133 mdadm]# echo faulty > /sys/block/md0/md/dev-sdb1/=
state
> > [root@dhcp-12-133 mdadm]# echo remove > /sys/block/md0/md/dev-sdb1/=
state
> > -bash: echo: write error: Device or resource busy
> > [root@dhcp-12-133 mdadm]# echo idle > /sys/block/md0/md/sync_action
> > [root@dhcp-12-133 mdadm]# echo remove > /sys/block/md0/md/dev-sdb1/=
state
> >=20
> >=20
> >    Now after I set idle to sync_action, it can be removed as you sa=
id in
> >    the mail.
> > It's a good workaround. Is this OK?
> >=20
> > Best Regards
> > Xiao
>=20
> Hi Xiao,
>=20
> According to my notes, the "idle" sync_action was always a viable
> workaround, with or with this change.
>=20
> Neil's patch should have made it possible to issue only a
> "faulty" and "remove" to remove the RAID component.
>=20
> I don't have an exact version, but it appears that my mdadm version w=
as
> an upstream git from Oct 27-th timeframe.
>=20
> -- Joe
>=20

Joe

   Thanks for the explanation. So echo "idle" to sync_action is a worka=
round
without the patch.=20
=20
   It looks like the patch is not enough to fix the problem.=20
Do you have a try with the new patch? Is the problem still exist in
your environment?

   If your environment have no problem, can you give me the version num=
ber? I'll=20
have a try with the same version too.=20

Best Regards
Xiao
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
