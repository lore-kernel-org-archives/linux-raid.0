From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: Re: [RFC] super1: error handling for super-block loading
Date: Thu, 12 May 2016 14:16:19 -0400
Message-ID: <wrfj8tzfb0r0.fsf@redhat.com>
References: <5734BFA3.1070405@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5734BFA3.1070405@profitbricks.com> (Gioh Kim's message of "Thu,
	12 May 2016 19:38:43 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Gioh Kim <gi-oh.kim@profitbricks.com>
Cc: linux-raid@vger.kernel.org, Elmar Gerdes <elmar.gerdes@profitbricks.com>, Jinpu Wang <jinpu.wang@profitbricks.com>
List-Id: linux-raid.ids

Gioh Kim <gi-oh.kim@profitbricks.com> writes:
> I'm not sure yet why mdadm failed to load super-block of disks.
> I checked the kernel log and found I/O error from disks.
> Anyway mdadm needs to handle that error case.
>
> Please review following patch.
>
> ------------------------------------------- 8<
> -------------------------------------------------------------
> From 8cacf56b2d630c7e74bad942779ff7ed5f516d26 Mon Sep 17 00:00:00 2001
> From: Gioh Kim <gi-oh.kim@profitbricks.com>
> Date: Thu, 12 May 2016 19:09:45 +0200
> Subject: [PATCH] super1: error handling for super-block loading
>
> Loading super-block can fail if all sub-devices are faulty
> or have I/O errors.
>
> Signed-off-by: Gioh Kim <gi-oh.kim@profitbricks.com>
> ---
>  Grow.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)
>
> diff --git a/Grow.c b/Grow.c
> index f58c753..fa08522 100755
> --- a/Grow.c
> +++ b/Grow.c
> @@ -389,7 +389,7 @@ int Grow_addbitmap(char *devname, int fd, struct
> context *c, struct shape *s)
>      }
>      if (strcmp(s->bitmap_file, "internal") == 0 ||
>          strcmp(s->bitmap_file, "clustered") == 0) {
> -        int rv;
> +        int rv = 0;
>          int d;
>          int offset_setable = 0;
>          struct mdinfo *mdi;
> @@ -419,6 +419,7 @@ int Grow_addbitmap(char *devname, int fd, struct
> context *c, struct shape *s)
>                  if (fd2 < 0)
>                      continue;
>                  if (st->ss->load_super(st, fd2, NULL)==0) {
> +                    rv++;
>                      if (st->ss->add_internal_bitmap(
>                              st,
>                              &s->bitmap_chunk, c->delay, s->write_behind,
> @@ -435,6 +436,10 @@ int Grow_addbitmap(char *devname, int fd, struct
> context *c, struct shape *s)
>                  close(fd2);
>              }
>          }
> +        if (rv == 0) {
> +            pr_err("failed to load super-block.\n");
> +            return 1;
> +        }
>          if (offset_setable) {
>              st->ss->getinfo_super(st, mdi, NULL);
>              sysfs_init(mdi, fd, NULL);

This is definitly not the right way to solve this problem. Error codes
are negative, and zero should _always_ mean success. Here you suddenly
introduced a new meaning to positive values of rv.

I agree handling the error case needs to be fixed, so a better way to
solve this would be to bail out when the load_super() call fails and
stop there, the same way it does if add_internal_bitmap() fails.

Ie. make it do something like this:

	rv = st->ss->load_super(st, fd2, NULL)==0) {
	if (!rv) {
		if (st->ss->add_internal_bitmap(
....
	} else {
		pr_err("failed to load super-block.\n");
		close(fd2);
		return 1;
	}

Actually looking at that code, there's a couple of things to do to clean
it up and make it more readable.

Cheers,
Jes
