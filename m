From: "John Stoffel" <john@stoffel.org>
Subject: Re: Re: =?iso-8859-1?Q?Re=A0:?= Re: Big trouble during reassemble a Raid5
Date: Thu, 1 Jan 2015 23:01:50 -0500
Message-ID: <21670.6190.296786.873604@quad.stoffel.home>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net>
	<21668.1236.130012.995660@quad.stoffel.home>
	<2050225023.16668598.1420037480502.JavaMail.zimbra@laposte.net>
	<21668.8063.635941.184463@quad.stoffel.home>
	<A6F7476D-8314-480D-B6B5-F84FF1F0960B@laposte.net>
	<21668.12775.212408.482021@quad.stoffel.home>
	<480970436.16926591.1420048769566.JavaMail.zimbra@laposte.net>
	<21668.19044.575022.311461@quad.stoffel.home>
	<1490650580.18792702.1420146376741.JavaMail.zimbra@laposte.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1490650580.18792702.1420146376741.JavaMail.zimbra@laposte.net>
Sender: linux-raid-owner@vger.kernel.org
To: sylvain.depuille@laposte.net
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


sylvain> First good news of the year : the dirty Raid is online.

Awesome news!  A great start to the New Year.  And a happy new year to
you all. =20

sylvain> cat /proc/mdstat
sylvain> Personalities : [raid1] [raid6] [raid5] [raid4]=20
sylvain> md2 : active raid5 sdc1[3] sdd1[2] sde1[4] sdb1[5]
sylvain> 2930276352 blocks super 1.2 level 5, 512k chunk, algorithm 2 [=
4/4] [UUUU]
sylvain> bitmap: 0/8 pages [0KB], 65536KB chunk


sylvain> Many thank's for your help.

sylvain> Now, i have unmounted all filesystems and do e2fsck on all.

sylvain> With ext4, it's running very quickly, and no errors found. Is =
it reliable?
sylvain> But it's may be not your part? ;-)

You can force ext4 to do a more thorough check if you like with:

   fsck.ext4 -f /dev/....

and it will force a check, even if everything looks to be ok. =20

sylvain> Thank's in advance
sylvain> Best Regards

sylvain> Sylvain Depuille (Happy).

sylvain> ----- Mail original -----=20
sylvain> De: "John Stoffel" <john@stoffel.org>=20
sylvain> =C0: "sylvain depuille" <sylvain.depuille@laposte.net>=20
sylvain> Cc: "John Stoffel" <john@stoffel.org>, linux-raid@vger.kernel.=
org=20
sylvain> Envoy=E9: Mercredi 31 D=E9cembre 2014 20:11:32=20
sylvain> Objet: Re: Re: Re : Re: Big trouble during reassemble a Raid5=20

>>>>> "sylvain" =3D=3D sylvain depuille <sylvain.depuille@laposte.net> =
writes:=20

sylvain> Hi John,=20
sylvain> I do the summary of disk and states :=20
sylvain> /dev/sdb : 1TB : OK=20
sylvain> /dev/sdc : 1TB : ??=20
sylvain> /dev/sdd : 2TB : ddrescued=20
sylvain> /dev/sde : 3TB : Not synchronized=20

sylvain> Something is wrong in this list. It seems that i have remove=20
sylvain> a wrong disk.=20

sylvain> It might be that is the problem. One thing to do is to run 'sm=
artctl'=20
sylvain> on all the disks and get the UUIDs/serial numbers so you can c=
onfirm=20
sylvain> which disk is which.=20

sylvain> The 'lsscsi' is also useful to help make sure you know which d=
rives=20
sylvain> are mapped to which drive letter, since they can move around. =
But if=20
sylvain> you do get a chance, try what I suggested, which is to assembl=
e with=20
sylvain> just three of the drives. Maybe don't even hook up /dev/sdc1 a=
t all=20
sylvain> to the system.=20

