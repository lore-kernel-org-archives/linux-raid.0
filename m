From: Neil Brown <nfbrown@novell.com>
Subject: Re: RAID6 grow unexpected results
Date: Fri, 23 Oct 2015 09:37:05 +1100
Message-ID: <87io5yzg1a.fsf@notabene.neil.brown.name>
References: <CAPE0SYz97qwHaQjgguZbQ3rdxKZjDdS9sg5F5dy10W3GP=U3+w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPE0SYz97qwHaQjgguZbQ3rdxKZjDdS9sg5F5dy10W3GP=U3+w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Liwei <xieliwei@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain

Liwei <xieliwei@gmail.com> writes:

> Hi list,
>     I tried growing a RAID6 array by executing the mdadm --add and
> mdadm --grow --raid-devices commands. Usually that should run fine and
> I can continue with pvresize.

That is incorrect.  You cannot run "pvresize" until the reshape
completes.

>
>     This time however, the actual usable raid array size did not
> change even though reshape begins. In my confusion, I decided to
> reboot. That didn't solve the problem (and apparently the reshape was
> interrupted, but mdadm shows the grown array as clean?)

Clean is expected.  It will be in an intermediate state, part has
reshaped to extra devices, part is still the original.

>
>     I then executed mdadm --grow --size=max, which seemed to have
> increased the array size, but apparently by too much. Now I'm getting
> "attempt to access beyond end of device" errors for each of the
> component drives. A new reshape operation has also begun, which I
> expect would fail as the array size is now too big.

"--size" isn't the same as "--array-size".
"--size" is the size of the component devices to use.

The "attempt to access beyond end of device" errors are unexpected but
presumably related o the "--size=max".  Maybe the 'max' chosen was too
large.  That suggests a bug somewhere.
You probably want to reduce that size back to where it was.

>
>     What did I do wrong and how can I remedy this?

Could we start with "mdadm --examine" status of all devices, "mdadm
--detail" of the array, and all kernel messages that could possibly
relate to the array since you first started this exercise?

NeilBrown

>
> Liwei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWKWUSAAoJEDnsnt1WYoG5ncIQALdIgdPSf3qsyLbPQ7dk0QY3
hDDZFyIJLdizNKVDV2L64nU8WdCeO5WPsZhIpz9liheFdm2eDkFwtROyqXcXgqpS
W9Ts7mvnExBJfdtxwIwZ/MWCXUbxuRPCjYJR9p8FuCqQuhtymLs+0WdVKkuGiwK0
Vo/jXAx76kpPu3awlR8YnL+6KGpOxzb9k8YY5wPAspcHxjqxOobpgjEU3BmESBvA
eA0qMJrO+oFGk9XwFqW20n2x+4b4WsAe4WGvXcE5tSH542iAbBwJ2h9k/Z1KDJM/
UcJiUtjk7Vgx30FsLL/xjJyMgSEAd4oZ/UxO+n09A9Hcarzz6E6IHDrsMKpakH7W
t7S9h/ND7F3l0jKSsUW9z2ISbA+eSs0EteioNskCbRu7XvJA5b7gAkrJ0XA2nN0g
eaHl/MWXuihcdFGOvoA+9B8XgjdDcum+2agsBS7e/F1EHPJkmfYP/AJpowZS+GMX
bpsaMEKneS5vZOAm+YdI7Nc2kRO3mYDnnf2o9+ubqzjciA9pG3BoDvnLgvfujXkR
FDDNGz8HSP4bT3bw/AwJg88crx0mJr6N0Y8gx/ev3d2mWP2j5mnL0ki5SqWRNaR1
JQZ1strvhrg4otVBo84jCS/wsFA+PFhxZ/P+P+o15xogyk0xGoBuB1+Z8coxmKKa
tZj2meK90bm06E1SRPQO
=Yhqy
-----END PGP SIGNATURE-----
--=-=-=--
