From: Aaron Knister <aaron.s.knister@nasa.gov>
Subject: Re: clustered MD - beyond RAID1
Date: Mon, 21 Dec 2015 20:50:13 -0500
Message-ID: <5678AC55.7070606@nasa.gov>
References: <56742652.5040304@nasa.gov>
 <87si2w66tm.fsf@notabene.neil.brown.name> <567850C4.30108@bnl.gov>
 <87bn9j4jhr.fsf@notabene.neil.brown.name> <56786EA4.2020209@bnl.gov>
 <8737uv4fz6.fsf@notabene.neil.brown.name> <5678A2B9.6070008@bnl.gov>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature";
	boundary="dRvBfKiaudTrcWD3pOPKJfvWSv6Irp0nu"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5678A2B9.6070008@bnl.gov>
Sender: linux-raid-owner@vger.kernel.org
To: Tejas Rao <raot@bnl.gov>, NeilBrown <neilb@suse.de>
Cc: Scott Sinno <scott.sinno@nasa.gov>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--dRvBfKiaudTrcWD3pOPKJfvWSv6Irp0nu
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Tejas et al,

I'm fairly confident in saying that GPFS can have many servers actively=20
writing to a given NSD (LUN) at any given time. In our production=20
environment the NSDs have 6 servers defined and clients more or less=20
write to whichever one their little hearts desire. Do you think it's=20
possible that the explicit primary/secondary concept is from an older=20
version of GPFS? I'm not sure what the locking granularity is for=20
NSDs/disks, but even if it's a single GPFS FS block and that block size=20
corresponds to the stripe width of the array I'm pretty nervous relying=20
on that assumption for data integrity :)

The use case here is creating effectively highly available block storage =

from shared JBODs for use by VMs on the servers as well as to be=20
exported to other nodes. The filesystem we're using for this is actually =

GPFS. The intent was to use RAID6 in an active/active fashion on two=20
nodes sharing a common set of disks. The active/active was in an effort=20
to simplify the configuration.

I'm curious now, Redhat doesn't support SW raid failover? I did some=20
googling and found this:

https://access.redhat.com/solutions/231643

While I can't read the solution I have to figure that they're now=20
supporting that. I might actually explore that for this project.

-Aaron

On 12/21/15 8:09 PM, Tejas Rao wrote:
> Each GPFS disk (block device) has a list of servers associated with it.=

> When the first storage server fails (expired disk lease), the storage
> node is expelled and a different server which also sees the shared
> storage will do I/O.
>
> There is a "leaseRecoveryWait" parameter which tells the filesystem
> manager to wait for few seconds to allow the expelled node to complete
> any I/O in flight to the shared storage device to avoid any out of orde=
r
> i/O. After this wait time, the filesystem manager completes recovery on=

> the failed node, replaying journal logs, freeing up shared tokens/locks=

> etc. After the recovery is complete a different storage node will do
> I/O. There is a concept of primary/secondary servers for a given block
> device. The secondary server will only do I/O when the primary server
> has failed and this has been confirmed.
>
> See "servers=3DServerList" in man page for mmcrnsd. ( I don't think I a=
m
> allowed to send web links)
>
> We currently have 10's of petabytes in production using linux md raid.
> We are currently not sharing md devices, only hardware raid block
> devices are shared. In our experience hardware raid controllers are
> expensive. Linux raid has worked well over the years and performance is=

> very good as GPFS coalesces I/O in large filesystem blocksize blocks
> (8MB) and if aligned properly eliminate RMW (doing full stripe writes)
> and the need for NVRAM (unless someone is doing POSIX fsync).
>
> In the future ,we would prefer to use linux raid (RAID6) in a shared
> environment shielding us against server failures. Unfortunately we can
> only do this after Redhat supports such an environment with linux raid.=

> Currently they do not support this even in an active/passive environmen=
t
> (only one server can have a md device assembled and active regardless).=

>
> Tejas.
>
> On 12/21/2015 17:03, NeilBrown wrote:
>  > On Tue, Dec 22 2015, Tejas Rao wrote:
>  >
>  >> GPFS guarantees that only one node will write to a linux block devi=
ce
>  >> using disk leases.
>  >
>  > Do you have a reference to documentation explaining that?
>  > A few moments searching the internet suggests that a "disk lease" is=

>  > much like a heart-beat.  A node uses it to say "I'm still alive, ple=
ase
>  > don't ignore me".  I could find no evidence that only one node could=

>  > hold a disk lease at any time.
>  >
>  > NeilBrown
>

--=20
Aaron Knister
NASA Center for Climate Simulation (Code 606.2)
Goddard Space Flight Center
(301) 286-2776


--dRvBfKiaudTrcWD3pOPKJfvWSv6Irp0nu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Comment: GPGTools - https://gpgtools.org

iQIcBAEBCgAGBQJWeKxbAAoJEGKSgqJPfFO0CqkP/RwKs0Ncq47P5C71al/DDsHD
ZMyqOfjZpqfHwk1Mr5sRv9IykwMTd6clBo0gCPhOYK1mvJ/JiBXOlSyAZJbAFmW4
LyyYg2BbGgEZZJg5BOyc3/kuhVDJ8DQsfmDbUi4mCUfwORqp8FkIMnHwLuht936C
JiShpTG816qZGMhOMnPvYQd7AJU1wxCnzyFuhYPOg7FeE3m8wkShz0+nkpq8Ozi0
f8Ba/C0CNq64IKx7l0MHF4HcdiNzjxPK0oDuHAj2xIu9lCKkxtKM72W/SqQHPpq5
TcvjET0oIzvBF2ug/JqpJuFjr/oLEAR0qnZkDpf2kf66UgJbpPULTVbN0HKvdhNG
Xg8VuQNeIPtyRQNFO63CpEWAvM+/6H3GS+wCBD/WH8KYvEoQTUadcUMBvx3e+dDk
iJlX45wvlNSEtKRodBx0Y/zy11bk4qHu2igWuimVhslNOMD2FZ34bbswaQb1V1La
3T7x7BLvop3kHuWzS44zUMuaVNwAjnCasNWDNwMc8a3nb3IQFC0eVxF5ELDXU3sX
zrW4QZ6dyhtGS/1IGvOZzGz/A+5sU02mr2EFnhDJazI8GRQQjv1fqVjqWlT/+s67
JFyZgK/zwqNwbVHoaOdqdMoB893XfpqNWiTB09ONSZ8Sg+ZrIfuZkJSUXlxqUCm/
MYaw+lul1fcvD5o5L1PM
=W2Fr
-----END PGP SIGNATURE-----

--dRvBfKiaudTrcWD3pOPKJfvWSv6Irp0nu--
