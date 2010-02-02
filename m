From: Doug Ledford <dledford@redhat.com>
Subject: Re: [[Patch mdadm] 2/5] Move the files mdmon opens into /dev/ to
 	support handoff after pivotroot
Date: Tue, 02 Feb 2010 13:11:51 -0500
Message-ID: <4B686AE7.7090806@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com>	 <1263242294-5353-3-git-send-email-dledford@redhat.com>	 <20100119110930.107ca42e@notabene> <4B55F138.7060008@redhat.com>	 <4B673A5D.2010901@tmr.com> <4B674860.7080604@redhat.com>	 <4B6758C7.9060301@tmr.com> <4877c76c1002012008u2e32d6a4y9b4fec721dfe8435@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigCBCCD8C57825408D6F3C5CC9"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1002012008u2e32d6a4y9b4fec721dfe8435@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Evans <mjevans1983@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigCBCCD8C57825408D6F3C5CC9
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 02/01/2010 11:08 PM, Michael Evans wrote:
> On Mon, Feb 1, 2010 at 2:42 PM, Bill Davidsen <davidsen@tmr.com> wrote:=

>> Doug Ledford wrote:
>>>
>>> On 02/01/2010 03:32 PM, Bill Davidsen wrote:
>>>
>>>>
>>>> Doug Ledford wrote:
>>>>
>>>>>
>>>>> On 01/18/2010 05:09 PM, Neil Brown wrote:
>>>>>
>>>>>>
>>>>>> I understand there is a problem here, but I don't like this approa=
ch
>>>>>> to a
>>>>>> solution.  I'll give it more though when I get home from LCA2010 a=
nd
>>>>>> see
>>>>>> what I can come up with.
>>>>>>
>>>>>
>>>>> Feel free to come up with something different.  But, if your soluti=
on
>>>>> involves maintaining an additional read/write mount area in deferen=
ce to
>>>>> a long dead unix tradition, I'm just going to shake my head and pat=
ch
>>>>> your solution away to something sane.
>>>>>
>>>>>
>>>>
>>>> I don't understand you argument here. Not the one where you say you'=
re
>>>> going to ignore Neil and do what you want because you can, I underst=
and
>>>> that, but the "additional read/write mount area" part, isn't /var/ru=
n
>>>> r/w on all systems now? Could you clarify why this is "additional" h=
ere?
>>>>
>>>>
>>>
>>> It's not necessarily read/write in the initrd time frame, and putting=

>>> the mdadm files there means it would have to be.  We didn't make thes=
e
>>> changes because we wanted to, we made them because using mdadm raid
>>> arrays for the root filesystem combined with incremental assembly or
>>> with imsm raid devices was broken otherwise.
>>>
>>>
>>
>> Do understand that my disquiet related to this isn't because you put a=

>> non-device in /dev, it's that you
>> didn't put a process PID in /var/run. And frankly, once you let (force=
) one
>> group of threads to be somewhere
>> else, other services will want their PIDs some other place, and anyone=

>> maintaining an application
>> which presents information on what's running will need to know where t=
hat
>> information.
>>
>> In other words, it's not where you put it, it's where you *didn't* put=
 it,
>> that seems to be an
>> invitation to put stuff just anywhere. Neil argues that they are not
>> devices, I argue that
>> they are PIDs. It's not as though it were a huge effort to move it aft=
er
>> pivot root, it's a little code
>> or script and in space which will be released.
>>
>> --
>> Bill Davidsen <davidsen@tmr.com>
>>  "We can't solve today's problems by using the same thinking we
>>  used in creating them." - Einstein
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" =
in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>=20
> Thank you for stating your concern; I think knowing that a very
> plausible solution is obvious.
>=20
> # at initrd/initramfs creation time
> ln -s /dev/.run /var/run
>=20
> #initrd/initramfs script
> mkdir /dev/.run
>=20
> The usual area becomes a symlink to a memory disk .Most systems have
> ample memory to support a few extra tiny files there. Cleanup on
> reboot is automatic. Any systems that are memory constrained probably
> already either have a drive they could swap this data out to, or would
> rather save the writes from reaching flash media anyway.

It's highly likely that mdmon would need its own directory, so ln -s
/dev/.mdmon /var/run/mdmon would be more suitable.  This is due to
SELinux contexts.  I know mdadm needed /var/run/mdadm so that in monitor
mode with strong SELinux enabled it could have its own private context
and that context could then be given the permissions it needed (create
dev file, access sendmail, etc., a number of these actions are the very
type of actions that programs do when compromised so part of strong
security is only granting those perms to programs that legitimately need
them).  Mdmon may not need the same perms that mdadm did, but I still
wouldn't be surprised if it needs its own context/directory due to the
relative danger of handing out raw disk access.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigCBCCD8C57825408D6F3C5CC9
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktoaucACgkQg6WylM+/8ZQKAgCcCePVgx7Mhwh6SkjCmOVtUzuL
JRwAn3zLL4d02seQ10uaNciDy6KBA+51
=8q9b
-----END PGP SIGNATURE-----

--------------enigCBCCD8C57825408D6F3C5CC9--
