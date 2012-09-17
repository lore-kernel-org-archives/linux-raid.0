From: NeilBrown <neilb@suse.de>
Subject: Re: RAID0 DeviceDisappeared event happen when restart mdmonitor
 service
Date: Mon, 17 Sep 2012 12:48:13 +1000
Message-ID: <20120917124813.0bd260c3@notabene.brown>
References: <012401cd9260$141ca630$3c55f290$@com>
	<CA+res+TafD=pdpX-8bz8M4keGDO45Jd=W9VGSY+=douiqGPy5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mGF00QC1oumL6VH/E.YmPub"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+res+TafD=pdpX-8bz8M4keGDO45Jd=W9VGSY+=douiqGPy5w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jack Wang <jack.wang.usish@gmail.com>
Cc: Johnson Yan <johnson_yan@usish.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/mGF00QC1oumL6VH/E.YmPub
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 17 Sep 2012 10:30:49 +0800 Jack Wang <jack.wang.usish@gmail.com>
wrote:

> I check into code in mdmonitor.c in function check_array:
>=20
> 	fd =3D open(dev, O_RDONLY);
> 	if (fd < 0) {
> 		if (!st->err)
> 			alert("DeviceDisappeared", dev, NULL, ainfo);
> 		st->err=3D1;
> 		return 0;
> 	}
> 	fcntl(fd, F_SETFD, FD_CLOEXEC);
> 	if (ioctl(fd, GET_ARRAY_INFO, &array)<0) {
> 		if (!st->err)
> 			alert("DeviceDisappeared", dev, NULL, ainfo);
> 		st->err=3D1;
> 		close(fd);
> 		return 0;
> 	}
> 	/* It's much easier to list what array levels can't
> 	 * have a device disappear than all of them that can
> 	 */
> 	if (array.level =3D=3D 0 || array.level =3D=3D -1) {
> 		if (!st->err)
> 			alert("DeviceDisappeared", dev, "Wrong-Level", ainfo);
> 		st->err =3D 1;
> 		close(fd);
> 		return 0;
> 	}
>=20
> I suspect above code lead to the DeviceDisapeared event you see, not
> sure why this get GET_ARRAY_INFO return array.level =3D=3D 0 means Device
> Disappeared?
>=20
> Anyone who more familiar with the logic may gave a comment?


It isn't possible or meaningful to monitor RAID0 devices - there is nothing
to see, nothing that can happen, nothing to report.

mdadm will normally completely ignore RAID0 devices.

If you run
  mdadm --monitor /dev/md1

when md1 is a RAID0 device, then it will be required to actively forget abo=
ut
it, so it reports that the device has disappeared (because it was on the
list, but now isn't).

This shouldn't happen if you run "mdadm --monitor --scan" which is the
standard usage.  It that what is happening?

NeilBrown



>=20
>=20
> Best regards!
>=20
> Jack
>=20
> 2012/9/14 Johnson Yan <johnson_yan@usish.com>:
> > Hi All,
> > When I restart mdmonitor service, a notify email will be received, which
> > indicate DeviceDisappeared event happened for RAID0, is this phenomenon
> > reasonable? Could anyone explain this?
> >
> >
> > The email info as below
> > ......
> > Host            : host3.com
> > Event           : DeviceDisappeared
> > MD Device       : /dev/md1
> > ......
> >
> > [root@host3 ~]# service mdmonitor restart
> > Killing mdmonitor:                                         [  OK  ]
> > Starting mdmonitor:                                        [  OK  ]
> > [root@host3 ~]#
> > [root@host3 ~]# cat /proc/mdstat
> > Personalities : [raid1] [raid0]
> > md1 : active raid0 sda1[1] sdb1[0]
> >       927933312 blocks super 1.2 64k chunks
> >
> > md2 : active raid1 sdc1[1] sde1[0]
> >       292836160 blocks super 1.2 [2/2] [UU]
> >       bitmap: 0/2 pages [0KB], 131072KB chunk
> >
> > md0 : active raid1 sdf1[0] sdg1[1]
> >       488254272 blocks super 1.2 [2/2] [UU]
> >       bitmap: 0/2 pages [0KB], 131072KB chunk
> >
> > unused devices: <none>
> > [root@host3 ~]#
> > [root@host3 ~]# uname -r
> > 3.2.28-11.el6.x86_64
> > [root@host3 ~]#
> > [root@host3 ~]# mdadm -V
> > mdadm - v3.2.5 - 18th May 2012
> > [root@host3 ~]#
> >
> >
> > Thanks in advance.
> > Johnson Yan
> >
> >
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/mGF00QC1oumL6VH/E.YmPub
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUFaPbTnsnt1WYoG5AQL5rw/6Aqb3YwapmGya1WoqmoVLnF10CalZar8N
Zx78SvwHczvfyQs6+q0zXCAxfXJqC0laP48OPQlrRi7Y4qmLlgqPD15SAhI4FWjR
n2yQUAoU29ltfkMNBjHTSS6V4RLY1RzrowZqV8kJStxBAozUVaHYmKzO7gsvZUeb
J7Y1JOtd+tpfRp2JkFk6OmVBTCoA+fnDbOnjcri+9KnWmt6APWLztAGIuWzVHXfA
Qzl5Bo7q7guImEH/yOwl1vc6BkfqOruD/0DfH+WGdbE0idLNORbrGjnF6gJlM2gk
pFfIVKWc388/F6WyzEIi8IEWIroZOLm4dsi7A8g2rnLGRTHSGHDaNstHN2wDmHk8
hvhlsWJc0sgGtNimPYCp1ASN2rvPoxjyPiH34fk0/QGhk3iSNkqj8d3ysaTTlEso
tB2XroG+ff9uvk62rtA6qYX0j+jBQzSgFJMWHAzZxotL9dGgo+VBcNh4n74kfU86
Sw1z00TpfeSroHrvUxjSPPhG3FRKkyc6L8IYMGjE67qfG3Q/Wsh/ujIzPrneCuCP
sZYG9g1865gIHzBpyyh7zu+4bN5t0Fv3IvsXqg9T24WbPu04fqyGTFoZ1CZZL6qs
1zN8yJUAKVHUE8TnzWK15SI0dJzfOANjTex9kzZWU4q2WJAmX7pHRvIRvtI7ngjD
2ZoesChHH/0=
=aIoP
-----END PGP SIGNATURE-----

--Sig_/mGF00QC1oumL6VH/E.YmPub--
