From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Raid recovery. Help wanted!
Date: Sun, 21 Apr 2013 17:40:55 +0100
Message-ID: <CADNH=7Fv7NzE85P0ABorzWhsTEBKzd2Fnm27UxhsnmvVArqShg@mail.gmail.com>
References: <517410F6.8050605@maris.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <517410F6.8050605@maris.no>
Sender: linux-raid-owner@vger.kernel.org
To: Evgeny Koryanov <evgeny.koryanov@maris.no>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 21 April 2013 17:16, Evgeny Koryanov <evgeny.koryanov@maris.no> wrote:
> Hello everybody!
>
> Yesterday I met a problem with one of raid5 arrays build by mdadm on three
> (sd[bcd]) 1.5T devices.
> I found array in degraded state with sdd fail. Drive becomes fail state
> after power jump.
> Server supplied by UPS but this seems was not good enough - server was not
> rebooted but one drive as I said becomes fail state.
> I simply reattaches it and array started rebuilding but fails after couple
> of %'s passed with sdc becomes fail!!!
> I assemble array again with sd[bc] and tried to attach sdd again: picture
> repeated rebuild fails.
> So I have sdb in sync state, sdc - failed and sdd spare. I checked SMARTs of
> drives to understand reason of such behavior and
> found it clean on all devices. Than I tried to dd if=/dev/sd[bcd]
> of=/dev/null and found that dd also fails with IO error.
> After dd bad blocks started appears in SMART :)
> Finally I have:
> sdb - sync
> sdc - fail
> sdd - spare
> states and a number of bads on each hdd in random places...
>
> Could any one suggest how can I assemble this array now in read-only mode to
> try to copy data?!
> Theoretically data on sdd should not be rewritten and it still should be
> possible to try recover data (meaning that bads appears in quite different
> places)...
> May be you know utility which helps recover data or the way how to start
> array in read-only mode preventing becomes it to degraded state
> and force md device to try recover data using readable places from each
> devise???
> Or any other ideas appreciated! Thanks, any way...
>
> Best regards,
>                 Evgeny.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Hi,

Could you post the smartctl -a output of all the drives? If 2 drives
are failling you might want to derescue them somewhere and assemble
the RAID from that.

Mathias
