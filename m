From: sylvain.depuille@laposte.net
Subject: =?utf-8?Q?Re:_Re=C2=A0:_Re:_Big_trouble_during_reassemble_a_Raid5?=
Date: Wed, 31 Dec 2014 18:59:29 +0100 (CET)
Message-ID: <480970436.16926591.1420048769566.JavaMail.zimbra@laposte.net>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net> <21667.5112.568800.563410@quad.stoffel.home> <367813595.16604641.1420034830100.JavaMail.zimbra@laposte.net> <21668.1236.130012.995660@quad.stoffel.home> <2050225023.16668598.1420037480502.JavaMail.zimbra@laposte.net> <21668.8063.635941.184463@quad.stoffel.home> <A6F7476D-8314-480D-B6B5-F84FF1F0960B@laposte.net> <21668.12775.212408.482021@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21668.12775.212408.482021@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi John,

I do the summary of disk and states :
/dev/sdb : 1TB : OK
/dev/sdc : 1TB : ??
/dev/sdd : 2TB : ddrescued
/dev/sde : 3TB : Not synchronized

Something is wrong in this list.
It seems that i have remove a wrong disk.

I should investigate with my friends tomorrow evening for us, afternoon=
 for you.
I will on the road tomorrow.
And it is may be free for you?

I wish you a good eve for this evening, and see you next year ;-).

Best Regards
Sylvain Depuille
=20
----- Mail original -----=20
De: "John Stoffel" <john@stoffel.org>=20
=C3=80: "Sylvain Depuille" <sylvain.depuille@laposte.net>=20
Cc: "John Stoffel" <john@stoffel.org>=20
Envoy=C3=A9: Mercredi 31 D=C3=A9cembre 2014 18:27:03=20
Objet: Re: Re: Re : Re: Big trouble during reassemble a Raid5=20


Sylvain> But the missing disk is the rescued disk!=20

I understand that, but we're looking to get the RAID5 up and working=20
again, but the event count looks wrong on that disk, so it shouldn't=20
be used to re-assemble the array.=20

There is going to be some data loss here, but let's minimize it and=20
get the array going again.=20

Sylvain> And the 3TB should be rebuild, because i have change It just=20
Sylvain> before the issue :-(sorry iPhone in French)=20

I think it's ok, since the other three disks have matching event=20
counts. It's the /dev/sdc1 that's behind the rest, so it needs to be=20
excluded at first.=20

Try it out and let me know.=20


Sylvain> I haven't mailings list in copy because html :-(=20
Sylvain> If necessary i Will revend the mail from House!=20

Sylvain> Best Regards=20
Sylvain> Sylvain Depuillr=20

Sylvain> Envoy=C3=A9 depuis un telephone portable=20

>> Le 31 d=C3=A9c. 2014 =C3=A0 17:08, John Stoffel <john@stoffel.org> a=
 =C3=A9crit :=20
>>=20
>>=20
sylvain> It's my fault too, because the mailing list doesn't accept=20
sylvain> HTML format. And my provider doesn't offer plain text option=20
sylvain> with the mobile site :-(=20
>>=20
>> It's a total pain at times. I'm still reading email with plain ascii=
=20
>> most of the time, I don't care for HTML email generally since it jus=
t=20
>> gets in the way.=20
>>=20
sylvain> Back to the issue :=20
>>=20
sylvain> I have stop the raid.=20
sylvain> mdadm --stop /dev/md2=20
sylvain> mdadm: stopped /dev/md2=20
>>=20
sylvain> cat /proc/mdstat=20
sylvain> Personalities : [raid1] [raid6] [raid5] [raid4]=20
sylvain> unused devices: <none>=20
>>=20
sylvain> And when i try to re-assemble, the command is aborting :=20
sylvain> mdadm --assemble --force /dev/md2 /dev/sd[bcde]1=20
sylvain> mdadm: /dev/md2 assembled from 2 drives and 1 spare - not enou=
gh to start the array.=20
>>=20
>> So if I look at the event counts, there's a mismatch between=20
>> /dev/sd[bde]1 and /dev/sdc1. So let's try to assemble without /dev/s=
dc1:=20
>>=20
>> mdadm -vv --assemble --force /dev/md2 /dev/sdb1 missing /dev/sdd1 /d=
ev/sde1=20
>>=20
>> and see what happens then. With three out of the four devices, the=20
>> RAID5 array should start up, and then you can add in /dev/sdc1 to=20
>> rebuild the parity.=20
>>=20
>> John=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
