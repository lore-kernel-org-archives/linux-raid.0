From: sylvain.depuille@laposte.net
Subject: =?utf-8?Q?Re:_Re=C2=A0:_Re:_Big_trouble_during_reassemble_a_Raid5?=
Date: Thu, 1 Jan 2015 19:21:54 +0100 (CET)
Message-ID: <1476942476.18574241.1420136514556.JavaMail.zimbra@laposte.net>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net> <21668.1236.130012.995660@quad.stoffel.home> <2050225023.16668598.1420037480502.JavaMail.zimbra@laposte.net> <21668.8063.635941.184463@quad.stoffel.home> <A6F7476D-8314-480D-B6B5-F84FF1F0960B@laposte.net> <21668.12775.212408.482021@quad.stoffel.home> <480970436.16926591.1420048769566.JavaMail.zimbra@laposte.net> <21668.19044.575022.311461@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21668.19044.575022.311461@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
Happy New Year and received all my best wishes for 2015.
i'm back to home.
Now, the failed raid is at 700km (~400 miles) :-( I should work only by=
 phone and ssh to repair the Raid.
We have changed the right disk and the raid is rebuilding. I wille writ=
e you when it's finished.
Many many thank's for your help and your patience.
I have a question to migrate Raid 5 to Raid 6 :
This site http://www.ewams.net/?date=3D2013/05/02&view=3DConverting_RAI=
D5_to_RAID6_in_mdadm describe the right cookbook?
I don't want re-do this bad Story.

Thank's in advance.
Best Regards.
----------------------------------
Sylvain Depuille (Happy at this time).
sylvain.depuille@laposte.net

----- Mail original -----=20
De: "John Stoffel" <john@stoffel.org>=20
=C3=80: "sylvain depuille" <sylvain.depuille@laposte.net>=20
Cc: "John Stoffel" <john@stoffel.org>, linux-raid@vger.kernel.org=20
Envoy=C3=A9: Mercredi 31 D=C3=A9cembre 2014 20:11:32=20
Objet: Re: Re: Re : Re: Big trouble during reassemble a Raid5=20

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

It might be that is the problem. One thing to do is to run 'smartctl'=20
on all the disks and get the UUIDs/serial numbers so you can confirm=20
which disk is which.=20

The 'lsscsi' is also useful to help make sure you know which drives=20
are mapped to which drive letter, since they can move around. But if=20
you do get a chance, try what I suggested, which is to assemble with=20
just three of the drives. Maybe don't even hook up /dev/sdc1 at all=20
to the system.=20

sylvain> I should investigate with my friends tomorrow evening for us,=20
sylvain> afternoon for you. I will on the road tomorrow. And it is=20
sylvain> may be free for you?=20

I won't be around tomorrow afternoon, January 1st, I've got a birthday=20
party to attend. I'll try to be online at some point, but it's not=20
likely.=20

sylvain> I wish you a good eve for this evening, and see you next year =
;-).=20

Happy New Year to you and your friends and family as well! Enjoy! I=20
will talk with you in the new year for sure.=20


sylvain> ----- Mail original -----=20
sylvain> De: "John Stoffel" <john@stoffel.org>=20
sylvain> =C3=80: "Sylvain Depuille" <sylvain.depuille@laposte.net>=20
sylvain> Cc: "John Stoffel" <john@stoffel.org>=20
sylvain> Envoy=C3=A9: Mercredi 31 D=C3=A9cembre 2014 18:27:03=20
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

Sylvain> Envoy=C3=A9 depuis un telephone portable=20

>>> Le 31 d=C3=A9c. 2014 =C3=A0 17:08, John Stoffel <john@stoffel.org> =
a =C3=A9crit :=20
>>>=20
>>>=20
sylvain> It's my fault too, because the mailing list doesn't accept=20
sylvain> HTML format. And my provider doesn't offer plain text option=20
sylvain> with the mobile site :-(=20
>>>=20
>>> It's a total pain at times. I'm still reading email with plain asci=
i=20
>>> most of the time, I don't care for HTML email generally since it ju=
st=20
>>> gets in the way.=20
>>>=20
sylvain> Back to the issue :=20
>>>=20
sylvain> I have stop the raid.=20
sylvain> mdadm --stop /dev/md2=20
sylvain> mdadm: stopped /dev/md2=20
>>>=20
sylvain> cat /proc/mdstat=20
sylvain> Personalities : [raid1] [raid6] [raid5] [raid4]=20
sylvain> unused devices: <none>=20
>>>=20
sylvain> And when i try to re-assemble, the command is aborting :=20
sylvain> mdadm --assemble --force /dev/md2 /dev/sd[bcde]1=20
sylvain> mdadm: /dev/md2 assembled from 2 drives and 1 spare - not enou=
gh to start the array.=20
>>>=20
>>> So if I look at the event counts, there's a mismatch between=20
>>> /dev/sd[bde]1 and /dev/sdc1. So let's try to assemble without /dev/=
sdc1:=20
>>>=20
>>> mdadm -vv --assemble --force /dev/md2 /dev/sdb1 missing /dev/sdd1 /=
dev/sde1=20
>>>=20
>>> and see what happens then. With three out of the four devices, the=20
>>> RAID5 array should start up, and then you can add in /dev/sdc1 to=20
>>> rebuild the parity.=20
>>>=20
>>> John=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
