From: "Majed B." <majedb@gmail.com>
Subject: Re: e2fsck + RAID-5 disk fail test question
Date: Tue, 15 Dec 2009 06:39:03 +0300
Message-ID: <70ed7c3e0912141939v48e59cbboaab04124f2936575@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C087E7906@SDCEXCHANGE01.ad.amcc.com>
	<AC5E1C3367E37D44970B81A6ADD1DA2C087E791D@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C087E791D@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The errors on the filesystem are not related to the RAID setup nor the
failure. You might have had those errors while the array was working.

I suggest you install smartmontools and run smartctl -a /dev/sdx on
each disk on the array and see if you have ATA or CRC errors. These
indicate cable issues usually. SECTOR errors indicate physical damage
on the disk (bad sectors).

On Tue, Dec 15, 2009 at 2:09 AM, Tirumala Reddy Marri <tmarri@amcc.com>=
 wrote:
> To be more specific. Is it ok to see error during e2fcsk test after t=
he
> disk forced to fail in RAID-5.
> Regards,
> Marri
>
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Tirumala Reddy
> Marri
> Sent: Monday, December 14, 2009 2:44 PM
> To: linux-raid@vger.kernel.org
> Subject: e2fsck question
>
>
> All,
> =C2=A0My question is , after disk force to fail in RAID-5 is it ok to=
 see
> i-node errors during e2fsck check to see if there are errors and fix
> them ?
>
> Here is in detail what I did.
> =C2=A0I have RAID-5 setup with 4 drives. This using PowerPC based SOC=
 with
> XOR acceleration. I was testing the RAID-5 disk fail test using "mdad=
m
> -f /dev/sda /dev/md0". =C2=A0I installed Ext-3 file system on /dev/md=
0 then
> ran a "dd" command to do the traffic test. Then I fail the driver. Af=
ter
> few seconds I unmounted the drive and ran "e2fsck -c /dev/md0" to che=
ck
> the consistency. =C2=A0I see there e2fcsk complains that there is som=
e
> insistency in inodes, block etc and they it says it is correcting it.
>
>
> If there are file system inconsistencies and got repaired, you think
> there is problem with my setup ?
>
> Thanks and Regards,
> Marri
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>



--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
