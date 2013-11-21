From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MDADM 3.3 broken?
Date: Thu, 21 Nov 2013 22:30:58 +0100
Message-ID: <528E7B92.1050703@arcor.de>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>	<528A7721.8080604@arcor.de>	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>	<20131119110110.396b2af3@notabene.brown>	<528BBFEB.7050202@arcor.de>	<20131120105115.27494ab6@notabene.brown>	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>	<20131120114833.695fc9d4@notabene.brown>	<CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>	<CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>	<20131120133016.7de2d400@notabene.brown>	<CAGRSmLvR0vrddZ=qOQsM0m+3diDNC3uu-TW2OjwF2mS8UsNF7A@mail.gmail.com>	<CAGRSmLsCdXbAUCUMncKv1ER9HBtFnk9BeuF6iaWv=9SSRAiHeA@mail.gmail.com>	<528E7202.902030
 1@arcor.de> <CAGRSmLsDPk0wJ8D_tbttt95OovLLS8xUG-ZpkSfYWQNyq8arjg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLsDPk0wJ8D_tbttt95OovLLS8xUG-ZpkSfYWQNyq8arjg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/21/2013 10:10 PM, David F. wrote:
> On that DMRAID - they are still yet to try it.  But we do know the
> RAID5 works via Int13h interface in real mode and via Windows.  I
> think they thought it was a 4 disk array?  I'll ask if they know the
> actually number of drives in the RAID configuration.

What distribution are these people using? I am not aware of any distro
that would activate mdadm for DDF RAID by default.

Martin
