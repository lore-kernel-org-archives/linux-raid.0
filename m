From: Michal Soltys <soltys@ziu.info>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Tue, 08 Nov 2011 21:32:07 +0100
Message-ID: <4EB991C7.9080904@ziu.info>
References: <20110208094843.GD11446@tango.0pointer.de> <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com> <20110208110730.GF23157@tango.0pointer.de> <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com> <20110208172822.GC21847@tango.0pointer.de> <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com> <20111031110613.GA1402@tango.0pointer.de> <20111102114416.7879b77f@notabene.brown> <20111102011615.GA5289@tango.0pointer.de> <20111102130334.09c3ab51@notabene.brown> <20111102133223.GC5119@tango.0pointer.de> <4EB873C9.5020900@ziu.info> <4EB95CDA.4090904@ziu.info>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4EB95CDA.4090904@ziu.info>
Sender: linux-raid-owner@vger.kernel.org
To: Lennart Poettering <lennart@poettering.net>
Cc: NeilBrown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11-11-08 17:46, Michal Soltys wrote:
> Then even existing intiramfs image could (probably) be mdmon-agnostic.

Actually:

chroot /run/initramfs mdmon --takeover --all

worked just fine (after preparing new root - so after all mount --binds, 
and before pivot_root(8)).

So in context of systemd instead of sysv scripts - a fork / chroot / 
exec mdmon / wait - instead of killing it would do the thing, followed 
by pivot_to_new_root().

Actually anything that could benefit from "immortality" in one or the 
other way (perhaps udevd, so e.g. lvm doesn't need --noudevsync ? - when 
taken over inside dracut's shutdown or anything similar after going back 
to initramfs) that can be pre-chrooted into /run/initramfs and exec'ed, 
should work just fine. For the record, udevd worked properly with pivot 
survival.

