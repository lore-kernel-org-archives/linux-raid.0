From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually by user
Date: Mon, 24 Oct 2011 10:04:59 +0200
Message-ID: <201110241005.00072.thomas.jarosch@intra2net.com>
References: <20101204121413.GC11336@mother.pipebreaker.pl> <20110208172822.GC21847@tango.0pointer.de> <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Lennart Poettering <lennart@poettering.net>, Andrey Borzenkov <arvidjaar@mail.ru>, Tomasz Torcz <tomek@pipebreaker.pl>, systemd-devel@lists.freedesktop.org, linux-raid@vger.kernel.org, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On Sunday, 23. October 2011 10:00:36 Dan Williams wrote:
> Is it time for a libmd.so, so systemd can invoke the "--wait-clean --scan"
> process itself?  Probably simpler to just SIGTERM mdmon and wait for it.

The mdadm code makes good use of non-reentrant functions like ctime(), 
readdir() and others. Luckily systemd is single threaded.

If we provide a "public" interface, that would need fixing though.

Cheers,
Thomas
