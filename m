From: Drew <drew.kay@gmail.com>
Subject: Re: mdadm raid1 read performance
Date: Tue, 3 May 2011 22:30:24 -0700
Message-ID: <BANLkTimzqu1C+_Z2t5m1bjduXFeRwbgssQ@mail.gmail.com>
References: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com> <20110504105822.21e23bc3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110504105822.21e23bc3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Liam Kurmos <quantum.leaf@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> I've been testing mdadm (great piece of software btw) however all my
>> test show that reading from raid1 is only the same speed as reading
>> from a single drive.
>
> Why do you expect RAID1 to be faster? =C2=A0On a single threaded sequ=
ential read
> there is not much it can do to go faster than a single device. =C2=A0=
Maybe on some
> multi-thread random IOs it might.
> What sort of tests were you running?

It wouldn't surprise me if the OP had the same idea I had when I first
started reading about RAID many moons ago.

It seemed logical to me that if two disks had the same data and we
were reading an arbitrary amount of data, why couldn't we split the
read across both disks? That way we get the benefits of pulling from
multiple disks in the read case while accepting the penalty of a write
being as slow as the slowest disk..


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
