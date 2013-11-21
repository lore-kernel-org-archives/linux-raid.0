From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MDADM 3.3 broken?
Date: Thu, 21 Nov 2013 21:50:10 +0100
Message-ID: <528E7202.9020301@arcor.de>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>	<528A7721.8080604@arcor.de>	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>	<20131119110110.396b2af3@notabene.brown>	<528BBFEB.7050202@arcor.de>	<20131120105115.27494ab6@notabene.brown>	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>	<20131120114833.695fc9d4@notabene.brown>	<CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>	<CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>	<20131120133016.7de2d400@notabene.brown>	<CAGRSmLvR0vrddZ=qOQsM0m+3diDNC3uu-TW2OjwF2mS8UsNF7A@mail.gmail.com> <CAGRSmLsCdXbAUCUMncKv1ER9HBtFnk9BeuF6iaWv=9SSRAiHeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLsCdXbAUCUMncKv1ER9HBtFnk9BeuF6iaWv=9SSRAiHeA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/21/2013 12:15 AM, David F. wrote:

> mdadm: /dev/sdf is identified as a member of /dev/md/ddf0, slot 4.
> mdadm: /dev/sde is identified as a member of /dev/md/ddf0, slot 3.
> mdadm: /dev/sdd is identified as a member of /dev/md/ddf0, slot 2.
> mdadm: /dev/sdc is identified as a member of /dev/md/ddf0, slot 1.
> mdadm: /dev/sdb is identified as a member of /dev/md/ddf0, slot 0.
> mdadm: ignoring /dev/sdb as it reports /dev/sdf as failed
> mdadm: ignoring /dev/sdc as it reports /dev/sdf as failed
> mdadm: ignoring /dev/sdd as it reports /dev/sdf as failed
> mdadm: ignoring /dev/sde as it reports /dev/sdf as failed
> mdadm: no uptodate device for slot 0 of /dev/md/ddf0
> mdadm: no uptodate device for slot 2 of /dev/md/ddf0
> mdadm: no uptodate device for slot 4 of /dev/md/ddf0
> mdadm: no uptodate device for slot 6 of /dev/md/ddf0
> mdadm: added /dev/sdf to /dev/md/ddf0 as 4
> mdadm: Container /dev/md/ddf0 has been assembled with 1 drive (out of 5)

That looks really weird. The (healthy?) devices sdb-sde are ignored
because they report sdf as failed, and then sdf is used for assembly?

I have no idea at the moment, I need to read the code.

> Output of dmraid --raid_devices command:
> /dev/sdf: ddf1, ".ddf1_disks", GROUP, unknown, 285155328 sectors, data@ 0
> /dev/sde: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
> /dev/sdd: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
> /dev/sdc: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0
> /dev/sdb: ddf1, ".ddf1_disks", GROUP, ok, 285155328 sectors, data@ 0

This seems to support then notion that something's wrong with /dev/sdf.

Martin
