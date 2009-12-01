From: Artur Wojcik <artur.wojcik@intel.com>
Subject: Re: [patch 1/1][mdadm] Fix needed to enable RAID volumes on SAS
 devices (version 2).
Date: Tue, 1 Dec 2009 12:52:05 +0100
Message-ID: <1259668325.2798.127.camel@awojcik-linux>
References: <58C655507FA1494D95397652C4416F35CCF61201@irsmsx503.ger.corp.intel.com>
	 <20091113193545.GW21495@skl-net.de>
	 <1259593942.3178.123.camel@awojcik-linux>
	 <e9c3a7c20911301156k7fc7fac7i33c8de14b0bb4d23@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <e9c3a7c20911301156k7fc7fac7i33c8de14b0bb4d23@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: Andre Noll <maan@systemlinux.org>, Neil Brown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

Hi Dan,
Thank you for your comments. All you suggestions I will incorporate in
next version of a patch. Please see my comments below.

> better alternative is to use the "stg mail" command from Stacked GIT
> which, among other things, will format the patch according to akpm's
> "perfect patch" guidelines [1].

Definitely I should follow your suggestion.

> > @@ -899,19 +900,12 @@ static int imsm_enumerate_ports(const char
> > *hba_path, int port_count, int host_b
> >                }
> >
> >                /* retrieve the scsi device type */
> > -               if (asprintf(&device, "/sys/dev/block/%d:%d/device/xxxxxxx", major,
> > minor) < 0) {
> > -                       if (verbose)
> > -                               fprintf(stderr, Name ": failed to allocate 'device'\n");
> > -                       err = 2;
> > -                       break;
> > -               }
> > -               sprintf(device, "/sys/dev/block/%d:%d/device/type", major, minor);
> > +               str_fmt(device, "/sys/dev/block/%d:%d/device/type", major, minor);
> 
> Admittedly this change isn't needed because asprintf has guaranteed
> that the buffer is large enough, but I can see why you made the change
> if the goal is eradication of all sprintf calls.

Yes, that is my intention and if you are ok with this I would keep it.

> > @@ -1425,6 +1428,36 @@ void append_metadata_update(struct supertype *st,
> > void *buf, int len)
> >  }
> >  #endif /* MDASSEMBLE */
> >
> > +/* Copyright (C) 2009 Intel Corporation. All rights reserved.
> > + *
> 
> It is not conventional to claim copyright on a per function basis.

These are Intel guidelines, but I clarify this with Intel SQA.

> > + * This function formats a string according to format pattern. The
> > buffer is
> > + * always null terminated even if source string does not fit in
> > destination
> > + * buffer. The function returns -1 in case of an error and this means
> > + * either one of the input parameters is NULL or there's not enough
> > space in
> > + * destination buffer to fit even a single character. Otherwise the
> > function
> > + * returns the number of character put in the destination buffer.
> > + */
> > +int __str_fmt(char *buf, size_t buf_size, const char *fmt, ...)
> > +{
> > +       va_list vl;
> > +
> > +       if (((int)(--buf_size)) <= 0) {
> 
> This seems wrong.  Why check buf_size? Just let the normal return
> value from vnsprintf indicate if the buffer is too small.  Also it
> clips potentially valid sizes that appear negative when casting from
> size_t to int.

You right. I assumed no one will request buffers bigger then INT_MAX,
but this is wrong assumption. I agree the better solution is to let
vnsprintf() function to resolve this issue.

> > +extern int __str_fmt(char *buf, size_t buf_size, const char *fmt, ...)
> > +       __attribute__((format(printf, 3, 4)));
> 
> I don't like that this function silently does not work with pointers,
> and its name belies the fact that it does checking in addition to
> formatting.
> 
> Perhaps something can be done with gcc builtins for this case.  Have
> you looked into __builtin_object_size, __builtin___snprintf_chk and
> friends.  The goal being to use these builtins to:
> 
> 1/ Get a compile time warning when an overflow is detected (currently
> supported by the builtins)
> 2/ Get a compile time warning if the bounds cannot be checked at
> compile time (would need some investigation)

I will investigate this and correct the patch.
--
Artur


