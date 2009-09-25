From: Neil Brown <neilb@suse.de>
Subject: Re: RAID1 assembled broken array
Date: Fri, 25 Sep 2009 18:12:07 +1000
Message-ID: <19132.31575.349988.442763@notabene.brown>
References: <h8ophd$n8p$6@ger.gmane.org>
	<9F2F4760-DF0C-4416-89AC-C689177AD4ED@redhat.com>
	<65549e07fd6559855af68b60783213c3.squirrel@neil.brown.name>
	<20090917082528.GO5174@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Thursday September 17
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: Doug Ledford <dledford@redhat.com>, Matthias Urlichs <matthias@urlichs.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday September 17, maan@systemlinux.org wrote:
> On 07:01, NeilBrown wrote:
> > > Wrong lesson.  The correct lesson to gather from this is to prefer
> > > version 1.1 or 1.2 superblocks wherever possible.  Superblocks at the
> > > beginning of the device disappear when there is no partition table,
> > > superblocks at the end can be confused for superblocks belonging to
> > > the whole device when there is no partition table.
> > 
> > 1.0 also protects from this problem.  The 1.x metadata stores the
> > offset of the superblock from the start of the device.  That will appear
> > to be wrong if you find a partition-superblock when reading from a
> > whole-device, so mdadm will reject the device as not having a valid
> > superblock.
> 
> BTW: Why are new arrays still created with 0.90 metadata format by
> default?

Because I'm a chicken....

I guess it probably is time ... but to we make the default 1.0, which
is compatible with people's expectations, to 1.1 which is generally a
safer approach (you cannot mount a bare device by mistake).

Of course a distro can import their own default using the CREATE line
in mdadm.conf.


NeilBrown
