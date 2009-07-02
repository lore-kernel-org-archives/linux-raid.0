From: Doug Ledford <dledford@redhat.com>
Subject: Re: RAID6 questions
Date: Thu, 2 Jul 2009 12:53:02 -0400
Message-ID: <8794D0BE-30D6-4B00-9F9C-843E94DD7086@redhat.com>
References: <2bdd5a4c0907020822s7d136681g23a4e34e13f0be8@mail.gmail.com> <871vozox2r.fsf@frosties.localdomain>
Mime-Version: 1.0 (Apple Message framework v935.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-41--189073055"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <871vozox2r.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Marek <mlf.conv@gmail.com>, linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-41--189073055
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Jul 2, 2009, at 12:42 PM, Goswin von Brederlow wrote:
> Marek <mlf.conv@gmail.com> writes:
>>
>> 3. Is it possible to use 0xDA with 0.9 superblock and omit autodetect
>> with mdadm 2.6.x? I couldn't find any information regarding this  
>> since
>> most RAID related sources either still suggest 0xFD and
>> autodetect(even with mdadm 3.0 by using -e 0.9 option) or they do not
>> state which version of mdadm to use in case of 1.x superblocks. Since
>> autodetect is deprecated, is there a safe way(without losing any  
>> data)
>> to convert from autodetect + 0xFD in the future?
>
> If you have raid build as module then the kernel does no
> autodetect. Otherwise you can give some kernel commandline option, see
> docs.

Most (if not all) sane distributions have not used raid autodetect in  
quite a while.  They use mdadm in the initrd and later during the init  
script sequence to start raid arrays instead.  Mdadm doesn't care what  
the partition type is.  I regularly use 0x83 for older raid devices,  
and 0xda on newer ones, with no ill effects.


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-41--189073055
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAkpM5e4ACgkQQ9aEs6Ims9iJ1wCfTWZsBHTmxEpb0+BsrcCzaa0b
pfYAoMT8+eb9dzIeHKwwf/4uXuEvabLb
=zH//
-----END PGP SIGNATURE-----

--Apple-Mail-41--189073055--
