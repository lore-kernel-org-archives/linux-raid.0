From: "Dan Williams" <dan.j.williams@intel.com>
Subject: Re: is this raid5 OK ?
Date: Thu, 29 Mar 2007 22:51:28 -0700
Message-ID: <e9c3a7c20703292251v7cbbda6eg212e0bb6246f62ae@mail.gmail.com>
References: <237230840.20070329193857@kaneda.iguw.tuwien.ac.at>
	 <17932.22575.558925.535963@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17932.22575.558925.535963@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 3/29/07, Neil Brown <neilb@suse.de> wrote:
> On Thursday March 29, rfu@kaneda.iguw.tuwien.ac.at wrote:
> > hi,
> >
> > I manually created my first raid5 on 4 400 GB pata harddisks:
> >
> > [root@server ~]# mdadm --create --verbose /dev/md0 --level=5 --raid-devices=4 --spare-devices=0 /dev/hde1 /dev/hdf1 /dev/hdg1 /dev/hdh1
> > mdadm: layout defaults to left-symmetric
> > mdadm: chunk size defaults to 64K
> > mdadm: size set to 390708736K
> > mdadm: array /dev/md0 started.
> >
> > but, mdstat shows:
> >
> > [root@server ~]# cat /proc/mdstat
> > Personalities : [raid6] [raid5] [raid4]
> > md0 : active raid5 hdh1[4] hdg1[2] hdf1[1] hde1[0]
> >       1172126208 blocks level 5, 64k chunk, algorithm 2 [4/3] [UUU_]
> >
> > unused devices: <none>
> >
> > I'm surprised to see that there's one "failed" device [UUU_] ?
> > shouldn't it read [UUUU] ?
>
> It should read "UUU_" at first while building the 4th drive
> (rebuilding a missing drive is faster that calculating and writing all
> the parity blocks).  But it doesn't seem to be doing that.
>
> What kernel version?  Try the latest 2.6.x.y in that series.
>
I have seen something similar with older versions of mdadm when
specifying all the member drives at once.  Does the following kick
things into action?

mdadm --create /dev/md0 -n 4 -l 5 /dev/hd[efg]1 missing
mdadm --add /dev/md0 /dev/hdh1

--
Dan
