From: Neil Brown <nfbrown@novell.com>
Subject: Re: RAID6 grow unexpected results
Date: Fri, 23 Oct 2015 18:15:31 +1100
Message-ID: <87pp06xdgs.fsf@notabene.neil.brown.name>
References: <CAPE0SYz97qwHaQjgguZbQ3rdxKZjDdS9sg5F5dy10W3GP=U3+w@mail.gmail.com> <87io5yzg1a.fsf@notabene.neil.brown.name> <CAPE0SYwiCn7L4iDKXS92pLz6JSLaXVdxggj-kE_bDDFM8w-ppg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPE0SYwiCn7L4iDKXS92pLz6JSLaXVdxggj-kE_bDDFM8w-ppg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Liwei <xieliwei@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Liwei <xieliwei@gmail.com> writes:

> On Fri, 23 Oct 2015 at 06:37 Neil Brown <nfbrown@novell.com> wrote:
>>
>> Liwei <xieliwei@gmail.com> writes:
>>
>> > Hi list,
>> >     I tried growing a RAID6 array by executing the mdadm --add and
>> > mdadm --grow --raid-devices commands. Usually that should run fine and
>> > I can continue with pvresize.
>>
>> That is incorrect.  You cannot run "pvresize" until the reshape
>> completes.
>
>
> Ah, my bad. It's been a while since I did that. So if I had been
> patient, all would have been well?
>
>>
>>
>> >
>> >     This time however, the actual usable raid array size did not
>> > change even though reshape begins. In my confusion, I decided to
>> > reboot. That didn't solve the problem (and apparently the reshape was
>> > interrupted, but mdadm shows the grown array as clean?)
>>
>> Clean is expected.  It will be in an intermediate state, part has
>> reshaped to extra devices, part is still the original.
>>
>> >
>> >     I then executed mdadm --grow --size=max, which seemed to have
>> > increased the array size, but apparently by too much. Now I'm getting
>> > "attempt to access beyond end of device" errors for each of the
>> > component drives. A new reshape operation has also begun, which I
>> > expect would fail as the array size is now too big.
>>
>> "--size" isn't the same as "--array-size".
>> "--size" is the size of the component devices to use.
>>
>> The "attempt to access beyond end of device" errors are unexpected but
>> presumably related o the "--size=max".  Maybe the 'max' chosen was too
>> large.  That suggests a bug somewhere.
>> You probably want to reduce that size back to where it was.
>
>
> I just realised I got the wrong command. I used --array-size=max
> instead. A reboot seemed to have reverted the change.
>
>>
>>
>> >
>> >     What did I do wrong and how can I remedy this?
>>
>> Could we start with "mdadm --examine" status of all devices, "mdadm
>> --detail" of the array, and all kernel messages that could possibly
>> relate to the array since you first started this exercise?
>
>
> Eventually it was a foul up on my part. Things seem to be back to
> normal after a reboot, and the reshape is in progress. Apologies for
> the confusion!

Good to know that thing are working - thanks.

NeilBrown

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKd6UAAoJEDnsnt1WYoG5SicQAJnSyr7TIv1mFES+SvDUaVAi
uB5dePu02b/w8nUwkyyNIyixL/7VUmFRzi6M4UVWH4RCk124XVA8bu0MGkkcQMiO
S52I/PbCCUbZD3QLTtv1mXjHnwpiyY7HOvrySTBjTL/8hTONOBbtnrpTjRa/IZKN
i8W2QRFoT4oaxyNX7d9dw/Yp962bby/+h66trRiPrLdGPk4IYBdkN+Lbjn3da/pi
o8tEDHgZJx/wO874HuI3rO2ztmWuEr3jh/Ky7Ue5VGvi1gsaf3PMqHLmkuzPg/fj
6ueNX0RnHHYE2j0yCXG8yBKJ8AaC84QNpZDIJoDKdFB4dkm4zg6msWhKZAwHLp+F
1WUipi2uTdvQ15g+2sE+9uyvfAMboDoLRPnSVy/yGGPyCzb5rZRNUuEy8o32gnVJ
guyIRBPVyCll8bub0RcPP98ZzrAE+SRCPpayk/R88dJmfaJv8omeMGbPQl5oI0EY
aPUcVYAmlJ3QJpUrxIxVe8F7qX5yyr3Xg0tqQnDVeSmRSqdqrEDmr/KksM/OeMoW
ioamXMCTzhbqvTALO3rMYJwT1jTA5XIFeYdzArcYWo3fKcoeZw+oNOACXbsNWtUp
zYVZAYJtCceUlyRVJ61WelfMz+i2t+p6qRgSZekmX7D2rB9vBwt6tZWgF/G4ueXR
XemX0bPW9mtCvs6bKoQD
=mztb
-----END PGP SIGNATURE-----
--=-=-=--
