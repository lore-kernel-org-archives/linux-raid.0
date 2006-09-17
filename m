From: "Tuomas Leikola" <tuomas.leikola@gmail.com>
Subject: Re: scrub was Re: RAID5 Problem - $1000 reward for help
Date: Sun, 17 Sep 2006 16:21:15 +0300
Message-ID: <5b170a7d0609170621s695e4badl84bbd28d727dd8b0@mail.gmail.com>
References: <20060915090856.GD27597@boom.net>
	 <B7838FAF-BD7D-4581-8E5C-8CB896AA3CC0@develooper.com>
	 <5b170a7d0609170436w18fc6ff3r713284436c394fa7@mail.gmail.com>
	 <200609171446.01130.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609171446.01130.Dexter.Filmore@gmx.de>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 9/17/06, Dexter Filmore <Dexter.Filmore@gmx.de> wrote:
> > > > It's recommended to use a script to scrub the raid device regularly,
> > > > to detect sleeping bad blocks early.
> > >
> > > What's the best way to do that?  dd the full md device to /dev/null?
> >
> > echo check >/sys/block/md?/md/sync_action
> >
> > Distros may have cron scripts to do this "right".
> >
> > And you need a fairly recent kernel.
>
> Does this test stress the discs a lot, like a resync?
> How long does it take?
> Can I use it on a mounted array?
>

yup.
long. think resync.
yup.

It's practically "read everything, verify checksum, report bad blocks
or inconsistencies".

echo repair>sync_action causes md to fix redundancy blocks if they're
out of sync (but at that point you already have another problem like
flakey hardware or so)
