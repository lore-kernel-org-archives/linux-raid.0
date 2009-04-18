From: Doug Ledford <dledford@redhat.com>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Sat, 18 Apr 2009 10:50:37 -0400
Message-ID: <B91E8659-0AD8-4A4D-A1B6-7B6E083753EE@redhat.com>
References: <cccedfc60903240957j9314cb2k41d86cb78ec10b86@mail.gmail.com> <cccedfc60904010815h4056f55doebff4827705d231b@mail.gmail.com> <18899.61151.445765.360191@notabene.brown> <51C39605-BBE7-48E8-AB35-D55D0B36B3A6@redhat.com> <18919.64597.426128.498393@notabene.brown> <D6CEC060-43DC-40A5-A7EE-F2653DBA9C4C@redhat.com> <20090418081239.GB2124@maude.comedia.it> <F43DC4EB-8E83-4284-A2BE-85EF146AE956@redhat.com> <20090418135203.GA3448@lazy.lzy>
Mime-Version: 1.0 (Apple Message framework v930.3)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-9--233967382"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20090418135203.GA3448@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org, Luca Berra <bluca@comedia.it>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-9--233967382
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Apr 18, 2009, at 9:52 AM, Piergiorgio Sartor wrote:
> On Sat, Apr 18, 2009 at 09:35:33AM -0400, Doug Ledford wrote:
>> On Apr 18, 2009, at 4:12 AM, Luca Berra wrote:
>>> uhm, udev should be able to assemble an array without mdadm.conf,  
>>> not
>>> that i like it
>>
>> It does, the question is whether or not it should honor the preferred
>> minor when it assembles an array not in mdadm.conf.
>
> Does it?

Starting with F11, yes.  Not with prior releases.

> Then I should open a bug to Fedora, because to
> me it does not (always).
>
> bye,
>
> -- 
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-9--233967382
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.11 (Darwin)

iEYEARECAAYFAknp6L0ACgkQQ9aEs6Ims9iMkgCeJSZIN2aERXIv0mduqwxmSG0+
wIAAn0xOqq3LV2FaI27cbpSPZemDO66d
=y5rI
-----END PGP SIGNATURE-----

--Apple-Mail-9--233967382--
