From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MDADM 3.3 broken?
Date: Mon, 25 Nov 2013 22:56:25 +0100
Message-ID: <5293C789.3020703@arcor.de>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>	<528A7721.8080604@arcor.de>	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>	<20131119110110.396b2af3@notabene.brown>	<528BBFEB.7050202@arcor.de>	<20131120105115.27494ab6@notabene.brown>	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>	<20131120114833.695fc9d4@notabene.brown>	<CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>	<CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>	<20131120133016.7de2d400@notabene.brown>	<528E710F.1050901@arcor.de> <CAGRSmLtfL+Pzcy0CdfvUpcX3Z90-wEVTg46Q2iFRbJsxuSeyBQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLtfL+Pzcy0CdfvUpcX3Z90-wEVTg46Q2iFRbJsxuSeyBQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

The metadata really looks all ok, but mdadm fails to assemble it
correctly. It does look like a bug to me. The problem seems to be
related to the global spare somehow. I have no idea why.

The best thing to proceed would be to run mdadm --dump on
/dev/sd[bcdef], put the output in a tgz and make it available to us
somewhere. So we could actually debut the assembly.

Regards,
Martin



