From: "Aymeric P." <aymeric@aplu.fr>
Subject: Re: mdadm RAID1 with 3 disks active on 2 disks configuration
Date: Mon, 24 Feb 2020 10:23:18 +0100
Message-ID: <CC9E4848-12C7-4DA3-9626-F083F20EF676@aplu.fr>
References: <4cf4cbe7-989e-d7ec-cad9-cfde022bd4bf@aplu.fr> <1f5e671c-8d41-695b-2bc4-74df85361e75@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1f5e671c-8d41-695b-2bc4-74df85361e75@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: antlists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



Le 23 f=C3=A9vrier 2020 21:40:44 GMT+01:00, antlists <antlists@youngman=2E=
org=2Euk> a =C3=A9crit :
>On 23/02/2020 17:38, Aymeric wrote:
>
>Because rebuilding sda is a lot of work=2E The sensible option would have
>
>been to leave sdb and sdc active, and left sda as spare=2E

Well, for some reason that didn't happen that way=2E=2E

>> I used the following command to add sda to the RAID1:
>> # mdadm=C2=A0 /dev/md0 --add /dev/sda3
>>
>>
>> What did I do wrong here? And how to fix it? Do I have to set sdc to
>> faulty and add it back?
>
>I'd just leave it as a 3-disk raid=2E But no, if you do want to set it=20
>back to a 2-disk raid don't do a "faulty and re-add" - that'll just
>make=20
>re-sync it again=2E

I would prefer to revert to sdc as a spare, it's a really a slow disk (540=
0rpm with a sata1 while others are 7200 at sata3)=2E For a spare disk it's =
good enough to give me time to get a new disk in case of failure but not fo=
r daily=2E

> Somehow you've got active devices set to 3, so just=20
>set that back to two=2E If you look on the wiki it covers the scenario of
>
>converting a three-disk raid to two=2E
>
>The only thing I will add about a 3-disk raid is that if you want to=20
>change it to anything else, you'll have to revert to 2 first, but do=20
>that when you want to change things, leave it at 3 for the moment=2E
>

So I tried with the --grow option to change the number disk in the array b=
ut it doesn't want to change=2E=2E=2E

# mdadm --grow /dev/md0 --raid-devices=3D2
mdadm: /dev/md0: no change requested
# mdadm --grow /dev/md0 --raid-devices=3D3
mdadm: Need 1 spare to avoid degraded array, and only have 0=2E
       Use --force to over-ride this check=2E

When looking with --examine, sdc3 is marked a replacement device=2E

# mdadm --examine /dev/sda3 /dev/sdb3 /dev/sdc3|grep 'dev\|Role\|State'
/dev/sda3:
          State : clean
   Device Role : Active device 1
   Array State : AR ('A' =3D=3D active, '=2E' =3D=3D missing, 'R' =3D=3D r=
eplacing)
/dev/sdb3:
          State : clean
   Device Role : Active device 0
   Array State : AR ('A' =3D=3D active, '=2E' =3D=3D missing, 'R' =3D=3D r=
eplacing)
/dev/sdc3:
          State : clean
   Device Role : Replacement device 1
   Array State : AR ('A' =3D=3D active, '=2E' =3D=3D missing, 'R' =3D=3D r=
eplacing)

Thanks,
Aymeric
--=20
Aymeric P=2E
Phone: +33 685 674 843
