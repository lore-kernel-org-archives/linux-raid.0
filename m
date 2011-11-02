From: Lennart Poettering <lennart@poettering.net>
Subject: Re: [systemd-devel] systemd kills mdmon if it was started manually
 by user
Date: Thu, 3 Nov 2011 00:35:56 +0100
Message-ID: <20111102233555.GB20729@tango.0pointer.de>
References: <20110208172822.GC21847@tango.0pointer.de>
 <CAA9_cmfhUyenz2B1=wDsUtKcrj-5uOURproUemje37bPpM4-Qw@mail.gmail.com>
 <20111031110613.GA1402@tango.0pointer.de>
 <20111102114416.7879b77f@notabene.brown>
 <20111102011615.GA5289@tango.0pointer.de>
 <20111102130334.09c3ab51@notabene.brown>
 <20111102133223.GC5119@tango.0pointer.de>
 <CAPXgP12RsaFeGK+dQ2hwFjQawhN+QDn1+K8t6jkJ-XSRyautJw@mail.gmail.com>
 <20111102151749.GE5119@tango.0pointer.de>
 <CABE8wwub+7FGWK4MttvPj16TkWus=jn=qt+7ANwtRZqG_pyshg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CABE8wwub+7FGWK4MttvPj16TkWus=jn=qt+7ANwtRZqG_pyshg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: Kay Sievers <kay.sievers@vrfy.org>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, Andrey Borzenkov <arvidjaar@mail.ru>, systemd-devel@lists.freedesktop.org
List-Id: linux-raid.ids

On Wed, 02.11.11 10:21, Williams, Dan J (dan.j.williams@intel.com) wrote:

> > That means we'd:
> >
> > a) patch systemd to check whether argv[0][0] of a process is '@' and
> > owned by root and exclude it from killing on shutdown.
> >
> > b) patch mdmon to set argv[0][0] of itself to '@' iff it is running from
> > the initrd. If it is run from the main system it should not set that and
> > just be shut down like any other service.
> 
> Well, there are two cases to consider:
> 
> 1/ user starts the array manually and stops it with mdadm -Ss (mdmon
> automatically shuts down).  No need for a service mdmon just follows
> the lifespan of the array.
> 
> 2/ user starts the array but then expects it to be around until system shutdown
> 
> In the latter case let the initramfs-mdmon takeover all arrays with
> "mdmon --takeover --all".  But if all arrays may eventually be
> re-parented to an mdmon instance from /run, why not always start mdmon
> from there?

Well I am not sure how mdmon works, but let's say you booted up with an
initrd lacking mdmon. Then, while the machine is up you set up a some md
device, and start mdmon for that. At this point it will be independent
of the initrd. But that should be OK since at shutdown time it can be
detached cleanly without any special magic, too, since mdmon is not
stored on that md device. So if you boot from md you need mdmon in the
initrd. If you just use md outside of the root disk, then running mdmon
as a normal service (i.e. one that is shut down like any other) should
be perfectly fine.

This why I suggested that only mdmon run from the initrd should set
argv[0][0] = '@', because only that one needs the special handling that
it cannot be terminated properly on shut down. The one running from the
normal system can be treated like a standard systemd service.

Lennart

-- 
Lennart Poettering - Red Hat, Inc.
