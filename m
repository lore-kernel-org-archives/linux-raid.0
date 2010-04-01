From: CoolCold <coolthecold@gmail.com>
Subject: Re: mounting component device of RAID1 with internal bitmap
Date: Thu, 1 Apr 2010 22:26:14 +0400
Message-ID: <s2nf19d625d1004011126p80d579b7oaba81484dcad92ce@mail.gmail.com>
References: <q2zf19d625d1004011047gf9d48094p696ac38e669fb5e4@mail.gmail.com>
	 <4BB4E291.5090304@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB4E291.5090304@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Apr 1, 2010 at 10:14 PM, Doug Ledford <dledford@redhat.com> wro=
te:
> On 04/01/2010 01:47 PM, CoolCold wrote:
>> Hello!
>> For raid1 array with metadata 0.90 it is possible to mount component
>> (let's say /dev/sda1) as usual FS, fix smth, /etc/fstab for example,
>> unmount and then assamble arary.
>
> At which point you have just corrupted your array.
I've did such operation several times and it worked fine..I'll do some
checks and report later.

>
>> but is this possible for raid1 array
>> with internal bitmap ? If my guesses are right this may damage array=
=2E
>
> Bitmap doesn't matter, you corrupt your array when you do this either=
 way.
>
>
>
> --
> Doug Ledford <dledford@redhat.com>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0GPG KeyID: CFBFF194
> =A0 =A0 =A0 =A0 =A0 =A0 =A0http://people.redhat.com/dledford
>
> Infiniband specific RPMs available at
> =A0 =A0 =A0 =A0 =A0 =A0 =A0http://people.redhat.com/dledford/Infiniba=
nd
>
>



--=20
Best regards,
[COOLCOLD-RIPN]
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
