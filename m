From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: migrate to bad block list
Date: Fri, 17 Oct 2014 19:06:32 +0200
Message-ID: <20141017170632.GA3272@lazy.lzy>
References: <E1D69AD765F9D841B8DE87D96DD21E4505DFBADD@AEMAILMBX02.lenovo.com>
 <20141016175414.01334582@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20141016175414.01334582@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Michael Ryan <mryan@lenovoemc.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

On Thu, Oct 16, 2014 at 05:54:14PM +1100, NeilBrown wrote:
> On Wed, 15 Oct 2014 17:18:19 +0000 Michael Ryan <mryan@lenovoemc.com>=
 wrote:
>=20
> >=20
> > Is there any way to migrate an existing array created with mdadm v3=
=2E2.5 and using 1.1 metadata to use a bad block list?=A0 I'm assuming =
not as there wouldn't be space reserved for the list, but I need to ask=
=2E
> >=20
> > Thanks for your response!
>=20
> mdadm tends to leave a fair bit of unused space on devices so that th=
ings
> like a bad block list can easily be added.
> If you can stop the array, then do that and re-assemble with
>   --update=3Dbbl
>=20
> and you should  get a bbl added to each device.
>=20
> If you cannot stop the array, but it has a bitmap, then
> you can, for each device:
>=20
>   mdadm /dev/mdX --fail /dev/adevice
>   mdadm /dev/mdX --remove /dev/adevice
>   mdadm /dev/mdX --re-add --update=3Dbbl /dev/adevice
>=20
> I think that should work.  The "bblk" is a feature of the device, not=
 of the
> whole array.  So you can add it to each device.

is there any technical reason why it is not
possible to enable/disable the bbl like the
write intent bitmap?
Something like:

mdadm --grow /dev/<md> --bbl=3D[internal|none]

Thanks,

bye,

pg

> I haven't actually tested the above I think, so it might be safest to=
 make an
> array with loop-back devices and experiment.
>=20
> NeilBrown



--=20

piergiorgio
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
