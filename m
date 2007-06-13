From: Tomka Gergely <tomka@avaxio.net>
Subject: Re: spare group
Date: Wed, 13 Jun 2007 09:25:44 +0200
Message-ID: <466F9BF8.9000101@avaxio.net>
References: <466D51EE.7030509@avaxio.net>	<18029.57132.285522.284156@notabene.brown>	<466E3E58.8050105@avaxio.net>	<18030.17507.290572.911043@notabene.brown>	<466E5206.20200@avaxio.net> <18030.27988.798462.933425@notabene.brown>
Reply-To: tomka@avaxio.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18030.27988.798462.933425@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: "Linux, Raid lista" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown =EDrta:
> On Tuesday June 12, tomka@avaxio.net wrote:
>> I am very sorry, but it wont works with .9 superblocks also :( We=20
>> missing something small, but important here. Before you start to cod=
e.=20
>> mdadm was running in monitor mode, and reported a Fail. mdadm is the=
=20
>> latest version, 2.6.2.
>>
>> tg
>=20
> Hmmm.....=20
> [tests code]
>=20
> Yes, you are right.  It looks like a bug was introduced in 2.6 which
> broke various aspects of --monitor.  I guess I need to add some
> --monitor tests to my regression test suite.
>=20
> This patch should fix it.
>=20
> Thanks again,
> NeilBrown

Thanks, the patch is working.

tg
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
