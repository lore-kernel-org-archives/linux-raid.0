From: =?UTF-8?B?V2llcmRsIE3DoXTDqQ==?= <wierdlmate@gmail.com>
Subject: Re: superblock error after power failure ---on an old system
Date: Sat, 24 Apr 2010 08:39:50 -0500
Message-ID: <h2v4dfc23d1004240639i4a8132c1x307f261a74b853cb@mail.gmail.com>
References: <h2g4dfc23d1004240409s2409f02i2b99c50473ae4301@mail.gmail.com>
	<i2z4dfc23d1004240418k4fb43ed6q10a3624ae9fb008@mail.gmail.com>
	<20100424214744.284ccadc@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100424214744.284ccadc@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2010/4/24 Neil Brown <neilb@suse.de>
>
> On Sat, 24 Apr 2010 06:18:57 -0500
> Wierdl M=C3=A1t=C3=A9 <wierdlmate@gmail.com> wrote:
>
> > Hello,
> >
> > I have an old Dell Poweredge 2500 server running Fedora Core 3. The
> > server  had one of its power units failed, and (I think) as a resul=
t,
> > the raid arrays got damaged: three of them stayed alive (though
> > degraded), but one is not accessible. Unfortunately, the server onl=
y
> > has a floppy drive which doesn't work now, and so I cannot get any
> > files, command outputs directly off the box.  I copy it all from th=
e
> > screen.
> >
> > The array I cannot access is md3. It has the shared libraries on it=
 so
> > many commands do not work. In particular, I cannot have remote acce=
ss
> > to the box.
> >
> >  The output of
> >
> > mdadm -Es
> >
> > is (I am not copying the UUIDs)
> >
> > ARRAY /dev/md0 level=3Draid1 num-devices=3D2 devices=3D/dev/sdb2,/d=
ev/sdc2
> > ARRAY /dev/md2 level=3Draid1 num-devices=3D2 devices=3D/dev/sda6,/d=
ev/sdc3
> > ARRAY /dev/md3 level=3Draid5 num-devices=3D3 devices=3D/dev/sda3,/d=
ev/sdb1,/dev/sdc1
> > ARRAY /dev/md1 level=3Draid1 num-devices=3D2 devices=3D/dev/sda1,/d=
ev/sda2
> >
> > Also
> >
> > md0  mounted at /
> > md2 mounted at /var
> > md1  mounted at /boot
> > md3 should be mounted at /home
> >
> > # cat /proc/mdstat
> > Personalities: raid1 raid5
> > md1: active raid1 sda2[1] sda1[0]
> >          104320 blocks [2/2] [UU]
> >
> > md2: active raid1 sda6[0]
> >          513984 blocks [2/1] [U_]
> >
> > md0: active raid1 sdc2[1]
> >         1534080 blocks [2/1] [_U]
> >
> > unused devices: none
> >
> > # mdadm --detail /dev/md3
> > mdadm: md device /dev/md3 does not appear to be active
> >
> > At somebody's suggestion I tried
> >
> > mdadm --assemble --scan /dev/md0
> >
> > and got
> >
> > /dev/sda has no superblock - assembly aborted
> >
> > Then tried
> >
> > mdadm  --force --run /dev/md3
> >
> > and got
> >
> > failed to run array /dev/md3: Invalid argument
> >
> > I finally tried
> >
> > # mdadm --assemble /dev/md3 /dev/sda3 /dev/sdb1 /dev/sdc1
> > mdadm: device 1 in  /dev/md3 has wrong state superblock, but /dev/s=
db1 seems ok
>
> That looks close.  Just add "--force" to that and it will probably ge=
t
> you going.
>
> NeilBrown
>
>

Well, I now get, after rebooting:

/dev/md3: UNEXPECTED INCONSISTENCY; run fsck manually

So I did

fsck -y /dev/md3

and after running for about a minute or so, it gets into this

Too many illegal blocks in inode 8

and

Illegal block #6828 (39485860) in inode 8. CLEARED

Several lines of these, and then again

Too many illegal blocks in inode 8

The block number (#6828) changes but this loop never seems to end. I
aborted this, for now.  When I tried

mount /dev/md3 /home

I got: wrong fs type, bad option, bad superblock on md3

M=C3=A1t=C3=A9
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
