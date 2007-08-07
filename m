From: Neil Brown <neilb@suse.de>
Subject: Re: Linux RAID migration
Date: Tue, 7 Aug 2007 20:22:34 +1000
Message-ID: <18104.18410.623573.929770@notabene.brown>
References: <c70ff3ad0708070116k20605787pf897f9eccc93cd65@mail.gmail.com>
	<5b170a7d0708070126t52cb4be5x4549b22bac643450@mail.gmail.com>
	<c70ff3ad0708070302g1d23f4c8qd53c230d4118fd51@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from saeed bishara on Tuesday August 7
Sender: linux-raid-owner@vger.kernel.org
To: saeed bishara <saeed.bishara@gmail.com>
Cc: Tuomas Leikola <tuomas.leikola@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday August 7, saeed.bishara@gmail.com wrote:
> > 2. should be simple as (offline) re-creating the raid as raid5.
> this didn't work, I created raid1 array on sda[12], then stopped it,
> and created new raid5 on sda[123], the data on the raid1 was not
> preserved.

Create the new raid5 on sda[12] (same 2 devices as the raid1) and it
will work.  Then grow to make it raid5 on 3 drives if you want.

> >
> > > - can I really assume that RAID 5 on 2 hdds (degraded mode) will
> > > function as raid 5?
> >
> > You should test by using loopback devices and files. But why degraded?
> > raid5 of two disks should look like raid1.
> I meant to ask whether raid 5 on 2 disks will function as raid1 :(

A 2-disk raid5 and a 2-disk raid1 put the data in exactly the same
place - is that what you wanted to know?

NeilBrown
