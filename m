From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Can't start array and Negative "Used Dev Size"
Date: Tue, 28 Jun 2011 22:24:41 -0700
Message-ID: <BANLkTimonHoSn5eoX9AB8wLJYR4SFoBd-w@mail.gmail.com>
References: <BANLkTincbuZrS3PuPBOgjidsR8jdyTGBRw@mail.gmail.com>
	<20110629151825.56cb4499@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110629151825.56cb4499@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,



On Tue, Jun 28, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:
> =A0mdadm -S /dev/md5
> =A0mdadm -C /dev/md5 --metadata 1.0 -l1 -n2 --assume-clean

Will I lose data if I do this? Should I use metadata 1.2 ?

>
> Then all should be happiness.
>>
>
> =A0mdadm -S /dev/md4
> =A0mdadm -A /dev/md4 /dev/sdc1 /dev/sdd1 --verbose

That solved it. The array started.

Thanks!

Simon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
