From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: [RFE] Please, add optional RAID1 feature (= chunk checksums) to
 make it more robust
Date: Mon, 23 Jul 2012 15:24:38 -0300
Message-ID: <CABYL=Tq0w150QMcehdsScUfDfCD2tGFeuROjWjwsepy1rRXk_w@mail.gmail.com>
References: <500CD32E.4000800@hardwarefreak.com>
	<542194327.593466.1343036057599.JavaMail.root@redhat.com>
	<20120723170320.GA2691@lazy.lzy>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120723170320.GA2691@lazy.lzy>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: Jaromir Capik <jcapik@redhat.com>, stan@hardwarefreak.com, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

yeah, i think this too, but IMO Jamiro exposed a specific scenario,
let=B4s get back to it and after check a generic scenario,
he is using small computers (i don=B4t know if it=B4s ARM or X86) with
space to only 2 disks (i told him to use raid5 or raid6 because the
checksums but he don=B4t have space for >=3D3 disks in computer case,
maybe if we could run raid5 with 2 disks could help... or 1 disk...
just a idiot idea, but this could help...)
i don=B4t know the real scenario, i think he will not use it in
100partitions, maybe 4 or 5 partitions, and performance to be a second
option, security is priority here
in the implementation of this new layer (maybe like LINEAR, MULTIPATH
or another not raid level) we could focus on security and after
performace

just some ideas...

2012/7/23 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
>
> Hi all,
>
> actually, what you would like to do is already
> possible, albeit it will kill the performance
> of a rotating, mechanical, HDD.
> With SSD might work better.
>
> If you take an HDD and partition it, let's say
> with 100 partitions (GPT will be required),
> then you can build a RAID-6 using this 100
> partitions, having a redundancy of 2%.
> Taking two, or more, of such configured RAID-6,
> it will be possible to build (with them) a
> RAID-1 (or else).
>
> If a check of this RAID-1 returns mismatches,
> it will be possible to check the single devices
> and find out which is not OK.
> With RAID-6 (per device), and a bit of luck, it
> will be possible to fix it directly.
>
> Of course a lot of variables are tunable here.
> For example the number of partitions, the chunk
> size, or even the fact that with X partitions
> it could be possible to build more than one RAID-6,
> increasing the effective redundancy.
>
> All with the performance price I mentioned at the
> beginning.
>
> bye,
>
> --
>
> piergiorgio
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html




--
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
