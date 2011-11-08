From: "Williams, Dan J" <dan.j.williams@intel.com>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Tue, 8 Nov 2011 14:29:54 -0800
Message-ID: <CABE8wwuicjHn2EafAyJTLmjTzYFxX5r9+e1jS0H=6cSgGbaV9Q@mail.gmail.com>
References: <20110208094843.GD11446@tango.0pointer.de>
	<AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
	<20110208110730.GF23157@tango.0pointer.de>
	<AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
	<20110208172822.GC21847@tango.0pointer.de>
	<CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
	<20111031110613.GA1402@tango.0pointer.de>
	<20111102114416.7879b77f@notabene.brown>
	<20111102011615.GA5289@tango.0pointer.de>
	<20111102130334.09c3ab51@notabene.brown>
	<20111102133223.GC5119@tango.0pointer.de>
	<4EB873C9.5020900@ziu.info>
	<4EB95CDA.4090904@ziu.info>
	<4EB991C7.9080904@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EB991C7.9080904@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <soltys@ziu.info>
Cc: Lennart Poettering <lennart@poettering.net>, NeilBrown <neilb@suse.de>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Nov 8, 2011 at 12:32 PM, Michal Soltys <soltys@ziu.info> wrote:
> On 11-11-08 17:46, Michal Soltys wrote:
>>
>> Then even existing intiramfs image could (probably) be mdmon-agnostic.
>
> Actually:
>
> chroot /run/initramfs mdmon --takeover --all

One of the suggestion earlier in the thread is not mess with takeover
at all.  The rootfs md device is always monitored by a mdmon instance
launched from /run/initramfs.  The only way to update mdmon is to
recreate the initramfs and reboot (which is similar to the experience
of trying to update raidfoo.ko for the rootfs blockdev).
