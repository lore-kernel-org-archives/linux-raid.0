From: Danilo Godec <danilo.godec@agenda.si>
Subject: Re: Raid failure - drives or controller?
Date: Wed, 07 Mar 2012 22:15:29 +0100
Message-ID: <4F57CFF1.8040005@agenda.si>
References: <4F57A05E.6000204@agenda.si> <CADNH=7Hme2BOCjBC9gw4YiTXkTGg6tw5EmH6bhuEx0_+05Wupg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7Hme2BOCjBC9gw4YiTXkTGg6tw5EmH6bhuEx0_+05Wupg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7.3.2012 22:11, Mathias Bur=C3=A9n wrote:
>
> Can you please post the smartctl -a (from smartmontools) output for b=
oth drives?
>
> Mathias
> --

# smartctl -a /dev/sde

> smartctl 5.39.1 2010-01-28 r3054 [x86_64-unknown-linux-gnu] (openSUSE=
 RPM)
> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforg=
e.net
>
> Device: WDC      WD1002FBYS-02A6B Version: 0C06
> Serial number:      WD-WMATV6536667
> Device type: disk
> scsiModePageOffset: response length too short, resp_len=3D12 offset=3D=
12
> bd_len=3D8
> Local Time is: Wed Mar  7 22:13:35 2012 CET
> Device does not support SMART
>
> Current Drive Temperature:     <not available>
>
> Error Counter logging not supported
>
> [GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S=
 on']
>
> SMART Self-test log
> Num  Test              Status                 segment  LifeTime=20
> LBA_first_err [SK ASC ASQ]
>      Description                              number   (hours)
> #256  Default           Completed                   - =20
> 12946                 - [-   -    -]
> #512  Default           Completed                   - =20
> 12946                 - [-   -    -]
> #768  Default           Completed                   -   =20
> 554                 - [-   -    -]

# smartctl -a /dev/sdg
> smartctl 5.39.1 2010-01-28 r3054 [x86_64-unknown-linux-gnu] (openSUSE=
 RPM)
> Copyright (C) 2002-10 by Bruce Allen, http://smartmontools.sourceforg=
e.net
>
> Device: WDC      WD1002FBYS-02A6B Version: 0C06
> Serial number:      WD-WMATV6535018
> Device type: disk
> scsiModePageOffset: response length too short, resp_len=3D12 offset=3D=
12
> bd_len=3D8
> Local Time is: Wed Mar  7 22:13:40 2012 CET
> Device does not support SMART
>
> Current Drive Temperature:     <not available>
>
> Error Counter logging not supported
>
> [GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S=
 on']
>
> SMART Self-test log
> Num  Test              Status                 segment  LifeTime=20
> LBA_first_err [SK ASC ASQ]
>      Description                              number   (hours)
> #256  Default           Completed                   -  =20
> 1359                 - [-   -    -]
> #512  Default           Completed                   -  =20
> 1040                 - [-   -    -]
> #768  Default           Completed                   -   =20
> 581                 - [-   -    -]



   Thanks, Danilo

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
