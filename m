From: Sharif Islam <mislam@ux1.cso.uiuc.edu>
Subject: Re: bad /proc/mdstat message
Date: Mon, 12 Jan 2004 13:36:07 -0600 (CST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.GSO.4.31.0401121332250.10838-100000@staff2.cso.uiuc.edu>
References: <20040112185909.GH17845@matchmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20040112185909.GH17845@matchmail.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 12 Jan 2004, Mike Fedyk wrote:

> On Mon, Jan 12, 2004 at 12:28:37PM -0600, Sharif Islam wrote:
> > I am getting the following message:
> > mdadm: bad /proc/mdstat line starts : Event:
> >
> >
> > I wasn't able to figure out the reason. My array is acting normal and
> > /proc/mdstat looks ok to me.
> >
> > # cat /proc/mdstat
> > Personalities : [linear] [raid0]
> > read_ahead 1024 sectors
> > Event: 1
> > md0 : active linear hdl[5] hdk[4] hdh[3] hdg[2] hdf[1] hde[0]
> >       703324416 blocks 64k rounding
> >
> > unused devices: <none>
> >
> > Any hints?
>
> Did you see anything in your logs?
Nope, no errors and such.
-----
kjournald starting.  Commit interval 5 seconds
EXT3 FS 2.4-0.9.19, 19 August 2002 on md(9,1), internal journal
EXT3-fs: mounted filesystem with ordered data mode.
----
I think this is something linear raid specific. I have another machine
with RAID 5 and I don't have the Event: 1 line there either.



