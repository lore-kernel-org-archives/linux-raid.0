From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: Disappointing performance: 5-disk RAID6, 3.11.6
Date: Tue, 21 Jan 2014 16:00:29 -0600
Message-ID: <CAKuK5J2UnKjRmjk6oDP11_skfAbvcvsrT9VRXoswSS323jhHpQ@mail.gmail.com>
References: <CAKuK5J34CvTwZ5S6uyBUdEft2SkwrycXvYfNvQATit8GbdZcuw@mail.gmail.com>
 <CADNH=7HpRJRDQ9PUmKDOVs=Pbbj2Z50AZi9XdFrhUBQKR7A-Dg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7HpRJRDQ9PUmKDOVs=Pbbj2Z50AZi9XdFrhUBQKR7A-Dg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Jan 21, 2014 at 10:55 AM, Mathias Bur=C3=A9n <mathias.buren@gma=
il.com> wrote:
> On 21 January 2014 17:42, Jon Nelson <jnelson-linux-raid@jamponi.net>=
 wrote:
>>
>> I have a 5-disk RAID6 using (5) 320GB SATA drives.
>> I rarely see even sequential I/O approaching that of a single drive'=
s
>> performance.
=2E..
> Does enabling NCQ help? (I see "queue depth per-drive is 1")

I didn't see any noticeable performance change with 31 (as high as it w=
ould go).


--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
