From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Performance question, RAID5
Date: Mon, 31 Jan 2011 09:37:46 +0000
Message-ID: <AANLkTi=Zgqs958fSjkmKaDpgL21qshm=SRj_HUvjTbZz@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>
	<AANLkTik4MGS7V7ePBgbk+KW-FcBBV7MuYgB7n29RRXF=@mail.gmail.com>
	<20110130094444.68288b0e@natsu>
	<AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com>
	<20110130171533.4c9e236b@natsu>
	<AANLkTi=6UnGjDXdrM76-8_iW+1D6MC5fkGB-vhhYxUXu@mail.gmail.com>
	<4D45C3FA.2040900@hardwarefreak.com>
	<AANLkTikLX-d6CtXhLBQU_qoxx0fQ2HdR8acFCU+o9JeP@mail.gmail.com>
	<20110131085202.GA25912@www2.open-std.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131085202.GA25912@www2.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@keldix.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Roman Mamedov <rm@romanrm.ru>, CoolCold <coolthecold@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 31 January 2011 08:52, Keld J=C3=B8rn Simonsen <keld@keldix.com> wro=
te:
> If your intallation is CPU bound, and you are
> using an Atom N270 processor or the like, well some ideas:
>
> The Atom CPU may have threading, so you could run 2 RAIDs
> which then probably would run in each thread.
> It would cost you 1 more disk if you run 2 RAID5's
> so you get 8 TB payload out of your 12 GB total (6 drives of 2 TB eac=
h).
>
> Another way to get better performance could be to use less
> CPU-intensitive RAID types. RAID5 is intensitive as it needs to
> calculate XOR information all the time. Maybe a mirrored
> raid type like RAID10,f2 would give you less CPU usage,
> and the run 2 RAIDS to have it running in both hyperthreads.
> Here you would then only get 6 TB payload of your 12 GB disks,
> but then also probably a faster system.
>
> Best regards
> keld
>

Hi,

It's interesting what you say about the XOR calculations. I thought
that it was only calculated on writes? The Atom (330) has HT, so Linux
sees 4 logical CPUs.

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
