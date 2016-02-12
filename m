From: Marc MERLIN <marc@merlins.org>
Subject: Re: md raid5 on top of dmcrypt, or dmcrypt on top of md raid5?
Date: Fri, 12 Feb 2016 11:07:00 -0800
Message-ID: <20160212190700.GQ13969@merlins.org>
References: <20160211162959.GG13969@merlins.org>
 <alpine.DEB.2.02.1602121020570.11524@uplift.swm.pp.se>
 <wrfja8n62e0c.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <wrfja8n62e0c.fsf@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Mikael Abrahamsson <swmike@swm.pp.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Feb 12, 2016 at 09:34:59AM -0500, Jes Sorensen wrote:
> Mikael Abrahamsson <swmike@swm.pp.se> writes:
> > On Thu, 11 Feb 2016, Marc MERLIN wrote:
> >
> >> But can someone confirm that indeed if I have a single md device,
> >> and 4 CPUs, my throughput is not limited by a single CPU decrypting
> >> the device?
> >
> > There have been multiple discussions about this over time, and since
> > you didn't qualify "not good" with a number, it's hard to say if this
> > is your problem or not.
> 
> About a year ago when I last received a new laptop, I put btrfs on top
> of luks - it was a rather miserable experience. The system would freeze
> up and be really slow.
> 
> I believe the issue was btrfs not acting well with crypto underneath it,
> and there was hallway talk confirming this but I have no hard data. In
> the end I gave up and put my /home on xfs on top of LUKS and used btrfs
> for the uncrypted portions.
> 
> It may be the btrfs with crypto issues have been resolved since then.

Thanks all for the feedback and experiences.

"not good" is indeed subjective, I can see the kernel hanging for a few
seconds at a time under heavy I/O and cron jobs taking too long.

I'm indeed going to just rebuild the FS with a new layout, and try
bcache in the process.

I still need to figure out what I should use as best chunk size for
mdadm, whether this is reasonable:
cryptsetup luksFormat --align-payload=8192 -s 256 -c aes-xts-plain                                     
and see if there are tuning parameters in bcache I should worry about.

Thanks,
Marc
-- 
"A mouse is a device used to point at the xterm you want to type in" - A.S.R.
Microsoft is to operating systems ....
                                      .... what McDonalds is to gourmet cooking
Home page: http://marc.merlins.org/                         | PGP 1024R/763BE901
