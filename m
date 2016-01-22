From: Edward Kuns <eddie.kuns@gmail.com>
Subject: Re: md failing mechanism
Date: Fri, 22 Jan 2016 16:37:06 -0600
Message-ID: <CACsGCyTUBRrQgt0GiVp1R6pv-4gO44Ro7pgm4iCq+1KwWDoPsg@mail.gmail.com>
References: <56A26E11.2090703@yandex.ru>
	<56A28309.9080806@turmel.org>
	<56A2A2C3.9000801@yandex.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56A2A2C3.9000801@yandex.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Dark Penguin <darkpenguin@yandex.ru>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, Jan 22, 2016 at 3:44 PM, Dark Penguin <darkpenguin@yandex.ru> wrote:
> And also, now I understand why I probably "should have been scrubbing". =/

Depending on your distribution, you may have been scrubbing all along.
When I looked into this, I discovered that mdadm as bundled in Fedora
(at least as of 21) already scrubs weekly:

$ rpm -ql mdadm | grep /etc
/etc/cron.d/raid-check
/etc/libreport/events.d/mdadm_event.conf
/etc/sysconfig/raid-check

$ cat /etc/cron.d/raid-check
# Run system wide raid-check once a week on Sunday at 1am by default
0 1 * * Sun root /usr/sbin/raid-check

Sweet!  I was pleased to discovered this when I realized I had been
lax.  The /usr/sbin/raid-check script does scrubbing, as configured by
/etc/sysconfig/raid-check.  I looked in /var/log/messages and indeed
saw evidence of successful weekly scrubbing.

Notice that if you have problems with timeouts, then this scrubbing
can break your array by causing you to hit a bad sector and fail as
Phil and others have described in several of his referenced EMails.
But better to fail early while only one drive is bad than to discover
this after more than one drive has problems and your data is
irrecoverable.  I had a mirror where one drive kept falling out.  I
now understand why.  (Weekly scrubbing + dodgy drives + no attempt to
address the timeouts == occasional unnecessary failure.)

> As I understand, one way around this problem is to change the kernel timeout
> to exceed the drive timeout by changing /sys/block/sd?/device/timeout to
> something larger than the default 30, but I'd have to do that after every
> reboot, is all that correct?

I took the script from this Email:

https://www.marc.info/?l=linux-raid&m=144661276420400&w=2

and dropped that code in my /etc/rc.d/rc.local after verifying that my
Linux distribution still ran that script on every startup.  YMMV.
That solved my problem.  Good luck.

             Eddie
