From: Andriano <chief000@gmail.com>
Subject: Re: RAID6 issues
Date: Tue, 13 Sep 2011 20:44:52 +1000
Message-ID: <CAGZH0-d9HYXsOcu+dsrLaSKK6am_EBe9wv5Z_-vMOAB7ZQhxgw@mail.gmail.com>
References: <CAGZH0-dz9y5=vH7PQr8VRy15i1WsuAxKjPPpmx8-1UqCaJnRxg@mail.gmail.com>
	<20110913082511.3c34dec9@notabene.brown>
	<CAGZH0-fEU+NTdAF1AWcU6SnyBPYgd51zjizaiZT_toV=k4EDFg@mail.gmail.com>
	<20110913084419.380babcc@notabene.brown>
	<CAGZH0-fRTkKOL8ofLbChmNH3fuiYwHkC0LAv1-VVyb22O7UnwA@mail.gmail.com>
	<20110913093850.606efa70@notabene.brown>
	<CAGZH0-f+e80W36VMZMHrTakTxUHO2nppO9xHSTmHh6QV_Mo2Fg@mail.gmail.com>
	<20110913144424.64348c41@natsu>
	<CAGZH0-eAynK17a-B=x-pKHXpN8K+tDNb7cOYqa3M1ThhyvB=4g@mail.gmail.com>
	<CAGZH0-fYrC91=kBMxO3FKKtY0Zmnx4D4+-DD43cbHVNhc2pp3A@mail.gmail.com>
	<20110913162951.6b4297db@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110913162951.6b4297db@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks everyone, looks like the problem is solved.

=46or benefit of others who may experience same issue, here is what I'v=
e done:

- upgraded firmware on ST32000542AS disks - from CC34 to CC35. It must
be done using onboard SATA in Native IDE (not RAID/AHCI) mode.
After reconnecting them back to HBA, size of one of the offenders fixed=
 itself!

- ran hdparm -N p3907029168 /dev/sdx command on other two disks and it
worked (probably it works straight after reboot)
Now mdadm -D shows the array as clean, degraded with one disk kicked
out, which is another story :)

now need to resync array and restore two LVs which hasn't mounted :(

On Tue, Sep 13, 2011 at 8:29 PM, Roman Mamedov <rm@romanrm.ru> wrote:
> On Tue, 13 Sep 2011 19:05:41 +1000
> Andriano <chief000@gmail.com> wrote:
>
>> Connected one of the offenders to HBA port, and hdparm outputs this:
>>
>> #hdparm -N /dev/sdh
>>
>> /dev/sdh:
>> =A0max sectors =A0 =3D 3907027055/14715056(18446744073321613488?), H=
PA
>> setting seems invalid (buggy kernel device driver?)
>
> You could just try "hdparm -N p3907029168" (capacity of the 'larger' =
disks), but that could fail if the device driver is indeed buggy.
>
> Another possible course of action would be to try that on some other =
controller.
> For example on your motherboard you have two violet ports, http://www=
=2Egigabyte.ru/products/upload/products/1470/100a.jpg
> those are managed by the JMicron JMB363 controller, try plugging the =
disks which need HPA to be removed to those ports, AFAIR that JMicron c=
ontroller works with "hdparm -N" just fine.
>
> --
> With respect,
> Roman
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
