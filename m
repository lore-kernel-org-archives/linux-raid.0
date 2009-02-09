From: Ray Van Dolson <rvandolson@esri.com>
Subject: Re: raid1 + 2.6.27.7 issues
Date: Mon, 9 Feb 2009 09:53:49 -0800
Message-ID: <20090209175348.GA1462@esri.com>
References: <cccedfc60902090836n76e5e6e6mfd149db5ac2f5d2b@mail.gmail.com> <C5B60EA5.C47B%groups@email.iain.rauch.co.uk> <20090209165940.GA805@esri.com> <cccedfc60902090949sec3336u661cea5fbb96e246@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <cccedfc60902090949sec3336u661cea5fbb96e246@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-linux-raid@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 09, 2009 at 09:49:21AM -0800, Jon Nelson wrote:
> On Mon, Feb 9, 2009 at 10:59 AM, Ray Van Dolson <rvandolson@esri.com> wrote:
> > On Mon, Feb 09, 2009 at 08:47:33AM -0800, Iain Rauch wrote:
> >> > The typical use case for me is this: I will run the array (/dev/md11) in
> >> > degraded mode (without /dev/nbd0) for a week or so.
> >> > At some point, I will try to synchronize the underlying devices.
> >>
> >> Sounds like rsync is more suited to your application.
> >> Why are you using RAID?
> >>
> >> Iain
> >
> > Seems academic to me.  Whatever the reasons, the above _should_ work
> > should it not?
> >
> > Could this be NBD's fault somehow?
> 
> I don't think so. This is how I *remove* the nbd device:
> 
> mdadm /dev/md11 --fail /dev/nbd0
> sleep 3
> mdadm /dev/md11 --remove /dev/nbd0
> 
> and then finally nbd-client -d /dev/nbd0
> 
> If necessary, I can try to simulate the problem by using a local
> logical volume or some such.

Don't want to send you on a wild goose chase, but I'd be interested to
see the results of that and maybe the results of the same with an iSCSI
backed blocked device vs nbd.

I just thought there were some subtle differences between NBD and other
"SAN" over network protocols.  No idea how they'd play into the
scenario you're describing however.

Ray
