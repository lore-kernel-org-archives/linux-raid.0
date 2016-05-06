From: Mike Lovell <mike.lovell@endurance.com>
Subject: Re: problems with lots of arrays
Date: Fri, 6 May 2016 11:02:40 -0600
Message-ID: <CAK9wOaDLu+edK5R=U61mTb3+OP2=QNotExsZzu2Sce-qLCVHcA@mail.gmail.com>
References: <CAK9wOaB+Cic3nR5kzB3n=nVpbRtfo8+Qr9j_VNM3hh5tJRw6YA@mail.gmail.com>
	<87k2j7vg8m.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87k2j7vg8m.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <nfbrown@novell.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, May 6, 2016 at 12:43 AM, NeilBrown <nfbrown@novell.com> wrote:
> I know why newer kernels don't seem to support more than 512 array.
>
> Commit: af5628f05db6 ("md: disable probing for md devices 512 and over.")
>
>
> You can easily use many more md devices by using a newish mdadm and
> setting
>
>    CREATE names=yes
>
> in /etc/mdadm.conf
>
> You cannot use names like "md512" because that gets confusing, but any
> name that isn't a string of digits is fine.  e.g. create /dev/md/foo
> and the array will be named "md_foo" in the kernel rather than "md127".
>
> I guess this qualifies as a regression and regressions are bad.....
> But I really wanted to be able to have arrays that didn't get magically
> created simply because you open a file in /dev.  That just leads to
> races with udev.
>
> The magic number "512" appears three times in the kernel.
>
>                 /* find an unused unit number */
>                 static int next_minor = 512;
>
> and
>
>         blk_register_region(MKDEV(MD_MAJOR, 0), 512, THIS_MODULE,
>                             md_probe, NULL, NULL);
> and
>         blk_unregister_region(MKDEV(MD_MAJOR,0), 512);
>
> A boot parameter which set that to something larger would probably be OK
> and would solve your immediate problem.
>
> But if you could transition to using named arrays instead of numbered
> arrays - even if that are "/dev/md/X%d", that would be be good I think.
>
> NeilBrown

we actually do specify the name to mdadm --create and mdadm --assemble
and have a naming scheme from our own internal tools. the problem we
were running into was that mdadm would auto-generate a minor number
that was invalid but we also don't have "CREATE names=yes" in
mdadm.conf. i'll have to experiment with that one.

thanks
mike
