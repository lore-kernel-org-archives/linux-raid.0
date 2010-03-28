From: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Subject: Re: metadata 1.2
Date: Sun, 28 Mar 2010 09:22:46 +0200
Message-ID: <20100328072246.GB3408@lazy.lzy>
References: <20100326194352.GA2474@lazy.lzy>
 <4877c76c1003261849k9219c1eq7e8ebde088b619df@mail.gmail.com>
 <20100327091658.GA2333@lazy.lzy>
 <20100328065831.GA13933@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20100328065831.GA13933@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

> this was discussed nearly one year ago.
> look for the thread "md extension to support booting from raid whole
> disks". Unfortunately that thread turned to an holy war. But before
> that, Neil said he planned on offering an option to reserve some space,
> i believe after the superblock, to host non-raid data.

interesting, I'll have a look.

> >Actually, I would like to propose metadata 2.0, or
> >dual RAID, where the superblock is located somewhere
> the issue would be, how do you locate that piece of metadata?

That would be the easiest part.
Since the bootmanager should know how to boot, it will
know also where to look for the superblock and pass this
information to the kernel.
Or it would be possible to have some "fixed" place to look.

I think a reasonable solution is possible.

bye,

-- 

piergiorgio
