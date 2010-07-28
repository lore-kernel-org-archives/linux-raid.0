From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: md versus partition scanning (bd_invalidated)
Date: Wed, 28 Jul 2010 12:23:11 -0700
Message-ID: <AANLkTinNOo1_-KJ2CC_-ACBaDtmWjGX3+Vy60ND17guH@mail.gmail.com>
References: <1279741966.25713.31.camel@dwillia2-linux>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1279741966.25713.31.camel@dwillia2-linux>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>, Tejun Heo <htejun@gmail.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-raid <linux-raid@vger.kernel.org>, "Neubauer, Wojciech" <Wojciech.Neubauer@intel.com>, Ed Ciechanowski <ed.ciechanowski@intel.com>
List-Id: linux-raid.ids

On Wed, Jul 21, 2010 at 12:52 PM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> Hi,
>
> We (Intel software raid devs) are seeing a problem with the detection=
 of
> partitions on md devices. =A0The trace below shows that the block dev=
ice
> inode is dropped in-between when the array comes up and when it is fi=
rst
> opened (timestamp 655.498875). =A0When this happens bdev->bd_invalida=
ted
> is cleared by bdget() and we never detect partitions. =A0(Seen on a 2=
=2E6.32
> based kernel, but I presume it is still present)

The kernel in question was missing commit f3b99be1 "Restore partition
detection of newly created md arrays" [1].  With that in place the
problem goes away.  I haven't fully convinced myself that there isn't
a small race that could be triggered by changing the array size via
sysfs, to get the the gendisk size updated and then dropping all inode
references prior to the first open... but I'll put that investigation
on the back burner.

--
Dan

[1]: http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux-2.6.git=
;a=3Dcommitdiff;h=3Df3b99be1
