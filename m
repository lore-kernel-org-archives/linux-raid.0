From: Felipe Sateler <fsateler@debian.org>
Subject: Re: mdadm: Has init script in runlevel S but no matching service file
Date: Thu, 31 Mar 2016 10:08:50 -0300
Message-ID: <CAAfdZj8eoXxr_fU8OU+G2S1s4RnJrTB7fAtLxwwtsjeN+BXj=g@mail.gmail.com>
References: <CAAfdZj_hDJOS2-Q9BchbnBhsprUOn_EmftGLXR-t_b7BOidUYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAfdZj_hDJOS2-Q9BchbnBhsprUOn_EmftGLXR-t_b7BOidUYw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 796624@bugs.debian.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello upstream mdadm.

I'm adding you to CC to resolve the issue of an init script that
current debian uses, that might possibly be redundant. Please see my
below diagnosis

On 24 December 2015 at 16:10, Felipe Sateler <fsateler@debian.org> wrote:
>
> On Sat, 22 Aug 2015 22:32:00 -0300 fsateler@debian.org wrote:
> > Hi,
> >
> > Your package mdadm has an initscript that is enabled in runlevel S,
> > but it does not provide a corresponding systemd service unit.
>
> It seems that the mdadm-raid init script (which triggered this bug
> report) is not useful on a udev system (which all systemd systems
> are[1]). The file /lib/udev/rules.d/64-md-raid-assembly.rules assembles
> the arrays incrementally as devices are known to udev, and so running
> a separate assembly step should be superfluous. If this is not true,
> then maybe this should be reported upstream, as there is a systemd
> service missing.

For reference, the init script in question can be seen in the souces
site[1]. On boot, it invokes mdadm --assemble and reports some status
messages for each md device.

So, the questions are: is this init script redundant on a udev system?
If not, isn't an equivalent systemd unit missing upstream?


[1] http://sources.debian.net/src/mdadm/3.4-1/debian/mdadm-raid/


-- 

Saludos,
Felipe Sateler
