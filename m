From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Tue, 26 Nov 2013 13:59:34 -0800
Message-ID: <CAGRSmLsHSwELK_jd=PEckDpSBVCfrt9cHBvG_cH9esMYtLu5Jg@mail.gmail.com>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>
	<528A7721.8080604@arcor.de>
	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>
	<20131119110110.396b2af3@notabene.brown>
	<528BBFEB.7050202@arcor.de>
	<20131120105115.27494ab6@notabene.brown>
	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>
	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>
	<20131120114833.695fc9d4@notabene.brown>
	<CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>
	<CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com>
	<20131120133016.7de2d400@notabene.brown>
	<528E710F.1050901@arcor.de>
	<CAGRSmLtfL+Pzcy0CdfvUpcX3Z90-wEVTg46Q2iFRbJsxuSeyBQ@mail.gmail.com>
	<5293C789.3020703@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5293C789.3020703@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

does it need to be a tar type file or would virtual hard drive .vmdk
files be okay?

On Mon, Nov 25, 2013 at 1:56 PM, Martin Wilck <mwilck@arcor.de> wrote:
> The metadata really looks all ok, but mdadm fails to assemble it
> correctly. It does look like a bug to me. The problem seems to be
> related to the global spare somehow. I have no idea why.
>
> The best thing to proceed would be to run mdadm --dump on
> /dev/sd[bcdef], put the output in a tgz and make it available to us
> somewhere. So we could actually debut the assembly.
>
> Regards,
> Martin
>
>
>
