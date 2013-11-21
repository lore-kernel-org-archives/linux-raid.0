From: Martin Wilck <mwilck@arcor.de>
Subject: Re: MDADM 3.3 broken?
Date: Thu, 21 Nov 2013 21:46:07 +0100
Message-ID: <528E710F.1050901@arcor.de>
References: <CAGRSmLviYJtCfNiARKW0FvrJ0BUDrvhPnQy2drzbkf95-Gfpag@mail.gmail.com>	<528A7721.8080604@arcor.de>	<CAGRSmLvRVQtrkYPLS8NfRS+DvyS0xZ72cwVdLygb0w5KbVrARA@mail.gmail.com>	<20131119110110.396b2af3@notabene.brown>	<528BBFEB.7050202@arcor.de>	<20131120105115.27494ab6@notabene.brown>	<CAGRSmLsAALx=kJFiB6_b_yeb66qMZCa+4brg8Aejeaf031_JPg@mail.gmail.com>	<CAGRSmLs8AXqTG9Y0YU46vtpb2q08-2ApknBHVPF75FXPJu7C0Q@mail.gmail.com>	<20131120114833.695fc9d4@notabene.brown>	<CAGRSmLsTnc_Lood59wF88w6nECVojbeiGkdntLExLEf6ZoaF7g@mail.gmail.com>	<CAGRSmLvv0-MRyKV89W4zDi57Fhx8dxEUsR+zskOQ0R-H6x4Zbw@mail.gmail.com> <20131120133016.7de2d400@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20131120133016.7de2d400@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "David F." <df7729@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/20/2013 03:30 AM, NeilBrown wrote:

>>>> mdadm --examine --scan
>>> ARRAY metadata=ddf UUID=7ab254d0:fae71048:
>>> 404edde9:750a8a05
>>> ARRAY container=7ab254d0:fae71048:404edde9:750a8a05 member=0
>>> UUID=5337ab03:86ca2abc:d42bfbc8:23626c78
> 
> This shows that mdadm found a container with the correct UUID, but the member
> array inside the container has the wrong uuid.
> 
> Martin: I think one of your recent changes would have changed the member UUID
> for some specific arrays because the one that was being created before wasn't
> reliably stable.  Could  that apply to David's situation?

I am confused. AFAIL, my patch bedbf68a first introduced subarray UUIDs
for DDF. I don't understand how this mdadm.conf could have worked with
mdadm 3.2.x.

But you are right, I had to make 7087f02b later that changed the way
subarray UUIDs were calculated. This would hurt people who created their
mdadm.conf file) with stock 3.3 and updated to latest git later.

> David: if you remove the "UUID=" part for the array leaving the
> "container=.... member=0" as the identification, does it work?

I second that. David, please try it. I'd also appreciate "mdadm -E
/dev/sdX" output for all the RAID disks.

Martin
