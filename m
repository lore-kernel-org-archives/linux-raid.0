From: "Kay Sievers" <kay.sievers@vrfy.org>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Mon, 27 Oct 2008 17:37:38 +0100
Message-ID: <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com>
References: <18692.62860.863118.727187@notabene.brown>
	 <20081027082257.GB1801@piper.oerlikon.madduck.net>
	 <1225120416.4845.128.camel@firewall.xsintricity.com>
	 <20081027161000.GG17300@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20081027161000.GG17300@skl-net.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Doug Ledford <dledford@redhat.com>, martin f krafft <madduck@debian.org>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 17:10, Andre Noll <maan@systemlinux.org> wrote:
> On 11:13, Doug Ledford wrote:
>
>> > I would really like to have a clear separation of competencies.
>> > Ideally, mdadm never creates any devices but leaves it all to udev,
>> > and all configuration about alternate names ("symlinks") is done in
>> > the udev rules file.
>>
>> This would then require that we have a working udev in our initrd
>> images.  It would greatly increase the complexity of early booting as a
>> result.
>
> Given that the initramfs usually contains busybox, one can also using
> mdev. It's much simpler than udev and it's good enough if the only
> thing you want to do is mounting the root partition that resides on
> a software raid array.

Depends on your definition of "usual". Debian, Fedora, openSUSE,
Ubuntu, Gentoo (as far as Gentoo counts as a distro with a default
setup) none of them uses any busybox/mdev setup, and all use udev in
initramfs.

It's very simple to setup and follows the same logic as udev running
in the rootfs, There is absolutely no "increase of complexity"
involved if you use udev in the real root anyway, you just copy the
binaries and the rules, and on bootup you wait for /dev/root to show
up, mount it and start /sbin/init. Custom busybox stuff does not
support any non-trivial feature a "general purpose" distro needs to
support today.

Kay
