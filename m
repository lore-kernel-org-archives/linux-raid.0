From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Reinstall OS Without Disturbing Software Raid Array
Date: Thu, 14 Jul 2011 12:01:00 +0100
Message-ID: <CAKaSfQDuZwP37zHcU7D4YsJ3CDCTwXKvbWHCV_XzKPhVhMahWQ@mail.gmail.com>
References: <1310234009.6441.3.camel@babel>
	<4E18C3A2.1040202@harddata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E18C3A2.1040202@harddata.com>
Sender: linux-raid-owner@vger.kernel.org
To: Maurice Hilarius <maurice@harddata.com>
Cc: Noah Swint <noah.swint@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Best advice would be to ensure you have a back up before trying it ;-)

As an aside my raid array is mountable using even a live cd once mdadm
and lvm2 packages have been installed.



On 9 July 2011 22:09, Maurice Hilarius <maurice@harddata.com> wrote:
> On 7/9/2011 11:53 AM, Noah Swint wrote:
>>
>> Can I reinstall fedora 14 without destroying the software raid array=
?
>
> Yes.
>
> In the Fedora installer, when you get to the disk partitioning option=
s
> selection,
> choose "Custom" which is, I believe the last option on the pull down =
menu.
>
> That assumes, of course, that you are using the GUI installer version=
=2E
> If you are installing in text mode, the choice is the same, however t=
he menu
> is different.
>
> One may if you like, also =A0selectively save existing partitions and=
 their
> data, but choosing
> whether or not you want them to be formatted.
>
> Often one may want to preserve /home, assuming that it is a separate
> partition or md device.
>
>
>
>
> --
> --
> Cheers,
> Maurice Hilarius
> eMail: /mhilarius@gmail.com/
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
