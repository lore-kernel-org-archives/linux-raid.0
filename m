From: Brad Campbell <brad@fnarfbargle.com>
Subject: Re: Kernel 3.7.9 RAID6 hot replace success
Date: Wed, 6 Mar 2013 07:57:43 +0800
Message-ID: <D7DE2412-0478-4CEC-B771-07E718F011FC@fnarfbargle.com>
References: <30532376.12.1362508455226.JavaMail.root@zimbra>
Mime-Version: 1.0 (1.0)
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <30532376.12.1362508455226.JavaMail.root@zimbra>
Sender: linux-raid-owner@vger.kernel.org
To: "roy@karlsbakk.net" <roy@karlsbakk.net>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/03/2013, at 2:34 AM, Roy Sigurd Karlsbakk <roy@karlsbakk.net> wro=
te:

>> Add spare to array
>> echo want_replacement > /sys/block/md0/md/dev-sdm/state
>> Wait 6 hours
>> Remove failed drive
>> Job done.
>>=20
>> Last time I tried this (lots of kernel versions ago) I had all sorts
>> of
>> issues with removing the failed drive and other sticky stuff that
>> required rebooting to clean up. This "just worked".
>=20
> This is great. Any idea when that came in?
>=20
> Btw, with as many as 10 drives in a RAID-6, I'd keep at least one spa=
re permanently there=E2=80=A6
>=20

Im pretty sure I last tested it about 3.2 or  3.3.

I do keep a permanent spare drive, but with 3 arrays I manually allocat=
e it in the rare event it is required. This drive had not failed out of=
 the array, so the spare sat idle until I proactively replaced the dodg=
y drive.--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
