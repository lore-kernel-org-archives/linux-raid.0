From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Fri, 22 Nov 2013 10:36:01 -0800
Message-ID: <CAGRSmLsa5Wu0rTu7HdJM+ZLd3ukt1WcG=Kx6EB2fD1xx=VbFxQ@mail.gmail.com>
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
	<CAGRSmLtR7rEVYFpGoDybgrX4Myj2Fa2MVbiVYK6=fi1RSRKPFA@mail.gmail.com>
	<CAGRSmLsO9uPkEdwvVwKotE53D15Jg9ar+UwLPjH=q0EY8BwkSg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLsO9uPkEdwvVwKotE53D15Jg9ar+UwLPjH=q0EY8BwkSg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Okay, got the word on what the sdf drive is:

"5th drive is configured as spare for RAID 5"

On Thu, Nov 21, 2013 at 7:06 PM, David F. <df7729@gmail.com> wrote:
> So it looks like sdf shouldn't be part of the RAID5 set - maybe it's a
> stand alone drive configured on the raid controller?  I can ask if
> they know...
>
> On Thu, Nov 21, 2013 at 3:09 PM, David F. <df7729@gmail.com> wrote:
>> They also said: RAID 5 with 4 physical drives.
