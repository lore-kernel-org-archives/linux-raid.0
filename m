From: Dave Reisner <d@falconindy.com>
Subject: Re: [PATCH] mdadm: autodetect being run in an initramfs
Date: Thu, 27 Sep 2012 18:53:02 -0400
Message-ID: <20120927225302.GY474@rampage>
References: <1348756863-21081-1-git-send-email-dreisner@archlinux.org>
 <20120928083518.12d53ea8@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20120928083518.12d53ea8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Dave Reisner <dreisner@archlinux.org>, linux-raid@vger.kernel.org, teg@jklm.no
List-Id: linux-raid.ids

On Fri, Sep 28, 2012 at 08:35:18AM +1000, NeilBrown wrote:
> On Thu, 27 Sep 2012 10:41:03 -0400 Dave Reisner <dreisner@archlinux.org>
> wrote:
> 
> > Key off of the existance of /etc/initrd-release as an indicator that
> > mdadm is running in early userspace and set the __offroot flag. This
> > allows the same udev-based assembly rules to be valid both off and on
> > root and, moreover, will propagate to mdmon, should it need to be
> > started.
> > 
> > Signed-off-by: Dave Reisner <dreisner@archlinux.org>
> > ---
> >  mdadm.c | 5 +++++
> >  1 file changed, 5 insertions(+)
> > 
> > diff --git a/mdadm.c b/mdadm.c
> > index 4c7c5ea..557e00b 100644
> > --- a/mdadm.c
> > +++ b/mdadm.c
> > @@ -1106,6 +1106,11 @@ int main(int argc, char *argv[])
> >  		exit(0);
> >  	}
> >  
> > +	/* auto-detect being on an initramfs
> > +	 * http://www.freedesktop.org/wiki/Software/systemd/InitrdInterface */
> > +	if (access("/etc/initrd-release", F_OK) == 0)
> > +		__offroot = 1;
> > +
> >  	if (!mode && devs_found) {
> >  		mode = MISC;
> >  		devmode = 'Q';
> 
> What is the problem with adding the --offroot flag to every place in the
> initrd that starts mdadm?

The assumption is that mdadm is being called via udev for assembly, so
we'd need to maintain a separate udev rule explicitly for the initramfs.
I'd rather not do that.

> (Actually I'm contemplating making --offroot the default so this might become
> a non-issue)

That'd be great!

