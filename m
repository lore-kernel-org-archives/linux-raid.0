From: "Majed B." <majedb@gmail.com>
Subject: Re: RAID5 / 6 Growth
Date: Sat, 19 Dec 2009 22:55:09 +0300
Message-ID: <70ed7c3e0912191155n5935bcfbk2a1029beae86afc8@mail.gmail.com>
References: <70ed7c3e0912191036o2a1d413es6492bdafc3a75267@mail.gmail.com>
	<FD.58.01470.3532D2B4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <FD.58.01470.3532D2B4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

With dev/backup I mean if the Linux machine you're running is a a
backup system or a development machine that you can at least test this
on, it'd be convenient.

The reason why you can't mount even though repair suggests you do
might be because of a bug in xfsprogs/libs not a complete corruption
in the filesystem itself.

Perhaps even the newer version of the progs & libs might be able to
handle the kind of corruption in the filesystem you're having now,
without the need to clear the log.

In case you resort to clearing the log, wouldn't running xfs_repair
result in eventually finding the lost inodes and putting them in
lost+found?

On Sat, Dec 19, 2009 at 10:02 PM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
>> Do any of the disks report sector errors or ATA or read errors?
>> smartctl -a /dev/sdx should give the report, assuming you run smartd
>> and have it probe disks periodically.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0No, they are clean.
>
>> I've seen newer versions of the xfsprogs and libs packages. Try usin=
g
>> those. I know you're against new packages that haven't been included
>> in "stable" -- but if this is a dev/backup system, it's worth the sh=
ot
>> in my opinion.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0Well, either way, that's not going to help=
 in this situation.
> Either there is something I can attempt to fix in the underlying arra=
y
> structure, or else I am going to have to erase the log and continue.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0I'm not sure what you mean by dev/backup. =
=C2=A0The file system is not
> created as a device on any other system by udev, if that's what you m=
ean.
> It's just a Linux system dedicated solely to running rscync backups e=
very
> morning at 04:00. =C2=A0The array does get mounted on other systems u=
sing SAMBA
> or NFS, as the case may be, so I can easily copy over files to the ma=
in
> systems lost or corrupted through whatever means.
>
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
