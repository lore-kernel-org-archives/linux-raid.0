From: Tomka Gergely <tomka@avaxio.net>
Subject: Re: spare group
Date: Tue, 12 Jun 2007 08:34:00 +0200
Message-ID: <466E3E58.8050105@avaxio.net>
References: <466D51EE.7030509@avaxio.net> <18029.57132.285522.284156@notabene.brown>
Reply-To: tomka@avaxio.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18029.57132.285522.284156@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Linux, Raid lista" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown =EDrta:
> On Monday June 11, tomka@avaxio.net wrote:
>> ARRAY /dev/md1 level=3Draid5 devices=3D/dev/sd[defg]1 num-devices=3D=
3=20
>> spares=3D1 spare-group=3Dubul name=3Dursula:T2=20
>> UUID=3Dfb8ece28:9a6a31f8:700f37f6:7ee91bcf
>> ARRAY /dev/md0 level=3Draid5 devices=3D/dev/sd[abc]1 num-devices=3D3=
=20
>> spare-group=3Dubul name=3Dursula:T1 UUID=3D3e420024:281f9bb1:fd9ef39=
b:c18153b1
>=20
> You don't want the "devices=3D" entries in there.  If you leave them
> there, and sdg1 does get moved to md0, then on the next restart, md0
> won't get assembled properly.

Thanks.

>> According to the source:
>>
>> * If an array has active < raid && spare =3D=3D 0 && spare_group !=3D=
NULL
>> * Look for another array with spare > 0 and active =3D=3D raid and s=
ame=20
>> spare_group
>> * if found, choose a device and hotremove/hotadd
>>
>> This is not happening. What is my mistake?
>=20
> Is "mdadm --monitor" running?  That is required to perform
> spare-migration.

Yes, of course.

tg
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
