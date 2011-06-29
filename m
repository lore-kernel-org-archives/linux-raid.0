From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: Can't start array and Negative "Used Dev Size"
Date: Wed, 29 Jun 2011 08:45:33 -0700
Message-ID: <BANLkTin7f-8tLDoZsmyFocb9j1e1wn=4Dw@mail.gmail.com>
References: <BANLkTincbuZrS3PuPBOgjidsR8jdyTGBRw@mail.gmail.com>
	<20110629151825.56cb4499@notabene.brown>
	<BANLkTimonHoSn5eoX9AB8wLJYR4SFoBd-w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTimonHoSn5eoX9AB8wLJYR4SFoBd-w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil,



On Tue, Jun 28, 2011 at 10:24 PM, Simon Matthews
<simon.d.matthews@gmail.com> wrote:
> Neil,
>
>
>
> On Tue, Jun 28, 2011 at 10:18 PM, NeilBrown <neilb@suse.de> wrote:

>> =A0mdadm -S /dev/md4
>> =A0mdadm -A /dev/md4 /dev/sdc1 /dev/sdd1 --verbose
>
> That solved it. The array started.

Do you have any idea why the array did not start when the system
booted? I also have an md6 on the same hard drives that was created at
the same time as md4, but md6 started on the boot.

Simon


>
> Thanks!
>
> Simon
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
