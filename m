From: sylvain.depuille@laposte.net
Subject: =?utf-8?Q?Re:_Re=C2=A0:_Re:_Big_trouble_during_reassemble_a_Raid5?=
Date: Sun, 4 Jan 2015 19:16:32 +0100 (CET)
Message-ID: <725699046.23667592.1420395392686.JavaMail.zimbra@laposte.net>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net> <21668.8063.635941.184463@quad.stoffel.home> <A6F7476D-8314-480D-B6B5-F84FF1F0960B@laposte.net> <21668.12775.212408.482021@quad.stoffel.home> <480970436.16926591.1420048769566.JavaMail.zimbra@laposte.net> <21668.19044.575022.311461@quad.stoffel.home> <1476942476.18574241.1420136514556.JavaMail.zimbra@laposte.net> <21670.6532.641717.517799@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21670.6532.641717.517799@quad.stoffel.home>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

the raid is completly operationnal.

I take linux up to date with emerge Gentoo stable each day or each week=
=2E

I know the attribute pv_timeout on SAN with HP-UX, but not with Linux.
I haven't find the discussion over this point with Google.
Could you help me to find the thread on that?

PS: could i write what's your explain me on my wiki http://wiki.depuill=
e.net/index.php/Accueil (it's a French Unix tricks/memorendum Wiki)?

Thank's in advance.
Best Regards
Sylvain Depuille

----- Mail original -----=20
De: "John Stoffel" <john@stoffel.org>=20
=C3=80: "sylvain depuille" <sylvain.depuille@laposte.net>=20
Cc: "John Stoffel" <john@stoffel.org>, linux-raid@vger.kernel.org=20
Envoy=C3=A9: Vendredi 2 Janvier 2015 05:07:32=20
Objet: Re: Re: Re : Re: Big trouble during reassemble a Raid5=20


sylvain> Happy New Year and received all my best wishes for 2015. i'm=20
sylvain> back to home.=20

Me too, but heading to bed soon, been a busy day here.=20

sylvain> Now, the failed raid is at 700km (~400 miles) :-( I should=20
sylvain> work only by phone and ssh to repair the Raid.=20

It sucks having to work at a distance like this.=20

sylvain> We have changed the right disk and the raid is rebuilding. I=20
sylvain> wille write you when it's finished. Many many thank's for=20
sylvain> your help and your patience.=20

My real suggestion to you is to now collect all the information you=20
can on the system, including drive serial numbers, and how they map to=20
each device and member of the RAID array. Sometimes when a system=20
reboots, or you add new disks, things get re-arranged and you don't=20
notice at first. And that leads you down the wrong path quite=20
quickly.=20

sylvain> I have a question to migrate Raid 5 to Raid 6 :=20

sylvain> This site=20
sylvain> http://www.ewams.net/?date=3D2013/05/02&view=3DConverting_RAID=
5_to_RAID6_in_mdadm=20
sylvain> describe the right cookbook? I don't want re-do this bad=20
sylvain> Story.=20

It looks right to me. But I would also suggest that you look through=20
the archives of this list, and make sure you have a newer version of=20
the mdadm tool before you try to do this.=20

I would also suggest that you add two new disks, one to be used as a=20
hot spare, and the other used to grow the array into a RAID6.=20

Then go through and make sure that all your drive timeouts are set=20
properly on system boot, so that if a disk hangs when trying to=20
re-read a bad block, it won't cause it to be kicked out of the array=20
too quickly. Again, check the recent archives (last three months of=20
2014) of the list for examples and discussions of this issue.=20

Good luck!=20
John=20


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
