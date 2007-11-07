From: =?UTF-8?B?QkVSVFJBTkQgSm/Dq2w=?= <joel.bertrand@systella.fr>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Wed, 07 Nov 2007 12:20:25 +0100
Message-ID: <47319F79.8060002@systella.fr>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>	 <18222.16003.92062.970530@notabene.brown>	 <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>	 <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>	 <Pine.LNX.4.64.0711051335450.11422@p34.internal.lan>	 <e9c3a7c20711051619u7054aab9l208b604b9e58fb61@mail.gmail.com>	 <47303FB8.7000801@systella.fr> <1194398700.2970.18.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1194398700.2970.18.camel@dwillia2-linux.ch.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, Jeff@lessem.org
List-Id: linux-raid.ids

Dan Williams wrote:
> On Tue, 2007-11-06 at 03:19 -0700, BERTRAND Jo=C3=ABl wrote:
>>         Done. Here is obtained ouput :
>=20
> Much appreciated.
>> [ 1260.969314] handling stripe 7629696, state=3D0x14 cnt=3D1, pd_idx=
=3D2 ops=3D0:0:0
>> [ 1260.980606] check 5: state 0x6 toread 0000000000000000 read 00000=
00000000000 write fffff800ffcffcc0 written 0000000000000000
>> [ 1260.994808] check 4: state 0x6 toread 0000000000000000 read 00000=
00000000000 write fffff800fdd4e360 written 0000000000000000
>> [ 1261.009325] check 3: state 0x1 toread 0000000000000000 read 00000=
00000000000 write 0000000000000000 written 0000000000000000
>> [ 1261.244478] check 2: state 0x1 toread 0000000000000000 read 00000=
00000000000 write 0000000000000000 written 0000000000000000
>> [ 1261.270821] check 1: state 0x6 toread 0000000000000000 read 00000=
00000000000 write fffff800ff517e40 written 0000000000000000
>> [ 1261.312320] check 0: state 0x6 toread 0000000000000000 read 00000=
00000000000 write fffff800fd4cae60 written 0000000000000000
>> [ 1261.361030] locked=3D4 uptodate=3D2 to_read=3D0 to_write=3D4 fail=
ed=3D0 failed_num=3D0
>> [ 1261.443120] for sector 7629696, rmw=3D0 rcw=3D0
> [..]
>=20
> This looks as if the blocks were prepared to be written out, but were
> never handled in ops_run_biodrain(), so they remain locked forever.  =
The
> operations flags are all clear which means handle_stripe thinks nothi=
ng
> else needs to be done.
>=20
> The following patch, also attached, cleans up cases where the code lo=
oks
> at sh->ops.pending when it should be looking at the consistent
> stack-based snapshot of the operations flags.

	Thanks for this patch. I'm testing it for three hours. I'm rebuilding =
a=20
1.5 TB raid1 array over iSCSI without any trouble.

gershwin:[/usr/scripts] > cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md7 : active raid1 sdi1[2] md_d0p1[0]
       1464725632 blocks [2/1] [U_]
       [=3D>...................]  recovery =3D  6.7% (99484736/14647256=
32)=20
finish=3D1450.9min speed=3D15679K/sec

Without your patch, I never reached 1%... I hope it fix this bug and I=20
shall come back when my raid1 volume shall be resynchronized.

	Regards,

	JKB
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
