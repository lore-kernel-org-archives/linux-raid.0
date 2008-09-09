From: "Jacobo Cabaleiro" <obmun.h@gmail.com>
Subject: Re: Addition of a partition to an existing RAID1 array overwrites disk partition table
Date: Tue, 9 Sep 2008 16:13:11 +0200
Message-ID: <e49f63fe0809090713v753f0cau8407dacccc6455cd@mail.gmail.com>
References: <e49f63fe0809090446v326ce59ag9d0095d05f85a43b@mail.gmail.com>
	 <20080909120623.GB20086@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080909120623.GB20086@cthulhu.home.robinhill.me.uk>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Sep 9, 2008 at 2:06 PM, Robin Hill <robin@robinhill.me.uk> wrote:
>
> On Tue Sep 09, 2008 at 01:46:56PM +0200, Jacobo Cabaleiro wrote:
>
> > Take a look at: http://pastebin.com/m341ee953. Real results executed
> > some minutes ago.
> >
> > Is there something obvious my stupid brain is not seeing? I've already
> > tried a search on kernel bugzilla and debian bugs, having not found
> > anything of interest.  Bug # 4211 is obviously not the problem here,
> > as I'm adding the partition to the array, not the full disk. Can this
> > be a bug?
> >
> The disk is actually reporting a different size here (7482 cylinders vs
> 8924 in the original report) so something very odd is happening.

Does the disk really "report" or it's just stored on the disk label? I
mean, where does fdisk get geometry info? I suppose it's printing the
one on the disk label.

>
>  Could
> be related to
> http://www.linux.org/docs/ldp/howto/LVM-HOWTO/sundisklabels.html?

Ooopps... I see clearly what you mean. I remember reading that info
about LVM some weeks ago, but I didn't linked it to this situation.
Raid1 must be writing some management info at the very beginning of
the partition, overwriting the sun disk label. I'll try moving the
partition 1 cyl from the beggining.

Thanks Robin and sorry for the noise.

>
> HTH,
>    Robin
> --
>     ___
>    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>   / / )      | Little Jim says ....                            |
>  // !!       |      "He fallen in de water !!"                 |
