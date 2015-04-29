From: NeilBrown <neilb@suse.de>
Subject: Re: Help needed recovering from raid failure
Date: Thu, 30 Apr 2015 09:27:41 +1000
Message-ID: <20150430092741.0dc24c39@notabene.brown>
References: <C17D8E8D-492C-4BDD-904C-75CCA70B2CD9@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/ihj+Z2FazmUH4n9=Vv77_up"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C17D8E8D-492C-4BDD-904C-75CCA70B2CD9@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Peter van Es <vanes.peter@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/ihj+Z2FazmUH4n9=Vv77_up
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 29 Apr 2015 20:17:09 +0200 Peter van Es <vanes.peter@gmail.com> wro=
te:

> Dear Neil,
>=20
> first of all, I really appreciate you trying to help me. This is the firs=
t time I=E2=80=99m deploying software raid, so really appreciate the guidan=
ce.
>=20
>=20
> > On 29 Apr 2015, at 00:26, NeilBrown <neilb@suse.de> wrote:
> >=20
> > This isn't really reporting anything new.
> > There is probably a daily cron job which reports all degraded arrays.  =
This
> > message is reported by that job.
>=20
> I understand...
>=20
> >=20
> >=20
> > Why do you think the array is off-line?  The above message doesn't sugg=
est
> > that.
> >=20
>=20
> My Ubuntu server was accessible through ssh but did not serve webpages, f=
iles etc. When I went to the console,=20
> it told me it had taken the array offline because of degraded /dev/sdd2 a=
nd /dev/sdc2
> Those two drives were out of the array.=20
>=20
> >=20
> >>=20
> >> Needless to say, I can't boot the system anymore as the boot drive is =
/dev/md0, and GRUB can't
> >> get at it. I do need to recover data (I know, but there's stuf on ther=
e I have no backup for--yet).
> >=20
> > You boot off a RAID5?  Does grub support that?  I didn't know.
> > But md0 hasn't failed, has it?
> >=20
> > Confused.
>=20
> Well, it took a little time but yes, I managed to define a raid 5 array t=
hat the system was able to boot from.=20
>=20
> > There is something VERY sick here.  I suggest that you tread very caref=
ully.
> >=20
> > All your '1' partitions should be about 2GB and the '2' parititions abo=
ut 2TB
> >=20
> > But the --examine output suggests sda2 and sdb2 are 2TB, while sdd2 and=
 sde2
> > are 2GB.
> >=20
> > That really really shouldn't happen.  Maybe check your partition table
> > (fdisk).
> > I really cannot see how this would happen.
>=20
> But this question, and the previous question you asked, tell me a little =
of what I may have done=E2=80=A6
>=20
> I think confused /dev/md0 and /dev/md1 (now called /dev/md126 and /dev/md=
127 when running of the USB stick).=20
>=20
> /dev/md0 is a swap array (around 6GB, comprised of 4 x 2 GB in raid 5)
> /dev/md1 is the boot and data array (around 5 TB, comprised of 4 x ~2 TB =
in raid 5)=20
>=20
> I must have confused them and tried to add the /dev/sdc2 and /dev/sdd2 dr=
ive to the /dev/md0 array (mdadm =E2=80=94add /dev/md0 /dev/sdc2)

Oops!

> instead of to the /dev/md1 array.  They were  then added as spare drives,=
 their superblocks were overwritten, but since
> a) no swap space was used, and=20
> b) they were added as spares
>=20
> The data should not have been overwritten.

Hopefully not.

>=20
> >=20
> > Can you
> >  mdadm -Ss
> >=20
> > to stop all the arrays, then
> >=20
> >  fdisk -l /dev/sd?
> >=20
> > then=20
> >=20
> >  mdadm -Esvv
> >=20
>=20
> Neil, here they are: again, I appreciate you taking the time and guiding =
me through this!
>=20
> Is there any way to resurrect the super blocks and try to force assemble =
the array, skipping the failing drive /dev/sdd2 (the /dev/sdd2 drive create=
d some errors I observed in the log, /dev/sdc2 must have had a one off issu=
e to be taken out=E2=80=A6.). I have two new drives (arrived today), and a =
new SSD drive. I would want to get the new array assembled using /dev/sdc2 =
perhaps forcing it back to the array geometry and =E2=80=9Choping for the b=
est=E2=80=9D and then install a new /dev/sdd2 to be recovered. Then I=E2=80=
=99ll create a boot and swap drive off the SSD which means that any array f=
ailures should not prevent the system from booting=E2=80=A6

