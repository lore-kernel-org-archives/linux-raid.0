From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [PATCH] imsm: fix: correct checking newly missing disks
Date: Mon, 5 Dec 2011 18:19:09 -0800
Message-ID: <CABE8wwuMGo4BD2117p4BYt1OvYYOiXmnm5YF0Z04srG9Dmw2zA@mail.gmail.com>
References: <20111114145252.21148.62905.stgit@gklab-128-085.igk.intel.com>
	<CAA9_cmccLh=zYnqkpdhjkYZQQK26oUN4xqiMyycYHoLSr19zKg@mail.gmail.com>
	<D9FFE20C522965449E182ACE73889AEB052370@IRSMSX101.ger.corp.intel.com>
	<20111206121025.1e20e55a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111206121025.1e20e55a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Dorau, Lukasz" <lukasz.dorau@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Labun, Marcin" <Marcin.Labun@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Kwolek, Adam" <adam.kwolek@intel.com>
List-Id: linux-raid.ids

On Mon, Dec 5, 2011 at 5:10 PM, NeilBrown <neilb@suse.de> wrote:
> On Thu, 1 Dec 2011 14:23:16 +0000 "Dorau, Lukasz" <lukasz.dorau@intel=
=2Ecom>
> wrote:
>> > > diff --git a/super-intel.c b/super-intel.c
>> > > index 4ebee78..511a32a 100644
>> > > --- a/super-intel.c
>> > > +++ b/super-intel.c
>> > > @@ -2529,13 +2529,13 @@ static void getinfo_super_imsm(struct su=
pertype
>> > *st, struct mdinfo *info, char *
>> > >
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0failed =3D imsm_count_failed(supe=
r, dev);
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0state =3D imsm_check_degraded(sup=
er, dev, failed);
>> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(dev, dev->vol=
=2Emigr_state);
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 map =3D get_imsm_map(dev, 0);
>> > >
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0/* any newly missing disks?
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 * (catches single-degraded vs do=
uble-degraded)
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>> > > =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0for (j =3D 0; j < map->num_member=
s; j++) {
>> > > - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_=
imsm_ord_tbl_ent(dev, i, -1);
>> > > + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 __u32 ord =3D get_=
imsm_ord_tbl_ent(dev, i, 0);
>> >
>> > This looks wrong. =A0I noticed this when looking over Przemyslaw's=
 patch [1].
>> >
>> > map[0] always contains the destination state of the migration so t=
he
>> > most reliable source for looking for out of sync disks is map[1].
>> >
>>
>> I am convinced that the patch is good.
>> We are looking for information what was the state of array during mi=
gration (before it was stopped), so we have to use map[0].
>> map[1] contains information about the state of array before migratio=
n, which we do not need.
>>
>> Regards,
>> Lukasz
>
> Hi,
> =A0do we have agreement on this? =A0Dan - do you stand by your origin=
al concern
> =A0or have you seen the light :-)
>
> The patch is in, but I'd like to be sure it is right and to be honest=
 I
> haven't followed the dance of the maps too closely...

Lukasz is right.  We want to find out if starting the array with the
current list of disks in the container would regress the state of the
array recorded in the metadata.  map[0] should always record the best
possible state of all the slots in the array if any of those have gone
missing we don't want incremental assembly to proceed.

Sorry for the noise, my point was 'correct' in isolation but it missed
that the context is looking for the most optimistic view of the disk.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
