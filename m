From: Phil Turmel <philip@turmel.org>
Subject: Re: Reconstruct a RAID 6 that has failed in a non typical manner
Date: Thu, 5 Nov 2015 08:34:35 -0500
Message-ID: <563B5AEB.5020006@turmel.org>
References: <1874721715.14008052.1446134381481.JavaMail.zimbra@inria.fr>
 <5633B79D.4000009@turmel.org>
 <1861199271.16131793.1446719750662.JavaMail.zimbra@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1861199271.16131793.1446719750662.JavaMail.zimbra@inria.fr>
Sender: linux-raid-owner@vger.kernel.org
To: Clement Parisot <clement.parisot@inria.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Good morning Cl=C3=A9ment, Marc,

On 11/05/2015 05:35 AM, Clement Parisot wrote:

> We got surprised to see two drives that were announced in 'failed'
> state back in 'working order' after a reboot. At least they were not
> considered in failed state anymore. So we tried something a bit
> tricky.

> We removed the drive we changed and re-introduced the old one
> (supposed to be broken)

> Thanks to this, we were able to re-create the array with "mdadm
> --assemble --force /dev/md2", restart the volume group and mount
> read-only the logical volume.

Strictly speaking, you didn't re-create the array.  Simply re-assembled
it.  The terminology is important here.  Re-creating an array is much
more dangerous.

> Sadly, trying to rsync data into a safer place, most of it failed
> with I/O error, often ending killing the array.

Yes, with latent Unrecoverable Read Errors, you will need properly
working redundancy and no timeout mismatches.  I recommend you
repeatedly use --assemble --force to restore your array, skip the last
file that failed, and continue copying critical files as possible.

You should at least run this command every reboot until you replace you=
r
drives or otherwise script the work-arounds:

for x in /sys/block/*/device/timeout ; do echo 180 > $x ; done

> We still have two drives that were not physicaly removed, so that
> theorically contains datas, but that appears as spare in mdadm
> --examine, probably because of the 're-add' attempt we made.

The only way to activate these, I think, is to re-create your array.
That is a last resort after you've copied everything possible with the
forced assembly state.

>> Your subject is inaccurate.  You've described a situation that is=20
>> extraordinarily common when using green drives.  Or any modern
>> desktop drive -- they aren't rated for use in raid arrays.  Please
>> read the references in the post-script.

> After reading your links, it seems that indeed, the situation we
> experiment is what is described in link [3] or link [6].

>> Did you run "mdadm --stop /dev/md2" first?  That would explain the=20
>> "busy" reports.

[trim /]

There's *something* holding access to sda and sdb -- please obtain and
run "lsdrv" [1] and post its output.

>> Before proceeding, please supply more information:
>>=20
>> for x in /dev/sd[a-p] ; mdadm -E $x ; smartctl -i -A -l scterc $x ;
>> done
>>=20
>> Paste the output inline in your response.
>=20
>=20
> I couldn't get smartctl to work successfully. The version supported
> on debian squeeze doesn't support aacraid.

> I tried from a chroot in a debootstrap with a more recent debian
> version, but only got:
>=20
> # smartctl --all -d aacraid,0,0,0 /dev/sda

> smartctl 6.4 2014-10-07 r4002 [x86_64-linux-2.6.32-5-amd64] (local
> build)

> Copyright (C) 2002-14, Bruce Allen, Christian Franke,
> www.smartmontools.org
>=20
> Smartctl open device: /dev/sda [aacraid_disk_00_00_0] [SCSI/SAT]
> failed: INQUIRY [SAT]: aacraid result: 0.0 =3D 22/0

It's possible the 0,0,0 isn't correct.  The output of lsdrv would help
with this.

Also, please use the smartctl options I requested.  '--all' omits the
scterc information I want to see, and shows a bunch of data I don't nee=
d
to see.  If you want all possible data for your own use, '-x' is the
correct option.

[trim /]

It's very important that we get a map of drive serial numbers to curren=
t
device names and the "Device Role" from "mdadm --examine".  As an
alternative, post the output of "ls -l /dev/disk/by-id/".  This is
critical information for any future re-create attempts.

The rest of the information from smartctl is important, and you should
upgrade your system to a level that supports it, but it can wait for la=
ter.

It might be best to boot into a newer environment strictly for this
recovery task.  Newer kernels and utilities have more bugfixes and are
much more robust in emergencies.  I normally use SystemRescueCD [2] for
emergencies like this.

Phil

[1] https://github.com/pturmel/lsdrv
[2] http://www.sysresccd.org/

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
