From: Lorac Thelmwood <lorac.web@gmail.com>
Subject: Re: corrupt raid 5
Date: Wed, 4 Jan 2006 22:14:18 -0800
Message-ID: <5981e8c80601042214p4096de18reed2ce669b7dc764@mail.gmail.com>
References: <5981e8c80601031907l6d612bfcsf4a81826efc97f@mail.gmail.com>
	 <17339.20993.529499.281141@smtp.charter.net>
	 <5981e8c80601032135p312a37e0kf8c4e3d6edd05e53@mail.gmail.com>
	 <17340.13263.40580.460585@smtp.charter.net>
	 <5981e8c80601042213j7e4b42gb71690d634ce0050@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5981e8c80601042213j7e4b42gb71690d634ce0050@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/4/06, Lorac Thelmwood <lorac.web@gmail.com> wrote:
> failed to RUN_ARRAY /dev/md1: Invalid argument
>
>
> I don't think it will start even whe the reconstruction is complete to
> due to that bad superblock
>
> On 1/4/06, John Stoffel <john@stoffel.org> wrote:
> > >>>>> "Lorac" == Lorac Thelmwood <lorac.web@gmail.com> writes:
> > >>
> > Lorac> First I can't start the array because it complains about a bad
> > Lorac> superblock.
> >
> > Have you tried forcing the start of the array with the --force flag?
> > Something like this:
> >
> >         mdadm -A --run /dev/md1
> >
> > Please give the output of the command.
> >
> > Lorac> What's the output of 'cat /proc/mdstat' and 'mdadm
> > >> --detail /dev/md?' where ? is the number of your raid 5 array?
> >
> > Lorac> debian:~# cat /proc/mdstat
> > Lorac> Personalities : [raid1] [raid5]
> > Lorac> md1 : inactive hdh1[4] hdc1[0] hdg1[3] hdf1[2] hde1[1]
> > Lorac>       976791680 blocks
> >
> > This is the key info, the array is assembled, but it hasn't been
> > started properly, probably because of the missing disk.  Try the --run
> > args as above and see what it does for you.
> >
> > See how it says 'inactive', this means you need to get it running
> > first.
> >
> > Good luck,
> > John
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>
