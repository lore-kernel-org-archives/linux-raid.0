From: NeilBrown <neilb@suse.com>
Subject: Re: Why can't I re-add my drive after partition shrink?
Date: Mon, 17 Jul 2017 08:37:58 +1000
Message-ID: <87pod0ypmh.fsf@notabene.neil.brown.name>
References: <2ea5ed99-05b5-25d2-c9d4-8ce1f4945eaa@gmail.com> <87tw2f2425.fsf@notabene.neil.brown.name> <0341a04d-9aa5-7665-d9ff-527fe9fc8238@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0341a04d-9aa5-7665-d9ff-527fe9fc8238@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Jul 14 2017, Ram Ramesh wrote:

> On 07/13/2017 08:35 PM, NeilBrown wrote:
>> <snip
>> Please report output of "mdadm --examine" on both a device that is active
>> in the array, and the device that you are trying to add.
>> Also "mdadm --examine-bitmap" of a device that is active in the array.
>>
>> NeilBrown
>>
>>> I researched as much as I could on the net and came up with nothing
>>> except some one saying that mdadm keeps something at the end of the disk
>>> regardless of what it says about "Used Dev Size." Is it possible to move
>>> this info so that I could re-add?
>>>
>>> Ramesh
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Neil,
>
>    Since the problem, I did not want to leave my md in degraded state.=20
> So, I added my drive back and paid the penalty for rebuilding. I have=20
> other disks that need to be resized and *can get you want*. Please let=20
> me know if that is what you meant. If  you wanted the current info after=
=20
> successfully rebuilding the array after a regular add, it is below.

I only requested the information because it might help fix, or explain,
your difficulty.  If you don't currently have a difficulty, then I don't
need to look at any details.

Thanks,
NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAllr6sgACgkQOeye3VZi
gbkB8g/+KiYtiH4Gs/NkcTcpsoz3/9s0DKasDskut7OjiZS/Zcd9DLcRVfxClnq9
u3wj96E1QQVHDPB3619vUPG1BaiTeietwwCtmetIKiKOebDzqjP9FAc5movq4H6I
ny6u66ILYB421UFEtk9GCcYN0ESV/rmZQsX/VFWLJdLndjiftI4UiTbmp4y5NFSb
kQRsjOqfyEDJ0CFRE/NnWaIEH4SbM5kLdwLNCOBsM+Yweom3jdL5JmIqeX5nPW8t
s52nOgyeicnqvDzmLwO5UcOXMRzK+/AptcMmwokCvJSvJpUEore9y8PiIjNI61iy
M4AwD3B9ktTkgHgdjBToFp0Floyn2wZa4oTVjLu9NWHoEK0J2rE8eLJ21mJCKeH5
GLAHtcHYc2d61pNtEPrJ8/PkPc7ULrr51rE/yn0MO8B/2uu/a3LgrlbWOYmXMGoq
AjtrNdKLN1nBl3n6QOqfk/y93YdVfWAm3zhk4RF9XX6gZI9f/mSO6ECx7qaj7R09
ErLkjUFJbJK/oiy0L15p1GdynI0pA6416MY9eKpm0nsWsFBqqp6X0snD8VfRPJeL
o4MyXl9LwQKloP1nfrSHwjmoY0fgcPoSWjT1LIenFE/STxUiu1gLpStu4gWEe2eH
p23Tt/Ezf1aAotOCnNyR3a8k1kZRmW/74N0RuF28nTYC4VqWBjM=
=SuIK
-----END PGP SIGNATURE-----
--=-=-=--
