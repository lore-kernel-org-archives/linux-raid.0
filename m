From: NeilBrown <neilb@suse.com>
Subject: Re: Newly-created arrays don't auto-assemble - related to hostname change?
Date: Fri, 18 Nov 2016 14:02:34 +1100
Message-ID: <87poltfq2d.fsf@notabene.neil.brown.name>
References: <20161117035230.GG21587@bitfolk.com> <87lgwihc2v.fsf@notabene.neil.brown.name> <20161117150954.GH21587@bitfolk.com> <87d1hthgm7.fsf@notabene.neil.brown.name> <20161118023144.GC1804@bitfolk.com>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161118023144.GC1804@bitfolk.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andy Smith <andy@strugglers.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 18 2016, Andy Smith wrote:

> Hi Neil,
>
> On Fri, Nov 18, 2016 at 09:43:44AM +1100, NeilBrown wrote:
>> Something you could try, after boot and while the arrays are still not
>> assembled, is
>>=20
>>   echo change > /sys/block/sdc/uevent
>>   echo change > /sys/block/sdd/uevent
>>=20
>> That should cause udev to assemble the array.
>
> Nothing appeared to happen. There was nothing interesting in syslog
> or systemd's journal. Here's the output from "udevadm monitor":

OK, we are getting closer.  That is good.

>
> $ sudo udevadm monitor
> monitor will print the received events for:
> UDEV - the event which udev sends out after rule processing
> KERNEL - the kernel uevent
>
> KERNEL[12376.719100] change   /devices/pci0000:00/0000:00:01.0/0000:01:00=
.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc (block)
> UDEV  [12376.722996] change   /devices/pci0000:00/0000:00:01.0/0000:01:00=
.0/host10/port-10:0/end_device-10:0/target10:0:0/10:0:0:0/block/sdc (block)
> KERNEL[12388.329566] change   /devices/pci0000:00/0000:00:01.0/0000:01:00=
.0/host10/port-10:1/end_device-10:1/target10:0:1/10:0:1:0/block/sdd (block)
> UDEV  [12388.333441] change   /devices/pci0000:00/0000:00:01.0/0000:01:00=
.0/host10/port-10:1/end_device-10:1/target10:0:1/10:0:1:0/block/sdd (block)
>
>> If that doesn't work, the looking over the udev logs, and possibly
>> turning on extra udev logging, might lead to an answer.
>
> I don't know how to do that, but I'll look into it - thanks.

 udevadm control -l debug

might help.

NeilBrown

>
> Cheers,
> Andy

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIcBAEBCAAGBQJYLm9LAAoJEDnsnt1WYoG5bxIP/1TeRpzo0unixSaTrGTDDf/6
inq7QgdgaBHORJ4igUOR1RXazDQSQS7pxH3GxFpNrh5wRSoU9VeV0Cq5ZhQK4U0h
w+3aEQ/vvxZ6R35kjzk0itIuQvfFvWgaU1h8ZN3zxIIRL7zEvYJOJXp8YPjZI3p9
v40aOm+PfbKA8UNiuXvKHVHMRs6u3PKa/XusPRRKFk2ffKgDC/OZTXl7w7BUvt2N
zGANk5n68UEXJ4VaGh4W0u0Wc4HwYS6BtuoZS3wBpHk1+KQqtbYJ65zCLc9WtdmB
Hub7UlnXNyWuknRxUFvC+WtbynxVMfJN0IH4abBzbL0X7W5ff7OPatX7hneYBhmX
5vaEVgQUP2AU12mh5GeesKTSR/k22R12KDZWITv1MZ52IeifHwqiA7pDoTAPGkGb
3RoCujabKeKS8AwZBnk5E1CB4V0j3bq8/vdtP3l/ONymv5OM7qZY9pJL3kaGLATJ
y1xfAh+kBHv7Gd2Ylc3LaVQWn9eTJX5de+81PtMIUE8LAab2Ku9wMQ8PDXfRBKmL
jcSquq3rYddFemkLJPG/auPepCTEavyjPOeFd8KzMdjxYIRSI3OUdzKNUUEmptbi
nwtlRGuQfNWlKvzFno2ZJK7adLi4O7S1mB1d0e7UUWgmJSbdF9tDHkQx59nXFmlN
odPuhjbIUWYqox6jx0+j
=/nKp
-----END PGP SIGNATURE-----
--=-=-=--
