From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: raid6check extremely slow ?
Date: Thu, 14 May 2020 21:51:21 +0200 (CEST)
Message-ID: <1430936688.3381175.1589485881380.JavaMail.zimbra@karlsbakk.net>
References: <20200510120725.20947240E1A@gemini.denx.de> <1999694976.3317399.1589476824607.JavaMail.zimbra@karlsbakk.net> <20200514182041.CDF1F240E1A@gemini.denx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20200514182041.CDF1F240E1A@gemini.denx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Wolfgang Denk <wd@denx.de>
Cc: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

what?

Vennlig hilsen

roy
--
Roy Sigurd Karlsbakk
(+47) 98013356
http://blogg.karlsbakk.net/
GPG Public key: http://karlsbakk.net/roysigurdkarlsbakk.pubkey.txt
--
Hi=C3=B0 g=C3=B3=C3=B0a skaltu =C3=AD stein h=C3=B6ggva, hi=C3=B0 illa =C3=
=AD snj=C3=B3 rita.

----- Original Message -----
> From: "Wolfgang Denk" <wd@denx.de>
> To: "Roy Sigurd Karlsbakk" <roy@karlsbakk.net>
> Cc: "Linux Raid" <linux-raid@vger.kernel.org>
> Sent: Thursday, 14 May, 2020 20:20:41
> Subject: Re: raid6check extremely slow ?

> Dear Roy,
>=20
> In message <1999694976.3317399.1589476824607.JavaMail.zimbra@karlsbakk.ne=
t> you
> wrote:
>>
>> Try checking with iostat -x to see if one disk is performing worse
>> than the other ones. This sometimes happens and can indicate a
>> failure that the normal SMART/smartctl stuff can't identify. If
>> you see a utilisation of one of the disks at 100%, that's the
>> bastard. Under normal circumstances, you probably won't be able to
>> return that, since it "works". There's a quick fix for that,
>> though. Just unplug the disk, plug it into a power cable, let it
>> spin up and then sharpy twist it 90 degees a few times, and it's
>> all sorted out and you can return it ;)
>=20
> Everything looks unsuspicious to me - all disks behave the same:
>=20
> # iostat -x /dev/sd[efhijklm] 1 3
> Linux 5.6.8-300.fc32.x86_64 (atlas.denx.de)     2020-05-14      _x86_64_
> (8 CPU)
>=20
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>           0.19    0.00    1.06    0.15    0.00   98.60
>=20
> Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s
> wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm
> d_await dareq-sz     f/s f_await  aqu-sz  %util
> sde             20.08    360.56     2.53  11.20    0.34    17.95    0.49
> 0.10     0.02   3.41   32.36     0.20    0.00      0.00     0.00   0.00
> 0.00     0.00    0.49   32.74    0.02   2.11
> sdf             20.07    360.56     2.54  11.24    0.33    17.96    0.49
> 0.10     0.02   3.40   44.23     0.20    0.00      0.00     0.00   0.00
> 0.00     0.00    0.49   44.77    0.02   2.09
> sdh             20.08    360.54     2.53  11.17    0.35    17.95    0.49
> 0.10     0.02   3.40   43.47     0.20    0.00      0.00     0.00   0.00
> 0.00     0.00    0.49   44.01    0.02   2.40
> sdi             20.08    360.58     2.54  11.23    0.34    17.96    0.49
> 0.10     0.02   3.40   26.22     0.21    0.00      0.00     0.00   0.00
> 0.00     0.00    0.49   26.50    0.01   2.84
> sdj             20.45    360.56     2.16   9.54    0.34    17.63    0.49
> 0.10     0.02   3.38   35.19     0.20    0.00      0.00     0.00   0.00
> 0.00     0.00    0.49   35.60    0.02   2.46
> sdk             20.08    360.54     2.53  11.21    0.35    17.95    0.49
> 0.10     0.02   3.42   40.63     0.21    0.00      0.00     0.00   0.00
> 0.00     0.00    0.49   41.13    0.02   2.36
> sdl             20.07    360.57     2.54  11.24    0.34    17.96    0.49
> 0.10     0.02   3.39   23.61     0.20    0.00      0.00     0.00   0.00
> 0.00     0.00    0.49   23.84    0.01   2.70
> sdm             20.08    360.55     2.53  11.21    0.53    17.96    0.49
> 0.10     0.02   3.41   21.52     0.20    0.00      0.00     0.00   0.00
> 0.00     0.00    0.49   21.67    0.01   2.64
>=20
>=20
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>           0.38    0.00    1.12    0.12    0.00   98.38
>=20
> Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s
> wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm
> d_await dareq-sz     f/s f_await  aqu-sz  %util
> sde             20.00    320.00     0.00   0.00    0.25    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.00
> sdf             20.00    320.00     0.00   0.00    0.25    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.00
> sdh             20.00    320.00     0.00   0.00    0.30    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.00
> sdi             20.00    320.00     0.00   0.00    0.25    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   4.00
> sdj             20.00    320.00     0.00   0.00    0.25    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.00
> sdk             20.00    320.00     0.00   0.00    0.30    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.00
> sdl             20.00    320.00     0.00   0.00    0.25    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   4.00
> sdm             20.00    320.00     0.00   0.00    0.35    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.00
>=20
>=20
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>           0.25    0.00    0.88    0.00    0.00   98.87
>=20
> Device            r/s     rkB/s   rrqm/s  %rrqm r_await rareq-sz     w/s
> wkB/s   wrqm/s  %wrqm w_await wareq-sz     d/s     dkB/s   drqm/s  %drqm
> d_await dareq-sz     f/s f_await  aqu-sz  %util
> sde             21.00    336.00     0.00   0.00    0.24    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.10
> sdf             21.00    336.00     0.00   0.00    0.24    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.10
> sdh             21.00    336.00     0.00   0.00    0.24    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.30
> sdi             21.00    336.00     0.00   0.00    0.24    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   4.00
> sdj             21.00    336.00     0.00   0.00    0.24    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.10
> sdk             21.00    336.00     0.00   0.00    0.24    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.10
> sdl             21.00    336.00     0.00   0.00    0.29    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   4.20
> sdm             21.00    336.00     0.00   0.00    0.38    16.00    0.00
> 0.00     0.00   0.00    0.00     0.00    0.00      0.00     0.00   0.00
> 0.00     0.00    0.00    0.00    0.00   2.10
>=20
>=20
>=20
> Best regards,
>=20
> Wolfgang Denk
>=20
> --
> DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
> HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
> Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
> We see things not as they are, but as we are.       - H. M. Tomlinson
