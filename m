From: NeilBrown <nfbrown@novell.com>
Subject: Re: Rewrite md raid1 member
Date: Sat, 20 Aug 2016 16:52:46 +1000
Message-ID: <87h9aggce9.fsf@notabene.neil.brown.name>
References: <20160818030451.GA17225@onthe.net.au> <2dca8e1f-8e80-408f-900e-36f9b1dd6f95@fnarfbargle.com> <20160818040151.GA21256@onthe.net.au> <57B6F2F5.8090800@youngman.org.uk> <20160819124615.GA23247@onthe.net.au> <87oa4oh2m4.fsf@notabene.neil.brown.name> <20160820015708.GB30642@onthe.net.au>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160820015708.GB30642@onthe.net.au>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Cc: Wols Lists <antlists@youngman.org.uk>, Brad Campbell <lists2009@fnarfbargle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sat, Aug 20 2016, Chris Dunlop wrote:

> Hi Neil,
>
> Nice work on the Bus1 article!

Thanks :-)

>
> On Sat, Aug 20, 2016 at 07:26:27AM +1000, NeilBrown wrote:
>> On Fri, Aug 19 2016, Chris Dunlop wrote:
>>> In my case, I want it to write everything.
>>>
>>> If I do my 'dd' to write everything as previously described, with the w=
indow
>>> of opportunity for stale data to end up on the written disk, one option
>>> would to run a scrub / repair to check the data is the same - but if I'm
>>> unlucky with my dd and the data isn't the same for some sector[s], I wa=
nt to
>>> ensure the correct data is copied over the stale data and not the other=
 way
>>> around, e.g. to specify "in the event of a mismatch, use the data from =
sda
>>> and overwrite the data on sdb".
>>>
>>> Unfortunately I don't know how that can be done.
>>>
>>> Does anyone know?
>>=20
>> If it is the second device in the array (as listed by mdadm --detail)
>> then you can stop the array and re-assemble with --update=3Dresync.
>
> That's nearly there - except in this specific case it's my root filesystem
> so I can't stop the array without booting into a recovery disk etc. Of
> course I could do that, but the point of the exercise is to see if it can
> be done live, safely.

Well... you could
  cd /sys/block/mdXX/md
  echo frozen > sync_action
  echo 0 > resync_start
  echo idle > sync_action

that should start a resync on a live array.
Still, only works for non-first device in RAID1

>
>> If it is the first device I can only suggest that you
>> fail the device and add it again:
>>=20
>>  mdadm /dev/mdXX --fail /dev/sdYY
>>  mdadm /dev/mdXX --remove /dev/sdYY
>>  mdadm /dev/mdYY --add /dev/sdYY
>>=20
>> If the "good" drive fails during the rewrite it might be a little bit
>> fiddley getting the array working again, but all the data will certainly
>> be there on the device you are re-writing, so you won't lose anything.
>
> OK, that sounds good. What would the process be if the good drive fails,
> either completely, or a few specific sectors?

If you think there is a serious risk of that happening, then it's best
to skip this option.
You would need to boot from a rescue disk and re-create the array using
just the working device - and make sure the same data-offset and size
are used.  Certainly possible, but not at all straightforward.

Another thing you could do, particularly if you know what region of the
device needs to be over-written, is to write sector numbers to
suspend_lo and suspend_hi.  This will suspend all IO through the
/dev/mdXX device to that range of array sectors.
Then you could read from/write to the raw device with dd or whatever.

raid6check.c does this on a raid6 to correct errors that can be detected
with the raid6 syndrome, even while the array is online.  A similar
thing could be done to allow individual blocks to be rewritten.
Care is needed to map between array addresses and device addresses.

NeilBrown



--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJXt/4+AAoJEDnsnt1WYoG5FiQP/AxI3JxOyRsMbf35aJrqId57
yORNUifFi4F9N8YcirsWfIcvGox2i0XylB1l2a1HzF7+uzBeD16nBFT0bFcS2aaN
nlpT5206pmv3LIDZETaorZ/B+hnzgPNjcAzko28ZiT0kU2NJvDg043nRHYv3hXG8
Hqo/1b8YjESBwFkOfN3H2ysYawYZE+zedUpS5SFBFfcF2uukeFlPTlozTLaETUog
pywticCf7A0pUouwLZTDRpOp2hpcRpZ2GMwOAYbFQ27Ezk9Wu/YoY9l56WKBGHFU
sTSfvzbXNLcgVFM0GuaXSNFhnuM3zJkFc6fiRnuYNWUiVgJCJFOLHnIFi0DSUcn3
ls3N4xd1kYPCFSb5Fnf93TOTX1qImmU65BnPqwwPzecu9FvMA8pMQrmGjzDOaewu
YKkwRMEZ4SZbssDQzTfAgoHFHdBU2AOPfIoophdYYBEsjJkJ/SCQBhTYLWnL9Ymu
G5qaIRWad5yul9O8oAQVpDpnTKu6SMDrL8v5EQVk2Dks8UalCYI2lx/VBUbNLb6x
zNGEBdQNFd6KDtgyVncveZwDHF3W6D3m6FgiW+d137jFurQZFMZmCuLhSA271CuO
Bbmz/qQysaoWDuGpAIZo6JoOeChGBwk0zN79hYKYiHtWRL9s8Ui56EosRRCNXrQY
TqP1iGHiaPLxw9emrGt6
=TRDH
-----END PGP SIGNATURE-----
--=-=-=--
