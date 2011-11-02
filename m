From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Wed, 2 Nov 2011 10:21:29 -0700
Message-ID: <CABE8wwub+7FGWK4MttvPj16TkWus=jn=qt+7ANwtRZqG_pyshg@mail.gmail.com>
References: <20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
	<20111031110613.GA1402@tango.0pointer.de>
	<20111102114416.7879b77f@notabene.brown>
	<20111102011615.GA5289@tango.0pointer.de>
	<20111102130334.09c3ab51@notabene.brown>
	<20111102133223.GC5119@tango.0pointer.de>
	<CAPXgP12RsaFeGK+dQ2hwFjQawhN+QDn1+K8t6jkJ-XSRyautJw@mail.gmail.com>
	<20111102151749.GE5119@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102151749.GE5119@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: Kay Sievers <kay.sievers@vrfy.org>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Wed, Nov 2, 2011 at 8:17 AM, Lennart Poettering
<lennart@poettering.net> wrote:
> On Wed, 02.11.11 15:33, Kay Sievers (kay.sievers@vrfy.org) wrote:
>
>> > The big thing is that if things are done that way you'll always have the
>> > chicken and egg problem: you really need to shut down mdmon before
>> > unmounting root, but currently you require us to do it in the other
>> > order too.
>>
>> Yeah, that's just madness.
>>
>> I talked to Harald, and the currently preferred idea is the version
>> where we start mdmon in the initramfs and never touch it again, and it
>> runs until the initramfs unmounts the rootfs and shuts down the box.
>>
>> In that picture, the mdmon process is conceptually more like a kernel
>> thread than a userspace process. It can not be updated, can not be
>> restarted. The only way to update it is to rebuild initramfs and
>> reboot the box.
>
> OK, I guess that means we'll need to define a way how we can recognize
> the process then, to avoid killing it by systemd, similar to how we
> exclude kernel threads from killing.
>
> Kernel threads we detect by checking whether /proc/$PID/cmdline is
> empty, hence I'd suggest we use the first char of argv[0][0] here, to
> detect whether something is a process to avoid killing. Question is
> which char to choose for that. I am tempted to use '@'.
>
> That means we'd:
>
> a) patch systemd to check whether argv[0][0] of a process is '@' and
> owned by root and exclude it from killing on shutdown.
>
> b) patch mdmon to set argv[0][0] of itself to '@' iff it is running from
> the initrd. If it is run from the main system it should not set that and
> just be shut down like any other service.

Well, there are two cases to consider:

1/ user starts the array manually and stops it with mdadm -Ss (mdmon
automatically shuts down).  No need for a service mdmon just follows
the lifespan of the array.

2/ user starts the array but then expects it to be around until system shutdown

In the latter case let the initramfs-mdmon takeover all arrays with
"mdmon --takeover --all".  But if all arrays may eventually be
re-parented to an mdmon instance from /run, why not always start mdmon
from there?
