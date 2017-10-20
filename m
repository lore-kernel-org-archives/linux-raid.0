From: NeilBrown <neilb@suse.com>
Subject: Re: MDADM RAID 6 Bad Superblock after reboot
Date: Fri, 20 Oct 2017 12:50:37 +1100
Message-ID: <87efpyfuz6.fsf@notabene.neil.brown.name>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com> <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com> <59E7AE4B.5000903@youngman.org.uk> <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com> <87zi8mg7mi.fsf@notabene.neil.brown.name> <e257fcc8-9773-a8a2-42bd-6030aef6329e@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e257fcc8-9773-a8a2-42bd-6030aef6329e@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: sfunk1x <sfunk1x@gmail.com>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Thu, Oct 19 2017, sfunk1x wrote:

> On 10/19/2017 02:17 PM, NeilBrown wrote:
>
>> Anything is better than nothing..  Can we get a photo of "mdadm
>> --examine" output on one of the devices (e.g. /dev/sda1) ??
>>=20
>> Also, what mdadm version (mdadm -V) and kernel version (uname -r)?
>
> https://imgur.com/x2rZEl5
>
> I included an --examine of sda1 and sdf.

Thanks.  sdf looks like it might have a gpt partition
table on it.  The "od -x" supports that.  What does "fdisk -l /dev/sdf"
show? What about=20
  mdadm --examine /dev/sdf*
??

>
>> mdadm never tries to edit mdadm.conf.
>> It does modify files in /run/mdadm (or maybe /var/run/mdadm).
>> Can we get a photo of that audit log?
>
> I was mistaken, I think. It looks like mdadm tried to read (??) the file
> and the context for the file was not set properly:
>
> https://imgur.com/5UvFExp

As you say, it was reading.  That makes sense but shouldn't be fatal.

>
> In order to "fix" the issue, I ran sealert against the audit.log and
> followed it's instructions, producing a rules file.
>
>>=20
>> I'm very suspicious of these new drives appearing to have not metadata.
>> Can you
>>    od -x /dev/sdf | head
>>    od -x /dev/sdf | grep a92b
>> and provide a photo of the output?
>
> grep'ing a92b scrolled off the screen, so I grabbed a portion of it,
> ctrl-c' and included head:

I should have suggested " | head" at the end of the 'grep'
command.  Maybe make it
  od -x /dev/sdf | grep '4efc a92b' | head
That will look for md metadata.

Thanks
NeilBrown



>
> https://imgur.com/WDcAYBc
>
> Thanks for the help so far.

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEG8Yp69OQ2HB7X0l6Oeye3VZigbkFAlnpVm8ACgkQOeye3VZi
gblyThAAlg+E/X7ymIm5NH158HV79p/tq5DpGw84jF6V61R9hj2gJ3Pz5Kt6kYbt
r44+De4NwF2j6tidGC8DM0gii7RDVhxUWMvqWLjPIP7H3D/U+rHgtiUHNwa38RPE
Dj1SqBgldcWDcdXgKUHLl79L16wCKDPavC1XJeFP42sR8PuwS+rMFEx/YNyk2qhi
7ew/wK9ZOPEWD5eo9qrJz8Y3vL5nCtBKr7tzS+qO626Ebx2HfxG8qpKvCxwzoAw9
zdH4sqSrrxD+rnT0kFIyXe3VApAzVOxUBpDxNrhLWcmltkLFgdvDhpYs05nsWrjC
Itewdh6sfs/gkvrBQMczr8AHmNDiGsJlEIxGp9TVix/AC0DtC21otS0kFCIbfB00
yw3bBPb+6ga9RZSRnFqVTE6A3K1Ta0+bUXHACObVaqSIvHRMU3K2IWee4MkoYPUo
lgHZnV204O9k0uRTpj2ic9g81kYuQMOzUfpeBXlGgshF1eZxeErrAPRE5BplSsA6
2itwjfINBJCDcyI9n/F4Wujhe7sELu2xMXEKVtVhJgcUI5NgrsKrRzUhouyudf5y
v2v2azmE+sKeg3V6uMn38mxuJHT9+4+htp3ovz+8m81U5iTWbsgDpVZTTBx1lDlA
Lx9MAPKJyQEWSO5vb0UgCPmAFiVQk1YwQxPZmW8RtaQGHePgX9U=
=S2v3
-----END PGP SIGNATURE-----
--=-=-=--
