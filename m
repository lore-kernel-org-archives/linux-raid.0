From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 21:05:03 -0700 (PDT)
Message-ID: <136111.99834.qm@web65105.mail.ac2.yahoo.com>
References: <4DD48E42.4010800@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD48E42.4010800@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids

--- On Thu, 19/5/11, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> From: Stan Hoeppner <stan@hardwarefreak.com>
> Subject: Re: Best way to create RAID-6 for swap partition - existing =
one failed
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
> Date: Thursday, 19 May, 2011, 15:28
> On 5/18/2011 9:50 PM, Gavin Flower
> wrote:
>=20
> > Hibernation mostly worked (almost all problems were
> associated with the Radeon video drivers) when I was using
> the RAID-6 swap partition.=A0 So I was not anticipating
> any new problem with hibernations.
> >=20
> > I am using Fedora 14 with all the latest patches
> applied.
> >=20
> > $ uname -a
> > Linux saturn 2.6.35.13-91.fc14.x86_64 #1 SMP Tue May 3
> 13:23:06 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
>=20
> Did you modify grub accordingly since switching from swap
> partition to
> file, and reboot?=A0 My very basic understanding, after
> reading a single
> Google hit, is that hibernation to/from swap has a
> dependency on a grub
> entry.=A0 Thus, the problem you have now is not due to
> switching to a swap
> file per se.=A0 It's due to the hibernation code not
> automatically
> recognizing you did so.
>=20
> Did you read any of the Google search results?=A0 All of
> the answers you
> need should be there, or not far away.
>=20
> --=20
> Stan

I looked at some Google results (see below), and have decided to revert=
 to using a partition.  As it is rapidly getting into more complication=
s than I have time to pursue. =20

This is far from the '60 second change' you promised :-)

Cheers,
Gavin

///////////

Red Hat Bug 466408 is an RFE to support using a swap file.

In /etc/rc.d/rc.sysinit there are lines that expect a swap partition:
[...]
# Start up swapping.
update_boot_stage RCswap
action $"Enabling /etc/fstab swaps: " swapon -a -e
if [ "$AUTOSWAP" =3D "yes" ]; then
	curswap=3D$(awk '/^\/dev/ { print $1 }' /proc/swaps | while read x; do=
 get_numeric_dev dec $x ; echo -n " "; done)
	swappartitions=3D$(blkid -t TYPE=3Dswap -o device)
	if [ x"$swappartitions" !=3D x ]; then
		for partition in $swappartitions ; do
			[ ! -e $partition ] && continue
			majmin=3D$(get_numeric_dev dec $partition)
			echo $curswap | grep -qw "$majmin" || action $"Enabling local swap p=
artitions: " swapon $partition
		done
	fi
fi
[...]


http://www.fedoraforum.org/forum/showthread.php?t=3D204114
[...]
Old 19th November 2008, 04:00 PM
stevea
[...]
I suspect that you cannot resume from a swap file without redesigning m=
kinitrd script. It currently resumes the swap (device or file) BEFORE i=
t mounts the root file system, so I think the resume/unhibernate is des=
tined to fail from a swap file. If you did mount the root first then yo=
u'd likely have a problem (fsck - unclean unmount) w/ the remounting th=
at fs later (maybe not - it's read access only). Maybe the resume could=
 work from a file, but that's unclear.
[...]

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
