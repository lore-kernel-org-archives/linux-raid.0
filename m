From: "3tcdgwg3" <3tcdgwg3@prodigy.net>
Subject: Re: Software RAID level 1 issue
Date: Fri, 30 May 2003 13:12:20 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <01f101c326e7$c9084890$7b07a8c0@pluto>
References: <C587FF391BCAD411B8120008C7864670057DA5B8@mtvxch07.veritas.com> <1054403067.14818.280.camel@testlin.hades> <3ED7B898.4409555F@SteelEye.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: Paul Clements <Paul.Clements@SteelEye.com>, Stef Telford <stef@chronozon.artofdns.com>
Cc: 'Greg Rasberry' <rgreg-r@pacbell.net>, 'Linux raid mailing list' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


----- Original Message -----
From: "Paul Clements" <Paul.Clements@SteelEye.com>
To: "Stef Telford" <stef@chronozon.artofdns.com>
Cc: "'Greg Rasberry'" <rgreg-r@pacbell.net>; "'Linux raid mailing list'"
<linux-raid@vger.kernel.org>
Sent: Friday, May 30, 2003 1:01 PM
Subject: Re: Software RAID level 1 issue


> Stef Telford wrote:
>
> [snip]
>
> > during resync's on raid-1 the mirror will not be available.
>
> I'm not sure I understand this. md/raid1 devices are accessible while
> resync is occurring...albeit with lower I/O throughput since the resync
> is consuming bandwidth.
>
> It seems relevant to add that in this situation, it would have helped to
> have a logging or bitmap capability in raid1 in order to speed up the
> resync (I think Brian Schwarz was trying to allude to this, but sort of
> missed the point... :).
>
> For anyone who wants faster resync times, you could try Peter T.
> Breuer's fr1 ("fast intelligent" raid1) patches against the raid1
> driver. These provide the driver with a bitmap capability, which ensures
> that only dirty data blocks will be resynced (rather than the whole
> device/partition, which is currently what md does).
>
> I'm also currently working on some enhancements to that code to allow
> the bitmap to be persistent (stored on disk), so that resyncs will
> always be "intelligent" or "fast", even after a reboot or failure of the
> server. I'm hoping that this enhanced code will be able to make its way
> into the mainline kernel some time in the not too distant future...
> *fingers crossed*
>

If there is a plan to do a "intelligent resync", like some of the raid
controller
vendors offer?  The resync process will be hold on, if there are IO requests
from upper level, and resumed when there is no IO.  By doing that, the
system
performance always be on the top.  I am very interested in  having something
like that.

Thanks


> --
> Paul
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

