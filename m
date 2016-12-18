From: NeilBrown <neilb@suse.com>
Subject: Re: Inconsistent use of sectors vs 1k-blocks in sysfs and other places
Date: Mon, 19 Dec 2016 09:32:00 +1100
Message-ID: <87fulkvpgf.fsf@notabene.neil.brown.name>
References: <20161217051420.GA29241@oldkitsune.fastquake.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161217051420.GA29241@oldkitsune.fastquake.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Brooks <john@fastquake.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

On Sat, Dec 17 2016, John Brooks wrote:

> I noticed that the md.rst (formerly md.txt) file in Documentation/ says that
> the component_size attribute in sysfs is measured in sectors. What the
> attribute actually returns is sectors/2 (1K blocks, perhaps?). This is the
> relevant code from md.c:
>
> static ssize_t
> size_show(struct mddev *mddev, char *page)
> {
>         return sprintf(page, "%llu\n",
>                 (unsigned long long)mddev->dev_sectors / 2);
> }
>
> So the documentation doesn't match the code. Obviously, that needs fixing. But
> in this case, I'm not sure which one is "wrong". mdadm's get_component_size()
> function in sysfs.c reads this file and multiplies the result by 2 to get
> sectors. So clearly this is a known behaviour and not just a forgotten typo.

The code is right by definition.  As you say, mdadm uses this interface
so we cannot change it.

>
> Looking further, I found that this seems to be a point of inconsistency in
> multiple areas:

Yes.  Sad isn't it?
The original ioctl interface used 'K' so I copied that when I created
the sysfs interface.  After a while I realized that 'sectors' made a lot
more sense, so I change to that for subsequent additions.


>
> - The per-device "offset" attribute is in sectors (as documented).
>   The per-device "size" attribute is in 1K blocks (which the documentation
>   doesn't specify).
>
> - The "sync_completed" attribute uses sectors.
>   The "mdstat" file in procfs uses 1K blocks.
>
> - mdadm --examine shows Avail Dev Size in sectors.
>   mdadm --detail shows Used Dev Size in 1K blocks.
>   And they both show Array Size in 1K blocks.
>
> I suspect that the sysfs attributes have stayed the way they are in the
> interest of not breaking programs that use them. The easiest solution would
> probably be to leave the behaviour as-is but update the documentation so it's
> clear what units are used where.

Yes.  Not just "easiest", but "only acceptable".

>
> Somewhat related, suspend_{lo|hi}, resync_{min|max} attributes specify ranges
> in sectors, but the documentation does not specify if they are ranges on the
> array size or device size. And RAID10 may even handle resync_max differently
> from the rest; I didn't look deeply into that but see commit c805cdecea.

suspend_{lo|hi} are are array addresses
resync_{min|max} are array addresses for RAID1 and RAID10, and they are
device-addresses-offset-from-data_offset for RAID1 and RAID456.

>
> The reason I found out about the component_size issue is that I was trying to
> make use of the min/max attributes in a project I'm working on, found that they
> wanted device-based sectors, and then found that none of the sysfs attributes
> actually tell you the device size in sectors (or the array size for that
> matter, by the way).
>
> I'm interested to hear what the developers think. I didn't do a thorough audit
> to find all the different places that the different units are used; I just
> pointed out a few that I noticed while working with it. So I think it's a good
> discussion to bring up with the people familiar with the code.
>

I agree that it is sad that units aren't consistent, but there is not
much we can do about that.
It is bad that the documentation is incorrect and incomplete.  If you we
to post a patch which fixed some of it, I'm sure that would be
thankfully accepted.

In theory you could have a RAID1 with an odd number of sectors used in
each component, but I doubt that happens in practice.  So you can get
the component size in sectors by reading component_size and multiplying
by two.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlhXDmAACgkQOeye3VZi
gblnjRAAnOWqqzw40Hq9g9hMYA4Lf+mVLr57H7/YRZPal1yQdZtDVkp3COZ26gac
LbHm75dfQ1fo41sToE5OIR7Pam2bzURl4YRLrWmbfEMmVfIUxy/u9hSLORR49QZs
03yHnugEM01zSElL6ERxuLOgY/ASrcf7Kd53EN+2U1xfb9I1bPiNPQ2roYTXEo81
B/dC2CCsei82wZOkNfY2SPVPLAPBw1NbPg8KMENa5tiKKs0R5aUPWxr/ZZ+Pyyff
CKjZcBUdwCW2sbGNrG2xWw5I4cPfL6gJi6fuKkUqHtiU5VgRQuxxmRTGj0f+w5y7
2SO3j5UiopzIOqCR2bi3mZlZy4Aafe0CFqD5RtWZ6urTfgPa8zxXvFjV8hyjEjxx
rKsgBSsz+4D+KiQZ/LVIC6hFXqepsARr4Xw4vhyBnPfaPYlcDTYUDBZHJ6uATttM
DKNfer8bFGud9s8I4bHpI7fUIAvees7luMERkAEMQDyVupy/PoCi995xf2Nb7rrH
S5vdrwrcnAG3hkZvYsohDYZtMrA66vMDNhzdG/nMw0BlSgD0IMosxpswnSmVl1Qt
pS90HWitHSy0hkNpU8AC1XgnVZ5bGXrU0Q7bnTYvC52prO9f8Bvl6s7dVpt7hzhI
2vBMHb+2QiBKLCp+LQtELqJeW4sCgbZAKPqvu+0Q2SxJ0jtex58=
=qmBs
-----END PGP SIGNATURE-----
--=-=-=--
