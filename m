From: Luca Berra <bluca@comedia.it>
Subject: Re: RFC - device names and mdadm with some reference to udev.
Date: Tue, 28 Oct 2008 07:21:37 +0100
Message-ID: <20081028062137.GB7764@percy.comedia.it>
References: <18692.62860.863118.727187@notabene.brown> <20081027082257.GB1801@piper.oerlikon.madduck.net> <1225120416.4845.128.camel@firewall.xsintricity.com> <20081027161000.GG17300@skl-net.de> <ac3eb2510810270937i3acd7c94r2817b8f4c79babec@mail.gmail.com> <20081027165949.GC3061@piper.oerlikon.madduck.net> <ac3eb2510810271131q5aa682d7r7150734e5056feb6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <ac3eb2510810271131q5aa682d7r7150734e5056feb6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: Andre Noll <maan@systemlinux.org>, Doug Ledford <dledford@redhat.com>, Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Michal Marek <mmarek@novell.com>
List-Id: linux-raid.ids

On Mon, Oct 27, 2008 at 07:31:57PM +0100, Kay Sievers wrote:
>On Mon, Oct 27, 2008 at 17:59, martin f krafft <madduck@debian.org> wrote:
>> also sprach Kay Sievers <kay.sievers@vrfy.org> [2008.10.27.1737 +0100]:
>>> It's very simple to setup and follows the same logic as udev running
>>> in the rootfs, There is absolutely no "increase of complexity"
>>> involved if you use udev in the real root anyway, you just copy the
>>> binaries and the rules, and on bootup you wait for /dev/root to show
>>> up, mount it and start /sbin/init. Custom busybox stuff does not
>>> support any non-trivial feature a "general purpose" distro needs to
>>> support today.
>>
>> I would love to see some explicit instructions, then I could carry
>> them into Debian,
>
>What do you miss from the Ubuntu setup?
>
>> which is currently using full-blown udev with
>> initramfs.
>
>Which is the right thing to do, yes.
>
i believe it is overkill
initramfs should have the sole purpose of finding and mounting the root
filesystem, there is no need in packing it with unneeded junk.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
