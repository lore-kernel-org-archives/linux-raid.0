From: dean gaudet <dean-list-linux-raid@arctic.org>
Subject: Re: recovery of hosed raid5 array
Date: Sun, 26 Oct 2003 13:29:04 -0800 (PST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0310261325410.20038@twinlark.arctic.org>
References: <slrnbog9og.t0c.lunz@orr.homenet> <no.Yo.24973.N.nN.0310111457280@business.com>
 <slrnboirt8.me8.lunz@orr.homenet> <Pine.LNX.4.58.0310121034090.7866@twinlark.arctic.org>
 <20031026194051.GA4511@matchmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031026194051.GA4511@matchmail.com>
To: Mike Fedyk <mfedyk@matchmail.com>
Cc: Jason Lunz <lunz@falooley.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 26 Oct 2003, Mike Fedyk wrote:

> On Sun, Oct 12, 2003 at 10:39:50AM -0700, dean gaudet wrote:
> >
> > querying SMART shouldn't cause this to happen -- but i've seen it occur
> > with a promise controller and maxtor disks.  i used to query the SMART
> > data once a night just to have a log.  then i switched it to once every 5
> > minutes so i could graph the drive temperature... and when i went to once
> > every 5 minutes the system became unstable.  the kernel would randomly
> > lose the ability to talk to a disk.  the problem would go away after a
> > reboot.  i assume it was some sort of race condition.
>
> 1.  Were they maxtor 160GB 8MB cache drives?

no they were 6L080J4 ... 80GB D740X.  attached to both ultra100tx2 and
ultra133tx.  this was also long enough ago that the promise driver was
still the single driver, not the newer driver.  who knows what the problem
really was.

-dean
