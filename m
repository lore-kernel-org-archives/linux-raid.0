From: =?UTF-8?B?VMOzdGggQ3NhYmE=?= <csaba.toth@i3rendszerhaz.hu>
Subject: Re: convert raid10 to raid0
Date: Thu, 08 Jul 2010 09:58:38 +0200
Message-ID: <4C35852E.5060400@i3rendszerhaz.hu>
References: <4C34D5AD.5020305@i3rendszerhaz.hu> <20100708085034.2bc8272e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100708085034.2bc8272e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010.07.08. 0:50 keltez=C3=A9ssel, Neil Brown =C3=ADrta:
> Then after you create the raid0, use the same command
>    mdadm -E /dev/sdc6
> to check the Data Offset again and make sure it is the same.
> I suspect it will be, so everything will be fine.
> However if it isn't don't try to access the array.   Post the details=
 and I'll
> figure out what to do next.
>=20

It doesn't work, and the data offsets are different (in the mean time i
figured out that i made a mistake, and not sdc6 but sdb6 is the other
correct device):

Old:
sdb6: 592 sectors
sdd6: 264 sectors

New:
sdb6: 2048 sectors
sdd6: 2048 sectors

if i modify the source code of the mdadm, but don't know how to make it
to set differently based on the partition..

thanks in advance!
Csaba
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