sylvain> I should investigate with my friends tomorrow evening for us,=20
sylvain> afternoon for you. I will on the road tomorrow. And it is=20
sylvain> may be free for you?=20

sylvain> I won't be around tomorrow afternoon, January 1st, I've got a =
birthday=20
sylvain> party to attend. I'll try to be online at some point, but it's=
 not=20
sylvain> likely.=20

sylvain> I wish you a good eve for this evening, and see you next year =
;-).=20

sylvain> Happy New Year to you and your friends and family as well! Enj=
oy! I=20
sylvain> will talk with you in the new year for sure.=20


sylvain> ----- Mail original -----=20
sylvain> De: "John Stoffel" <john@stoffel.org>=20
sylvain> =C0: "Sylvain Depuille" <sylvain.depuille@laposte.net>=20
sylvain> Cc: "John Stoffel" <john@stoffel.org>=20
sylvain> Envoy=E9: Mercredi 31 D=E9cembre 2014 18:27:03=20
sylvain> Objet: Re: Re: Re : Re: Big trouble during reassemble a Raid5=20


Sylvain> But the missing disk is the rescued disk!=20

sylvain> I understand that, but we're looking to get the RAID5 up and w=
orking=20
sylvain> again, but the event count looks wrong on that disk, so it sho=
uldn't=20
sylvain> be used to re-assemble the array.=20

sylvain> There is going to be some data loss here, but let's minimize i=
t and=20
sylvain> get the array going again.=20

Sylvain> And the 3TB should be rebuild, because i have change It just=20
Sylvain> before the issue :-(sorry iPhone in French)=20

sylvain> I think it's ok, since the other three disks have matching eve=
nt=20
sylvain> counts. It's the /dev/sdc1 that's behind the rest, so it needs=
 to be=20
sylvain> excluded at first.=20

sylvain> Try it out and let me know.=20


Sylvain> I haven't mailings list in copy because html :-(=20
Sylvain> If necessary i Will revend the mail from House!=20

Sylvain> Best Regards=20
Sylvain> Sylvain Depuillr=20

Sylvain> Envoy=E9 depuis un telephone portable=20

>>>> Le 31 d=E9c. 2014 =E0 17:08, John Stoffel <john@stoffel.org> a =E9=
crit :=20
>>>>=20
>>>>=20
sylvain> It's my fault too, because the mailing list doesn't accept=20
sylvain> HTML format. And my provider doesn't offer plain text option=20
sylvain> with the mobile site :-(=20
>>>>=20
>>>> It's a total pain at times. I'm still reading email with plain asc=
ii=20
>>>> most of the time, I don't care for HTML email generally since it j=
ust=20
>>>> gets in the way.=20
>>>>=20
sylvain> Back to the issue :=20
>>>>=20
sylvain> I have stop the raid.=20
sylvain> mdadm --stop /dev/md2=20
sylvain> mdadm: stopped /dev/md2=20
>>>>=20
sylvain> cat /proc/mdstat=20
sylvain> Personalities : [raid1] [raid6] [raid5] [raid4]=20
sylvain> unused devices: <none>=20
>>>>=20
sylvain> And when i try to re-assemble, the command is aborting :=20
sylvain> mdadm --assemble --force /dev/md2 /dev/sd[bcde]1=20
sylvain> mdadm: /dev/md2 assembled from 2 drives and 1 spare - not enou=
gh to start the array.=20
>>>>=20
>>>> So if I look at the event counts, there's a mismatch between=20
>>>> /dev/sd[bde]1 and /dev/sdc1. So let's try to assemble without /dev=
/sdc1:=20
>>>>=20
>>>> mdadm -vv --assemble --force /dev/md2 /dev/sdb1 missing /dev/sdd1 =
/dev/sde1=20
>>>>=20
>>>> and see what happens then. With three out of the four devices, the=
=20
>>>> RAID5 array should start up, and then you can add in /dev/sdc1 to=20
>>>> rebuild the parity.=20
>>>>=20
>>>> John=20
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
