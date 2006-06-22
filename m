From: "Christian Pernegger" <pernegger@gmail.com>
Subject: Re: Ok to go ahead with this setup?
Date: Thu, 22 Jun 2006 21:50:49 +0200
Message-ID: <bb145bd20606221250y147d0a0bk1e371a3078adc09e@mail.gmail.com>
References: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com>
	 <62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Pentium D 930
>
> HPA recently said that x86_64 CPUs have better RAID5 performance.

Good to know. I did intend to use Debian-amd64 anyway.

> Is it a NAS kind of device?

Yes, mostly. It also runs a caching NNTP proxy and drives our
networked audio players :)
Personal file server describes it best, I think.

> In that case, drop the 2x 300GB disks and get 6x 500GB instead.  You
> can partition those so that you have a RAID1 spanning the first 10GB
> of all 6 drives for use as the system partition, and use the rest in a
> RAID5.

Good idea, it's just that I already have the listed disks, and I need
at least 150 GB effective capacity on the mirror for important work
data, not just the OS. Anything specific wrong with the Maxtors?

> > * Should I use the 300s as a single mirror, or span multiple ones over
> > the two disks?
>
> What would the purpose be?

I read somewhere that this could reduce rebuild time when a "disk"
(partition in this case) is kicked offline because of a timeout or
somesuch. Sounds a bit fishy, which is why I'm asking.

> > * Am I even correct in assuming that I could stick an array in another
> > box and have it work?
>
> Work for what?

Well, access to the data. The point of the whole exercise is that I
don't want to be cut off from my data, just because a part of the host
(not the disks) died.

> Get gigabit nics, in case you want to fiddle with iSCSI? :-)

The board has one or two Intel Gb NICs, they usually work fine ...

And iSCSI sounds way too expensive. :)

Thanks,

C.
