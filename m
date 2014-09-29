From: NeilBrown <neilb@suse.de>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Mon, 29 Sep 2014 14:37:35 +1000
Message-ID: <20140929143735.5fa54253@notabene.brown>
References: <53A99B76.3020603@gmail.com>
	<20140625110348.48ab2d7a@notabene.brown>
	<54243ED7.6090904@gmail.com>
	<20140926103348.5f5ea568@notabene.brown>
	<54253E9F.4070505@gmail.com>
	<20140926204445.1ec830b9@notabene.brown>
	<54255A30.9010406@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/R38NrjqKAGc5cM+PvR_QCXW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54255A30.9010406@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, sebastian.riemer@profitbricks.com
List-Id: linux-raid.ids

--Sig_/R38NrjqKAGc5cM+PvR_QCXW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Sep 2014 14:21:04 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> On 09/26/2014 12:44 PM, NeilBrown wrote:
> > On Fri, 26 Sep 2014 12:23:27 +0200 Francis Moreau <francis.moro@gmail.c=
om>
> > wrote:
> >=20
> >> Hello Neil,
> >>
> >> On 09/26/2014 02:33 AM, NeilBrown wrote:
> >>> On Thu, 25 Sep 2014 18:12:07 +0200 Francis Moreau <francis.moro@gmail=
.com>
> >>> wrote:
> >> [...]
> >>>> I tried to find out what could have opened the md device by using fu=
ser,
> >>>> but fuser reports no users.
> >>>
> >>> It is probably a transient open/close.
> >>>
> >>
> >> If it's open/close wouldn't the 'close' part make the device disapear ?
> >=20
> > No. It's ... complicated.
> >=20
> >>
> >>>>
> >>>> I took a look to the udev rules which are the one shipped by mdadm 3=
.3.2
> >>>> but nothing keep the device opened during the remove event.
> >>>>
> >>>> Could you give me some hints here to debug this ?
> >>>
> >>> Modify md_open in drivers/md/md.c to add
> >>>    printk("Opened by %s\n", current->comm);
> >>>
> >>> and build a new kernel.  That will tell you the name of the process w=
hich
> >>> opened the device.
> >>>
> >>
> >> I did that I also added a trace in md_release() but strangely no trace
> >> were outputed from there.
> >=20
> > Without seeing your patch I can't guess what it happening, but I am *ce=
rtain*
> > that md_release() would get called providing md_open didn't return an e=
rror.
>=20
> Here's the patch:
>=20
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 73aedcb..08ead8d 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6703,6 +6703,8 @@ static int md_open(struct block_device *bdev,
> fmode_t mode)
>  	struct mddev *mddev =3D mddev_find(bdev->bd_dev);
>  	int err;
>=20
> +	printk("md_open(): opened by %s\n", current->comm);
> +
>  	if (!mddev)
>  		return -ENODEV;
>=20
> @@ -6735,6 +6737,8 @@ static void md_release(struct gendisk *disk,
> fmode_t mode)
>  {
>   	struct mddev *mddev =3D disk->private_data;
>=20
> +	printk("md_release(): released by %s\n", current->comm);
> +
>  	BUG_ON(!mddev);
>  	atomic_dec(&mddev->openers);
>  	mddev_put(mddev);
>=20
> >=20
> > It might be helpful to print out the pid and the md device number too
> >  task_tgid_vnr(current)
> > will give you the pid.
> >   mdname(mddev)
> > give the name of the device.
> >=20
>=20
> Here's the new trace, this time md_release() was called, so I probably
> did something wrong the first time, sorry for that.
>=20
> [    1.470744] md_open(): md127 opened by mdadm [388]
> [    1.485437] md_release(): md127 released by mdadm [388]
> [    1.486888] md_open(): md126 opened by mdadm [381]
> [    1.487468] md_release(): md126 released by mdadm [381]
> [    1.488646] md_open(): md125 opened by mdadm [383]
> [    1.489074] md_release(): md125 released by mdadm [383]
> [    1.490555] md_open(): md127 opened by mdadm [385]
> [    1.512556] md_release(): md127 released by mdadm [385]
> [    1.512582] md_open(): md127 opened by mdadm [385]
> [    1.512682] md_open(): md126 opened by mdadm [384]
> [    1.553414] md_release(): md126 released by mdadm [384]
> [    1.553442] md_open(): md126 opened by mdadm [384]
> [    1.553549] md_open(): md125 opened by mdadm [382]
> [    1.573263] md_release(): md125 released by mdadm [382]
> [    1.573288] md_open(): md125 opened by mdadm [382]
> [    1.601034] md_open(): md125 opened by mdadm [459]
> [    1.601041] md_release(): md125 released by mdadm [459]
> [    1.601065] md_open(): md126 opened by mdadm [459]
> [    1.601067] md_release(): md126 released by mdadm [459]
> [    1.601090] md_open(): md127 opened by mdadm [459]
> [    1.601092] md_release(): md127 released by mdadm [459]
> [    1.601130] md_open(): md127 opened by mdadm [459]
> [    1.601220] md_release(): md127 released by mdadm [459]
> [    1.601633] md_open(): md126 opened by mdadm [459]
> [    1.601661] md_release(): md126 released by mdadm [459]
> [    1.601673] md_open(): md125 opened by mdadm [459]
> [    1.601695] md_release(): md125 released by mdadm [459]
> [    1.606127] md_open(): md125 opened by mdadm [454]
> [    1.608682] md_open(): md126 opened by mdadm [453]
> [    1.609514] md_open(): md127 opened by mdadm [448]
> [    1.622512] md_release(): md126 released by mdadm [453]
> [    1.623028] md_release(): md127 released by mdadm [448]
> [    1.625288] md_open(): md126 opened by systemd-udevd [363]
> [    1.625391] md_release(): md125 released by mdadm [454]
> [    1.625619] md_open(): md127 opened by systemd-udevd [368]
> [    1.625737] md_open(): md125 opened by systemd-udevd [366]
> [    1.637137] md_release(): md125 released by systemd-udevd [366]
> [    1.643982] md_open(): md125 opened by mdadm [476]
> [    1.644071] md_release(): md127 released by systemd-udevd [368]
> [    1.647787] md_release(): md125 released by mdadm [382]
> [    1.648171] md_release(): md126 released by systemd-udevd [363]
> [    1.651629] md_open(): md126 opened by mdadm [479]
> [    1.656666] md_open(): md127 opened by mdadm [480]
> [    1.657771] md_release(): md125 released by mdadm [476]
> [    1.659312] md_open(): md125 opened by systemd-udevd [365]
> [    1.663193] md_release(): md127 released by mdadm [385]
> [    1.673669] md_release(): md125 released by systemd-udevd [365]
> [    1.685527] md_release(): md127 released by mdadm [480]
> [    1.685599] md_release(): md126 released by mdadm [479]
> [    1.686058] md_open(): md126 opened by systemd-udevd [366]
> [    1.686282] md_release(): md126 released by systemd-udevd [366]
> [    1.691024] md_open(): md127 opened by systemd-udevd [363]
> [    1.695415] md_release(): md126 released by mdadm [384]
> [    1.707163] md_release(): md127 released by systemd-udevd [363]
>=20
> >>> mdadm --stop --scan <<<
>=20
> [   89.975162] md_open(): md125 opened by mdadm [930]
> [   89.975305] md_release(): md125 released by mdadm [930]
> [   89.977434] md_open(): md125 opened by mdadm [932]
> [   89.978813] md_open(): md125 opened by mdadm [930]
> [   89.979365] md_release(): md125 released by mdadm [932]
> [   89.979693] md_open(): md125 opened by systemd-udevd [931]
> [   89.985790] md_release(): md125 released by systemd-udevd [931]
> [   90.179911] md_release(): md125 released by mdadm [930]
> [   90.180168] md_open(): md127 opened by mdadm [459]
> [   90.180187] md_release(): md127 released by mdadm [459]
> [   90.180199] md_open(): md126 opened by mdadm [459]
> [   90.180205] md_release(): md126 released by mdadm [459]
> [   90.180556] md_open(): md126 opened by mdadm [930]
> [   90.180653] md_release(): md126 released by mdadm [930]
> [   90.180690] md_open(): md126 opened by mdadm [930]
> [   90.180758] md_open(): mdX opened by mdadm [459]
> [   90.180995] md_open(): md125 opened by mdadm [459]
> [   90.181056] md_release(): md125 released by mdadm [459]
> [   90.182717] md_open(): md127 opened by mdadm [459]
> [   90.182725] md_release(): md127 released by mdadm [459]
> [   90.182732] md_open(): md126 opened by mdadm [459]
> [   90.182761] md_release(): md126 released by mdadm [459]
> [   90.182770] md_open(): md125 opened by mdadm [459]
> [   90.182775] md_release(): md125 released by mdadm [459]
> [   90.182940] md_release(): md126 released by mdadm [930]
> [   90.183167] md_open(): md127 opened by mdadm [930]
> [   90.183257] md_release(): md127 released by mdadm [930]
> [   90.183288] md_open(): md127 opened by mdadm [930]
> [   90.183461] md_open(): md127 opened by mdadm [459]
> [   90.183488] md_release(): md127 released by mdadm [459]
> [   90.183499] md_open(): md125 opened by mdadm [459]
> [   90.183505] md_release(): md125 released by mdadm [459]
> [   90.183686] md_release(): md127 released by mdadm [930]

So what were pids 930 and 459?
One was presumably the "mdadm -Ss"  - probably 930.
Is 459 the "mdadm --monitor" ??  That might be useful hint.


>=20
>=20
> > Probably there is a 'change' event happening just before the 'remove' e=
vent,
> > and udev runs "mdadm" on the 'change' event, and that ends up happening=
 after
> > the device has been removed.
> >=20
> > Is this really a problem?  Can't you just ignore it and pretend it isn't
> > there?
>=20
> Well, if you list the block devices that the kernel detected in order to
> operate on them, it could. I don't know exactly what would be the result
> to use it but it could confuse some tools.
>=20
> Is there a way to check that the 'ghost' device has been removed by
> poking sysfs ?

If you look at /sys/block/md*/md/array_state, those that contain 'inactive'
or 'clear' might be 'ghosts', or might be in the process of being assembled.
If you write 'clear' to the same file they should disappear.... unless udev
does something to re-create them.

NeilBrown


--Sig_/R38NrjqKAGc5cM+PvR_QCXW
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCjiDznsnt1WYoG5AQJ7Xw/+Njy/myy8MDuc731UkMZ3lWovwr2Hdo2s
frORJK4No52Opk09mvx0zjKHauxcSrEPSpFyZa3z8XL6ULRUDNVUYB+dzZ2HUh27
CR8D1AWESuollmnsZiFYTc6BaSHanG3WmCdmf3ArMPbE7J3l2HRZzAWZ0hGRw6Nu
GuELNnmNZzImVwVac4IMV1J6QwCJu9ZCKbRHZ1dPaGE+Jzhx8lydbUc9eIi3OU6C
hWK/r40jLOSJ6vZuo8fWaW9Y1RkOjL/hBzQqA0+Cd+NmiOakB8NoVBQJpThzDADq
clqq/aYlxHPSV0qonZ6q9euHtlq5TqN5/vCgmdqMhQ8hZYZfi+lioHjQcSDcbO/J
IyOknyXrktUQm1q/d7o/vVHSq11kZXx6oSAuDAsTlEJ+SjJo2y0eeyjngPXUfVY7
qc34yTF+ttXAQDxJwujyZbFGe2U3wNOabtQsGso+63ZVa/qfhPQTrwCllke8E6Tw
Cy+mreAL+7xr/jo2Y2FwOXLYUNfeTmxMbKus5yhSYosJ7oVM8RZYRfc74mijyFPr
8L5Vukxv4IotsU3dSlf8KE6Ib1y1bNyHTg+/W0y03eOTrtSNIeFWY6BYlec1ebzf
3iVZRuRnNdCqV2AOSlk8eSFLsd2arRQUwREDYXFffFmkqU651n3jbyYoXxnioTvv
/Db4RZJcYw8=
=usb7
-----END PGP SIGNATURE-----

--Sig_/R38NrjqKAGc5cM+PvR_QCXW--
