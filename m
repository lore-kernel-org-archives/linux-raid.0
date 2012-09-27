From: Dave Reisner <d@falconindy.com>
Subject: Re: [PATCH] mdadm: autodetect being run in an initramfs
Date: Thu, 27 Sep 2012 18:50:09 -0400
Message-ID: <20120927225009.GX474@rampage>
References: <1348756863-21081-1-git-send-email-dreisner@archlinux.org>
 <CANBHLUhSKfTHZwm_LHhfp-znNWzY6T9LmEVcsdrt6du-eQp3zA@mail.gmail.com>
 <CA+mSPTgDnq8Xi+xCZte1WtORZhnV8S0=FXsm=wM0N1LfLpgtfQ@mail.gmail.com>
 <CANBHLUi=kNQNdr6J7h4hbWZFdBUkf6XNdYWE1WYQo5AQ_t1aOw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CANBHLUi=kNQNdr6J7h4hbWZFdBUkf6XNdYWE1WYQo5AQ_t1aOw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dmitrijs Ledkovs <dmitrij.ledkov@surgut.co.uk>
Cc: Tom Gundersen <teg@jklm.no>, Dave Reisner <dreisner@archlinux.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Sep 27, 2012 at 11:29:48PM +0100, Dmitrijs Ledkovs wrote:
> On 27 September 2012 23:11, Dave Reisner <d@falconindy.com> wrote:
> >
> > On Sep 27, 2012 6:08 PM, "Dmitrijs Ledkovs" <dmitrij.ledkov@surgut.co.uk>
> > wrote:
> >>
> >> On 27 September 2012 15:41, Dave Reisner <dreisner@archlinux.org> wrote:
> >> > Key off of the existance of /etc/initrd-release as an indicator that
> >> > mdadm is running in early userspace and set the __offroot flag. This
> >> > allows the same udev-based assembly rules to be valid both off and on
> >> > root and, moreover, will propagate to mdmon, should it need to be
> >> > started.
> >> >
> >>
> >> And what shall non-systemd systems do?
> >
> > Add the file, of course!
> >
> >>
> >> I don't have /etc/initrd-release in my initramfs-tools generated
> >> initrd, and so far didn't have a usecase for it.
> >> Should it be an empty file?
> >>
> >
> > Yep, just an empty file. It only serves to be a marker since there really
> > isn't any other heuristic for detecting early userspace.
> >
> 
> This is a bit backwards. As far as I understand the systemd & udev
> merge now means that udev rules cannot spawn long running processes
> and instead should have a proper systemd units instead.

udev rules were never allowed to spawn long running processes. The
merger means nothing in this regard. The only point of this patch is
to ensure that mdmon is spawned via mdadm with the correct --offroot
flag so that it isn't mercilessly slaughtered later on. This auto-spawn
behavior happens today, but without the --offroot flag.

> And since systemd is running all of the initramfs surely it can set up
> an environment without adding pointless files, e.g. an environment
> variable?

How would such an environment variable be set?

Not everyone runs systemd in early userspace. To my knowledge, only
Fedora does this currently. However, everyone can only benefit from this
marker file in their initramfs. For those not running systemd at all,
the presence of this file has no perceivable effect.

> Please correct me, if I am wrong, cause I really don't understand
> either this patch or systemd or both.
> 
> 
> >>
> >> > Signed-off-by: Dave Reisner <dreisner@archlinux.org>
> >> > ---
> >> >  mdadm.c | 5 +++++
> >> >  1 file changed, 5 insertions(+)
> >> >
> >> > diff --git a/mdadm.c b/mdadm.c
> >> > index 4c7c5ea..557e00b 100644
> >> > --- a/mdadm.c
> >> > +++ b/mdadm.c
> >> > @@ -1106,6 +1106,11 @@ int main(int argc, char *argv[])
> >> >                 exit(0);
> >> >         }
> >> >
> >> > +       /* auto-detect being on an initramfs
> >> > +        *
> >> > http://www.freedesktop.org/wiki/Software/systemd/InitrdInterface */
> >> > +       if (access("/etc/initrd-release", F_OK) == 0)
> >> > +               __offroot = 1;
> >> > +
> >> >         if (!mode && devs_found) {
> >> >                 mode = MISC;
> >> >                 devmode = 'Q';
> >> > --
> >> > 1.7.12.1
> >> >
> >> > --
> >> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >> > the body of a message to majordomo@vger.kernel.org
> >> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
