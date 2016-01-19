From: =?UTF-8?B?0J/RkdGC0YAg0JEu?= <satnatantas@gmail.com>
Subject: Re: ICH RAID5 delisted and broken after mdadm installation
Date: Tue, 19 Jan 2016 19:13:11 +0300
Message-ID: <CA+Ni7jPJxKGZnNma0T8UgZhLqdXY-SbRcy=2246JxuZLNZG-zQ@mail.gmail.com>
References: <CA+Ni7jMa2TSSYbDcZ-HQTp5O42UZ==r7wJ5dikXfytHgHF7pzQ@mail.gmail.com>
	<CA+Ni7jM-Ad4G=_23uL9K-4Ya46K2NV-0LqnaaQW7fR4+npMPXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+Ni7jM-Ad4G=_23uL9K-4Ya46K2NV-0LqnaaQW7fR4+npMPXA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

=46ixed it myself with these tips:

https://communities.intel.com/thread/26252?tstart=3D0
http://marc.info/?l=3Dlinux-raid&m=3D134308187613187&w=3D2

Now, for some strange reason it was working for some time and then got
delisted again ("Offline members" in BIOS). Assembled and started with
mdadm and it worked again after reboot.

2016-01-18 20:13 GMT+03:00, =D0=9F=D1=91=D1=82=D1=80 =D0=91. <satnatant=
as@gmail.com>:
> I found a mistake: sdc contains Windows and is failing, not sdb.
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
