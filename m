From: NeilBrown <neilb@suse.de>
Subject: Re: Removing a failing drive from multiple arrays
Date: Fri, 20 Apr 2012 07:52:12 +1000
Message-ID: <20120420075212.4574111a@notabene.brown>
References: <4F905F66.6070803@tmr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/F6jr/z9ToA8KhqMgckPb4hD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F905F66.6070803@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/F6jr/z9ToA8KhqMgckPb4hD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 19 Apr 2012 14:54:30 -0400 Bill Davidsen <davidsen@tmr.com> wrote:

> I have a failing drive, and partitions are in multiple arrays. I'm=20
> looking for the least painful and most reliable way to replace it. It's=20
> internal, I have a twin in an external box, and can create all the parts=
=20
> now and then swap the drive physically. The layout is complex, here's=20
> what blkdevtra tells me about this device, the full trace is attached.
>=20
> Block device sdd, logical device 8:48
> Model Family:     Seagate Barracuda 7200.10
> Device Model:     ST3750640AS
> Serial Number:    5QD330ZW
>      Device size   732.575 GB
>             sdd1     0.201 GB
>             sdd2     3.912 GB
>             sdd3    24.419 GB
>             sdd4     0.000 GB
>             sdd5    48.838 GB [md123] /mnt/workspace
>             sdd6     0.498 GB
>             sdd7    19.543 GB [md125]
>             sdd8    29.303 GB [md126]
>             sdd9   605.859 GB [md127] /exports/common
>    Unpartitioned     0.003 GB
>=20
> I think what I want to do is to partition the new drive, then one array=20
> at a time fail and remove the partition on the bad drive, and add a=20
> partition on the new good drive. Then repeat for each array until all=20
> are complete and on a new drive. Then I should be able to power off,=20
> remove the failed drive, put the good drive in the case, and the arrays=20
> should reassemble by UUID.
>=20
> Does that sound right? Is there an easier way?
>=20

I would add the new partition before failing the old but that isn't a big
issues.

If you were running a really new kernel, used 1.x metadata, and were happy =
to
try out code that that hasn't had a lot of real-life testing you could (aft=
er
adding the new partition) do
   echo want_replacement > /sys/block/md123/md/dev-sdd5/state
(for example).

Then it would build the spare before failing the original.
You need linux 3.3 for this to have any chance of working.

NeilBrown

--Sig_/F6jr/z9ToA8KhqMgckPb4hD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT5CJDDnsnt1WYoG5AQKUFw//SQX7bQ6rtPH/YlHAjehx4PgwGLB5IBzu
Piah0j9HckgTWI7nlt5yC1ab7KE0ciSET7MgOzWlBXMp+mteZxFsSPWtXPndB7Re
nbp+HZKeX0nCZOM8GJQAZAyTHmTVM/p2CNIoUPulA+ab/vHW0SA+ZQWsYD25UK5w
oKz4Wmcw1nRsyZpxK6iZJMLIJuhlsugmExS5IG39U9nnZDc/03KGQF34y/HdUbkv
s+FD+4ok0rvsd0OlkCJVP/sk5kUSnTs6gIfT8JhLcMhg9qbtgdQqqsFaGASBNTzz
Ddvuqgt0MnPUjOODbkTQ3PNysHAm4Ue9Qd1XsfjWPhDWpNcx5KASucM1Wp6270bs
2S5m6Q0TxCuqoxq0nP/IP/vP6NzGiel1NAQlnyn2l+NYWiqnoXqIMCHtDVf0Oibw
xrYh0nFDObxibrdlaFH1y6kJfqv2PAIA4Ux/iH10FXWtrUOH6Cv9aWfKUWVix7kJ
6vAHiyuH8OYkQausRJedZtO1dDFxqD7eFOqVacBHcNvvEWbQU22tWuePBt/6klfa
VRR7CfOlxx7gouP8Xo3AuyTOEVdyH6CFBNsUl2PeTOxyVfie7fUd/kkCmveGTyUq
Ia5/zjQxzsrlcSUHKm+83hXEYcbLCzqyqs3cw+0eMNZiJosT9xjo5M3k/CKY2jzT
o3i40XBgTyo=
=yin3
-----END PGP SIGNATURE-----

--Sig_/F6jr/z9ToA8KhqMgckPb4hD--
