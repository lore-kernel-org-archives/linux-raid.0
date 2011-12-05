From: Kenneth Emerson <kenneth.emerson@gmail.com>
Subject: Re: md metadata nightmare
Date: Sun, 4 Dec 2011 23:05:36 -0600
Message-ID: <CADzwnhWEnxPBgnpqZEjjwD0HkfQ+irkEO-LpDKoAZhr5AAMwcQ@mail.gmail.com>
References: <CADzwnhXWvkVC13ZEJj8L0O6PLXLS6uhoBXqoLp67YwmeU60sQQ@mail.gmail.com>
	<20111123114743.1085889e@notabene.brown>
	<CADzwnhUJ7HbZH9yqa6x9sHFLo8Vg=1k_SyzvZyq2=iQ5YRLhZQ@mail.gmail.com>
	<20111124093637.0c3bb2eb@notabene.brown>
	<CADzwnhXuW7ShBNGf+kqnZYrtRnWMPSRDWzb2h4Gt69Cih0-yGA@mail.gmail.com>
	<20111204061122.5bb5de4b@notabene.brown>
	<CADzwnhW+o69Dum10biobv8r093uUa+LABv71Jdg+obOt5Ev6+A@mail.gmail.com>
	<BLU0-SMTP331AF211B9C3D0D1799003C98B40@phx.gbl>
	<20111205063926.3d42cd1e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111205063926.3d42cd1e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Dec 4, 2011 at 1:39 PM, NeilBrown <neilb@suse.de> wrote:
> On Sun, 4 Dec 2011 17:31:06 +0000 wilsonjonathan <piercing_male@hotma=
il.com>
> wrote:
>
>>
>> > So I finished my backup and attempted to recreate the array using:
>> >
>> > root@mythtv:/home/ken# mdadm -C /dev/md3 --metadata=3D1.0 --chunk=3D=
64k
>> > --level=3D6 --raid-devices=3D5 missing /dev/sdb4 /dev/sdc4 /dev/sd=
a4
>> > /dev/sdd4 --assume-clean
>> >
>> > and received the error:
>> >
>> > mdadm: invalid chunk/rounding value: 64k
>> >
>> > What do I do now?
>>
>> Omit the "k" only M or G are allowed as the default is to assume K
>>
>
> Not strictly accurate. =A0'K' is allowed, though not 'k'. =A0But the =
default is
> definitely 'K', so with
>
> =A0--chunk=3D64
> or
> =A0--chunk-64K
>
> should work.
>
> Thanks,
> NeilBrown

I wanted to report back my success (yes, it was successful).  I
appreciate everyone's help, especially Neil Brown.  I was able to
change the metadata from 0.90 to 1.0 without losing any data (which
was good since it would have take 20+ hours to restore).  I even tried
changing my three RAID1 arrays to version 1.00 but stopped at my boot
partition. I now believe I remember reading that  grub2 only
understands version 0.90; regardless, it wouldn't boot with it changed
to 1.0 so I changed it back to 0.90 and all is good. I got rid of the
erroneous super block on the fourth drive and the arrays are
automatically assembled on boot without intervention.

Much obliged for all the quick responses.  Now I just wait for my
replacement drive from Hitachi and things will be back to 100%.

Regards,

Ken Emerson
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
