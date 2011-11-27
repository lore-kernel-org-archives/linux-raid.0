From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: RAID5: failing an active component during spare rebuild - arrays hangs
Date: Sun, 27 Nov 2011 11:56:17 +0200
Message-ID: <CAGRgLy62uavK+9qosizaOey1Utz6STC+2fvOVqEbmi0HZbrQtw@mail.gmail.com>
References: <BANLkTikkeoCsr3-UBSPEDrYwh4jGSn=MaA@mail.gmail.com>
	<BANLkTinwr9UE_B+MSXfbE2nAv0wLrTvhXg@mail.gmail.com>
	<20110622125409.14428883@notabene.brown>
	<BANLkTinijekK8Y6TTk6TYtYhv4Dn2YGQbA@mail.gmail.com>
	<20110628122921.42480f72@notabene.brown>
	<CAGRgLy5uK5As96j2Tprfrx+qNhYqvFiVUEnOJ+3AAwpPMHCDYg@mail.gmail.com>
	<CAGRgLy5huVzdA8q6V887Ay384kJ4ywgst6dEGgYuRg9+SxHB0A@mail.gmail.com>
	<20110831124646.21be9e25@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110831124646.21be9e25@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,
we have compiled the natty kernel with dynamic debugging enabled for
raid456, and reproduced the problem.
The kernel log is available at
https://docs.google.com/open?id=3D0B9rmyUifdvMLMzk1YjYwZDUtYzhhYi00MDRl=
LTkzYjItMDM0Y2ZhZmU3ZDRk

Some more information:
- array was created at Nov 27 11:28:03
- manual drive failure was issued at 11:28:09

Please let me know if you need any additional information.

Thanks for your help,
Alex.


> The fact that md1123_raid5 is spinning suggest there is one request t=
hat
> is being handled over and over again - each time handle_stripe5 think=
s that
> it cannot handle it yet, but leaves it in a state which indicates tha=
t it
> still needs handling.
> However I cannot see how that could possible happen.
>
> If your kernel had dynamic debugging enabled we =A0could turn that on=
 for RAID5
> and =A0see a bit more of what is happening.
> i.e.
> =A0echo module raid456 > /sys/kernel/debug/dynamic_debug/control
>
> with the debug filesystem mounted on /sys/kernel/debug
>
> However that Ubuntu kernel doesn't have CONFIG_DYNAMIC_DEBUG set so y=
ou
> would need to compile a new kernel.
>
> I cannot think of any other way forward with this.
>
> BTW when I tested your script on the very latest kernel I hit a compl=
etely
> unrelated bug what was introduced very recently which I can now fix. =
=A0So I'm
> particularly glad that I looked at this :-)
>
> NeilBrown
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
