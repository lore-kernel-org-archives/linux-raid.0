From: Ryan Wagoner <rswagoner@gmail.com>
Subject: Re: mdadm vs zfs for home server?
Date: Tue, 28 May 2013 11:55:14 -0400
Message-ID: <CAGExVfsDE1+ZhhReUzVfKvwSkdoRyEj0P+_riZi0hBx0M9sYng@mail.gmail.com>
References: <20130527180912.GA6068@septictank.raw-sewage.fake>
	<51A3DF2B.7070200@hardwarefreak.com>
	<20130528152412.GB1357@septictank.raw-sewage.fake>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130528152412.GB1357@septictank.raw-sewage.fake>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, May 28, 2013 at 11:24 AM, Matt Garman <matthew.garman@gmail.com> wrote:
> And, based on what I've read about ZFS, since it knows about the
> data, it only resyncs ("resilvers" in zfs lingo) actual data, not
> the whole drive.  So depending on how full the array is, resilvering
> could take even less time.
>
> That should therefore *decrease* the chances of another disk failing
> during rebuild/resilver, right?  That is, if rebuild times are
> proportional to the amount of actual disk utilization (which is
> assumed to be less than 100%).

Yep ZFS will only resilver used space. When I was testing failure
scenarios with a few GB of data the resilver would complete in
seconds. Additionally if there is an unrecoverable error detected ZFS
will list the files affected. You can even have ZFS store multiple
copies of a file so if the above does happen it will replace the
damaged copy with a good copy.

Ryan
