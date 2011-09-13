From: Andriano <chief000@gmail.com>
Subject: Re: RAID6 issues
Date: Tue, 13 Sep 2011 23:45:35 +1000
Message-ID: <CAGZH0-fhAgK-ho6xK42jKJiAZrEGRn=babTVO2wUYAAAmiAJFA@mail.gmail.com>
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
	<CAGZH0-d9HYXsOcu+dsrLaSKK6am_EBe9wv5Z_-vMOAB7ZQhxgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGZH0-d9HYXsOcu+dsrLaSKK6am_EBe9wv5Z_-vMOAB7ZQhxgw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Still trying to get the array back up.

Status: Clean, degraded with 9 out of 10 disks.
One disk - removed as non-fresh.

as a result two of LVs could not be mounted:

mount: wrong fs type, bad option, bad superblock on /dev/mapper/vg0-lv1=
,
      missing codepage or helper program, or other error
      In some cases useful info is found in syslog - try
      dmesg | tail  or so

mount: wrong fs type, bad option, bad superblock on /dev/mapper/vg0-lv2=
,
      missing codepage or helper program, or other error
      In some cases useful info is found in syslog - try
      dmesg | tail  or so

[ 3357.006833] JBD: no valid journal superblock found
[ 3357.006837] EXT4-fs (dm-1): error loading journal
[ 3357.022603] JBD: no valid journal superblock found
[ 3357.022606] EXT4-fs (dm-2): error loading journal



Apparently there is a problem with re-adding non-fresh disk back to the=
 array.

#mdadm -a -v /dev/md0 /dev/sdf
mdadm: /dev/sdf reports being an active member for /dev/md0, but a
--re-add fails.
mdadm: not performing --add as that would convert /dev/sdf in to a spar=
e.
mdadm: To make this a spare, use "mdadm --zero-superblock /dev/sdf" fir=
st.

Question: Is there a way to resync the array using that non-fresh
disk, as it may contain blocks needed by these LVs.
At this stage I don't really want to add this disk as a spare.

Any suggestions please?


thanks

On Tue, Sep 13, 2011 at 8:44 PM, Andriano <chief000@gmail.com> wrote:
> Thanks everyone, looks like the problem is solved.
>
> For benefit of others who may experience same issue, here is what I'v=
e done:
>
> - upgraded firmware on ST32000542AS disks - from CC34 to CC35. It mus=
t
> be done using onboard SATA in Native IDE (not RAID/AHCI) mode.
> After reconnecting them back to HBA, size of one of the offenders fix=
ed itself!
>
> - ran hdparm -N p3907029168 /dev/sdx command on other two disks and i=
t
> worked (probably it works straight after reboot)
> Now mdadm -D shows the array as clean, degraded with one disk kicked
> out, which is another story :)
>
> now need to resync array and restore two LVs which hasn't mounted :(
>
> On Tue, Sep 13, 2011 at 8:29 PM, Roman Mamedov <rm@romanrm.ru> wrote:
>> On Tue, 13 Sep 2011 19:05:41 +1000
>> Andriano <chief000@gmail.com> wrote:
>>
>>> Connected one of the offenders to HBA port, and hdparm outputs this=
:
>>>
>>> #hdparm -N /dev/sdh
>>>
>>> /dev/sdh:
>>> =A0max sectors =A0 =3D 3907027055/14715056(18446744073321613488?), =
HPA
>>> setting seems invalid (buggy kernel device driver?)
>>
>> You could just try "hdparm -N p3907029168" (capacity of the 'larger'=
 disks), but that could fail if the device driver is indeed buggy.
>>
>> Another possible course of action would be to try that on some other=
 controller.
>> For example on your motherboard you have two violet ports, http://ww=
w.gigabyte.ru/products/upload/products/1470/100a.jpg
>> those are managed by the JMicron JMB363 controller, try plugging the=
 disks which need HPA to be removed to those ports, AFAIR that JMicron =
controller works with "hdparm -N" just fine.
>>
>> --
>> With respect,
>> Roman
>>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
