From: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Subject: Re: [PATCH RESEND] Monitor: fix for regression with container devices
Date: Fri, 13 Feb 2015 16:29:36 +0100
Message-ID: <54DE1860.8030507@intel.com>
References: <1423476830-15635-1-git-send-email-artur.paszkiewicz@intel.com> <20150211153814.333cb17a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150211153814.333cb17a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, pawel.baldysiak@intel.com
List-Id: linux-raid.ids

On 02/11/2015 05:38 AM, NeilBrown wrote:
> On Mon,  9 Feb 2015 11:13:50 +0100 Artur Paszkiewicz
> <artur.paszkiewicz@intel.com> wrote:
>
> > This patch fixes 2 problems introduced by commit 9a518d8: not closing a
> > file descriptor and ignoring container devices. Array state is always
> > "inactive" for containers, so we make sure that the device is not a
> > container by reading also the "level" sysfs entry.
> >
> > Signed-off-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> > Reviewed-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > ---
> >  Monitor.c | 14 ++++++++++----
> >  1 file changed, 10 insertions(+), 4 deletions(-)
> >
> > diff --git a/Monitor.c b/Monitor.c
> > index 971d2ec..66d67ba 100644
> > --- a/Monitor.c
> > +++ b/Monitor.c
> > @@ -483,11 +483,17 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
> >              strncmp(buf,"inact",5) == 0) {
> >              if (fd >= 0)
> >                  close(fd);
> > -            if (!st->err)
> > -                alert("DeviceDisappeared", dev, NULL, ainfo);
> > -            st->err++;
> > -            return 0;
> > +            fd = sysfs_open(st->devnm, NULL, "level");
> > +            if (fd < 0 || read(fd, buf, 10) != 0) {
> > +                if (fd >= 0)
> > +                    close(fd);
> > +                if (!st->err)
> > +                    alert("DeviceDisappeared", dev, NULL, ainfo);
> > +                st->err++;
> > +                return 0;
> > +            }
> >          }
> > +        close(fd);
> >      }
> >      fd = open(dev, O_RDONLY);
> >      if (fd < 0) {
>
> Thanks for the patch.
>
> I don't think I agree with the logic of using 'level' though.
> For the sort of arrays  that I need to ignore here, 'level' will be empty.
>
> It would make sense to test 'metadata' though.  If that starts 'external:',
> then we don't want to ignore the array.
>
> Could you confirm that this works please?
>
Hi Neil,

I tested your patch. I assume you wanted to use 'metadata_version',
because there is no 'metadata' attribute, right? I had also thought
about that, but simply looking for 'external:' is not enough to
determine that the array is a container - for volumes inside the
container it looks like this: 'external:/md127/0'. But I think that the
arrays you want to ignore will just have 'none' there, so maybe it can
be done like this?

diff --git a/Monitor.c b/Monitor.c
index 971d2ec..83daf3b 100644
--- a/Monitor.c
+++ b/Monitor.c
@@ -483,11 +483,18 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
                    strncmp(buf,"inact",5) == 0) {
                        if (fd >= 0)
                                close(fd);
-                       if (!st->err)
-                               alert("DeviceDisappeared", dev, NULL, ainfo);
-                       st->err++;
-                       return 0;
+                       fd = sysfs_open(st->devnm, NULL, "metadata_version");
+                       if (fd < 0 || read(fd, buf, 4) < 0 ||
+                           strncmp(buf, "none", 4) == 0) {
+                               if (fd >= 0)
+                                       close(fd);
+                               if (!st->err)
+                                       alert("DeviceDisappeared", dev, NULL, ainfo);
+                               st->err++;
+                               return 0;
+                       }
                }
+               close(fd);
        }
        fd = open(dev, O_RDONLY);
        if (fd < 0) {

Thanks,
Artur

> Thanks,
> NeilBrown
>
> diff --git a/Monitor.c b/Monitor.c
> index 971d2ecbea72..6e085cb24993 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -483,11 +483,18 @@ static int check_array(struct state *st, struct mdstat_ent *mdstat,
>              strncmp(buf,"inact",5) == 0) {
>              if (fd >= 0)
>                  close(fd);
> -            if (!st->err)
> -                alert("DeviceDisappeared", dev, NULL, ainfo);
> -            st->err++;
> -            return 0;
> +            fd = sysfs_open(st->devnm, NULL, "metadata");
> +            if (fd < 0 || read(fd, buf, 9) != 9 ||
> +                strncmp(buf, "external:", 9) != 0) {
> +                if (fd >= 0)
> +                    close(fd);
> +                if (!st->err)
> +                    alert("DeviceDisappeared", dev, NULL, ainfo);
> +                st->err++;
> +                return 0;
> +            }
>          }
> +        close(fd);
>      }
>      fd = open(dev, O_RDONLY);
>      if (fd < 0) {
>

