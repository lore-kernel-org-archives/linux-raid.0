From: Xiao Ni <xni@redhat.com>
Subject: Re: RAID1 removing failed disk returns EBUSY
Date: Sun, 18 Jan 2015 21:33:50 -0500 (EST)
Message-ID: <1924199853.11308787.1421634830810.JavaMail.zimbra@redhat.com>
References: <20141027162748.593451be@jlaw-desktop.mno.stratus.com> <20141029133604.59f9549a@jlaw-desktop.mno.stratus.com> <20141113090549.296a13ee@jlaw-desktop.mno.stratus.com> <20141117100349.1d1ae1fa@notabene.brown> <54B663EC.8090607@redhat.com> <20150115082210.31bd3ea5@jlaw-desktop.mno.stratus.com> <2054919975.10444188.1421385612513.JavaMail.zimbra@redhat.com> <20150116101031.30c04df3@jlaw-desktop.mno.stratus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150116101031.30c04df3@jlaw-desktop.mno.stratus.com>
Sender: linux-raid-owner@vger.kernel.org
To: Joe Lawrence <joe.lawrence@stratus.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Bill Kuzeja <william.kuzeja@stratus.com>
List-Id: linux-raid.ids



----- Original Message -----
> From: "Joe Lawrence" <joe.lawrence@stratus.com>
> To: "Xiao Ni" <xni@redhat.com>
> Cc: "NeilBrown" <neilb@suse.de>, linux-raid@vger.kernel.org, "Bill Ku=
zeja" <william.kuzeja@stratus.com>
> Sent: Friday, January 16, 2015 11:10:31 PM
> Subject: Re: RAID1 removing failed disk returns EBUSY
>=20
> On Fri, 16 Jan 2015 00:20:12 -0500
> Xiao Ni <xni@redhat.com> wrote:
> >=20
> > Hi Joe
> >=20
> >    Thanks for reminding me. I didn't do that. Now it can remove
> >    successfully after writing
> > "idle" to sync_action.
> >=20
> >    I thought wrongly that the patch referenced in this mail is fixe=
d for
> >    the problem.
>=20
> So it sounds like even with 3.18 and a new mdadm, this bug still
> persists?
>=20
> -- Joe
>=20
> --

Hi Joe

   I'm a little confused now. Does the patch 45eaf45dfa4850df16bc2e8e79=
03d89021137f40 from linux-stable
resolve the problem?

   My environment is:

[root@dhcp-12-133 mdadm]# mdadm --version
mdadm - v3.3.2-18-g93d3bd3 - 18th December 2014  (this is the newest up=
stream)
[root@dhcp-12-133 mdadm]# uname -r
3.18.2


   My steps are:

[root@dhcp-12-133 mdadm]# lsblk=20
sdb                       8:16   0 931.5G  0 disk=20
=E2=94=94=E2=94=80sdb1                    8:17   0     5G  0 part=20
sdc                       8:32   0 186.3G  0 disk=20
sdd                       8:48   0 931.5G  0 disk=20
=E2=94=94=E2=94=80sdd1                    8:49   0     5G  0 part=20
[root@dhcp-12-133 mdadm]# mdadm -CR /dev/md0 -l1 -n2 /dev/sdb1 /dev/sdd=
1 --assume-clean
mdadm: Note: this array has metadata at the start and
    may not be suitable as a boot device.  If you plan to
    store '/boot' on this device please ensure that
    your boot-loader understands md/v1.x metadata, or use
    --metadata=3D0.90
mdadm: Defaulting to version 1.2 metadata
mdadm: array /dev/md0 started.

   Then I unplug the disk.

[root@dhcp-12-133 mdadm]# lsblk=20
sdc                       8:32   0 186.3G  0 disk =20
sdd                       8:48   0 931.5G  0 disk =20
=E2=94=94=E2=94=80sdd1                    8:49   0     5G  0 part =20
  =E2=94=94=E2=94=80md0                   9:0    0     5G  0 raid1=20
[root@dhcp-12-133 mdadm]# echo faulty > /sys/block/md0/md/dev-sdb1/stat=
e=20
[root@dhcp-12-133 mdadm]# echo remove > /sys/block/md0/md/dev-sdb1/stat=
e=20
-bash: echo: write error: Device or resource busy
[root@dhcp-12-133 mdadm]# echo idle > /sys/block/md0/md/sync_action=20
[root@dhcp-12-133 mdadm]# echo remove > /sys/block/md0/md/dev-sdb1/stat=
e=20


   Now after I set idle to sync_action, it can be removed as you said i=
n the mail.
It's a good workaround. Is this OK?=20

Best Regards
Xiao


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