As you have destroyed some metadata, it is no longer possible to 'assemble'
the array.  We need to re-create it.

sda2 and sdb2 appear to be the first two drives of the array.  sdd2 failed
first, so sdce is a better choice to use.  It is probably reasonable to
assume that it was the fourth drive in the array.  If that assumption proves
false then it might be the third.

Before doing this, double check that the names have changed, so check that
  mdadm --examine /dev/sda2
shows
>      Array UUID : 1f28f7bb:7b3ecd41:ca0fa5d1:ccd008df
>    Device Role : Active device 0

(among other info) and  that=20
  mdadm --exmaine /dev/sdb2
show the same Array UUID and
>    Device Role : Active device 1


Then run

 mdadm -C /dev/md1 -l5 -n4 --data-offset=3D262144s --metadata=3D1.2 --assum=
e-clean \
  /dev/sda2 /dev/sdb2 missing /dev/sde2

Then

 fsck -n -f /dev/md1

If the works, mount /dev/md1 and have a look around and confirm everything
looks OK.
If fsck complains, we might have sde2 in the wrong position.  Or maybe sde
and sdd changed names.
run
  mdadm -Ss
then rerun the -C command with a different list of devices. e.g.
  /dev/sda2 /dev/sdb2 /dev/sde2 missing

Always have one 'missing' device or you will be very likely to get
out-of-sync data.

Once you have data that look OK, copy out any really really important stuff
then, if you think the 4th drive is reliable enough, or if you have replaced
it, add '2' partition of the fourth drive to the array and let it rebuild.
Then you should be back to a safe working array.

NeilBrown



--Sig_/ihj+Z2FazmUH4n9=Vv77_up
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUFo7Tnsnt1WYoG5AQKNzg/9Esf4+Pwd4glbteyCDBJV7Uki21CduZ4C
KomMsk3GWRD5yI9ijF4HllC956qTmawxF0WYizeealg793wU0YJg5Y+6dt17bKSM
OaGmybLisXQsux9ePGXIvC4+FQEeCjWBMd4e9DoxiyvEs5AGhDmiRxU4wYzHo/g0
UCygAi6ijjHTUQsPdon2hlUJsjdUioln2TiHsLCUqOuMQa5LIsQaEBnyvb3i4YZD
VHwK2RtnWgg4SxNTQL9GghOZq5bZTKvHKpB6A2vlb2dBcMw2gpXx4YJTuVAq65HH
+g/ziPIuIXmiUzYzU2S/SKWo6u/8tpEE+DCZFm52B5IQr92EAJSgIwOn+w/1V5qE
y+teaB5Ox0V1k4b5ylpYPFViqmEYdouWG23LSr2mKLhLZP6EnfQB5hNSPbjmRFEQ
GMuQNmGvThrVfesvAF+8Z9zhgieKjy+pJ2uWjKGw+7aX9oNhLzSi/ynDrFPvo2se
bIx4QUQK3XsJI2y9N2AMb3RlBia8jtLpph0WPRPvv44OwqrUSV5h8bbt/XGYqZp6
FqU46+sM2GzvVNMChgB6nSzmp9ppqVxTEe+wBpeLqiZhYcQ1f8FXSJxSloQtjbWe
Ldffjoh+1w8URCQENfzOR2a2NSphOTeTRYaFqTgseKU71NaxtrDZV7lrNKnMEUNI
w85zgVYJl6M=
=ROaV
-----END PGP SIGNATURE-----

--Sig_/ihj+Z2FazmUH4n9=Vv77_up--
