From: "David F." <df7729@gmail.com>
Subject: Re: MDADM 3.3 broken?
Date: Thu, 21 Nov 2013 13:06:18 -0800
Message-ID: <CAGRSmLuWAP7qr_1Xh8TqXXH9rEdat63qOh6uW6WyabrPAT7i0Q@mail.gmail.com>
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
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <528E710F.1050901@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> Martin: I think one of your recent changes would have changed the member UUID
>> for some specific arrays because the one that was being created before wasn't
>> reliably stable.  Could  that apply to David's situation?
>
> I am confused. AFAIL, my patch bedbf68a first introduced subarray UUIDs
> for DDF. I don't understand how this mdadm.conf could have worked with
> mdadm 3.2.x.

I'm not sure on the cisco server with lsi raid that the 3.2.x version
works as that is different than the isw issues that most were having.

>
> But you are right, I had to make 7087f02b later that changed the way
> subarray UUIDs were calculated. This would hurt people who created their
> mdadm.conf file) with stock 3.3 and updated to latest git later.
>
>> David: if you remove the "UUID=" part for the array leaving the
>> "container=.... member=0" as the identification, does it work?

We sent them a version that will try that - hope they don't get too
tired of testing.  The int13h interface to the RAID works fine, as
does Windows interface.

>
> I second that. David, please try it. I'd also appreciate "mdadm -E
> /dev/sdX" output for all the RAID disks.

That version we sent should output this as well.

>
> Martin
