From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Mon, 31 Oct 2011 12:15:20 +0100
Message-ID: <20111031111520.GA3874@tango.0pointer.de>
References: <AANLkTik189VTXYpzLFqP=MNBg=Nx-Yq6BOKURtiby++B@mail.gmail.com>
 <20110125042814.GA9727@tango.0pointer.de>
 <AANLkTik7dd5SHkuBVrS6LLDR9v57GsFjjxDKQKPp-YVL@mail.gmail.com>
 <20110208094843.GD11446@tango.0pointer.de>
 <AANLkTi=rFoqBwKdd0B3Xx6JrGdJdut0a2r=wFh0oSx73@mail.gmail.com>
 <20110208110730.GF23157@tango.0pointer.de>
 <AANLkTinmO9gsJcwr+0bGGuVJfF2dyM5rDJqqSkmh_hqs@mail.gmail.com>
 <20110208172822.GC21847@tango.0pointer.de>
 <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
 <20111031110613.GA1402@tango.0pointer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20111031110613.GA1402@tango.0pointer.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On Mon, 31.10.11 12:06, Lennart Poettering (lennart@poettering.net) wrote:

> We actually try to disassemble md already, i.e. we call the
> DM_DEV_REMOVE ioctl for all left-over devices. I am not really
> interested to link against libdm itself.

Sorry, wasn't fully woken up yet and mixed up dm and md here. Ignore
this sentence...

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
