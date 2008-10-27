From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 19:31:57 +0100
Message-ID: <ac3eb2510810271131q5aa682d7r7150734e5056feb6@mail.gmail.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <20081027082257.GB1801@piper.oerlikon.madduck.net>
	 <1225120416.4845.128.camel@firewall.xsintricity.com>
	 <20081027161000.GG17300@skl-net.de>
	 <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com>
	 <20081027165949.GC3061@piper.oerlikon.madduck.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081027165949.GC3061@piper.oerlikon.madduck.net>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>, Andre Noll <maan@systemlinux.org>, Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Mare
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 17:59, martin f krafft <madduck@debian.org> wrote:
> also sprach Kay Sievers <kay.sievers@vrfy.org> [2008.10.27.1737 +0100]:
>> It's very simple to setup and follows the same logic as udev running
>> in the rootfs, There is absolutely no "increase of complexity"
>> involved if you use udev in the real root anyway, you just copy the
>> binaries and the rules, and on bootup you wait for /dev/root to show
>> up, mount it and start /sbin/init. Custom busybox stuff does not
>> support any non-trivial feature a "general purpose" distro needs to
>> support today.
>
> I would love to see some explicit instructions, then I could carry
> them into Debian,

What do you miss from the Ubuntu setup?

> which is currently using full-blown udev with
> initramfs.

Which is the right thing to do, yes.

Kay
