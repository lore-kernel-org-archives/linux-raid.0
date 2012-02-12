From: Mark Knecht <markknecht@gmail.com>
Subject: Re: RAID6 ext3 problems
Date: Sun, 12 Feb 2012 12:08:31 -0800
Message-ID: <CAK2H+efLnZTvAFcCN=2GTJo6FErFhm330xG6tPNFNxs=5gOPSA@mail.gmail.com>
References: <CAKXovctDQdiMWEdzh6Jg8OkEjXX5OHZ+hubFV-GRsc8S2QHohQ@mail.gmail.com>
	<CAKXovctARfGAkug=ZA0EYm1uB=V0_5BXWyNisVZYip0VBpJxtA@mail.gmail.com>
	<CAK2H+eerAkwup2UcAu2v=_4+=Bg_FBCqZmjGjmcLQA+2ozmvbg@mail.gmail.com>
	<CAKXovcvvTioOP+JKd8b5-Hc1GZhAiqB85=A4d-cCP03uDPiGkg@mail.gmail.com>
	<CAK2H+eds+2wu6Nep639mZ1dkOMmxdzqp4_7-o=QJO_qqcTWr9g@mail.gmail.com>
	<CAKXovctDA28Gk61EJF_1-6kX2kMwRG8yyza4VFsKpzwsiHOEGQ@mail.gmail.com>
	<CAK2H+ee3ERstCsh4ju9kfU0gpFenHqUuMdtjnhFthK8C--NoXw@mail.gmail.com>
	<CAKXovcs-UORdS6d8XYuDa=CF2rMX8H+PX2Y_Gh5N2Oze8Ni+-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKXovcs-UORdS6d8XYuDa=CF2rMX8H+PX2Y_Gh5N2Oze8Ni+-A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jeff W <jeff.welling@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 12, 2012 at 10:57 AM, Jeff W <jeff.welling@gmail.com> wrote:
> On Sun, Feb 12, 2012 at 1:51 PM, Mark Knecht <markknecht@gmail.com> wrote:
>> OK, so in that case if your RAID looks good then it's good, but I
>> guess it's technically degraded until you get a replacement drive in
>> it.
> Yeah, that's a given. The problem isn't so much with the RAID it's
> that I can't mount the partition *on* the RAID, and I don't know why
> or how I could have gotten myself in this situation.
>
>> In the meantime, if you've got an external USB/eSATA/network drive
>> large enough to back up to then I'd suggest getting a backup complete
>> before doing anything else. Just my 2 cents on that one.
> Because the data I'm trying to reach is currently only *on* the RAID
> (the only other copies were stolen), backing up at this point is
> beyond my ability.
> Thanks for your feedback and for trying to help though, I appreciate it :)
> Jeff.

So what _actually_ happens when you issue the commands? Please post
back the results of

cat /proc/mdstat

and

mount /dev/mdWHATEVER /mountpoint

and let's look at what the system is doing.

HTH,
Mark
