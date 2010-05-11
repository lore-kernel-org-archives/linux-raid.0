From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC PATCH 0/2] a couple of readonly handling fixups
Date: Tue, 11 May 2010 11:06:48 -0700
Message-ID: <AANLkTilViY9QWurh9QN07zShPt9rPlfCOVVtH7896yoz@mail.gmail.com>
References: <20090108072023.9577.3585.stgit@dwillia2-linux.ch.intel.com>
	 <18803.46655.134295.118861@nbeee.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18803.46655.134295.118861@nbeee.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jan 18, 2009 at 4:07 PM, Neil Brown <neilb@suse.de> wrote:
> On Thursday January 8, dan.j.williams@intel.com wrote:
>> The BUG_ON(mddev->ro =3D=3D 1) in md_write_start can be triggered un=
der two
>> circumstances in recent kernels. =A0One was reported by Justin Magga=
rd:
>
> Hi Dan,
> =A0Thanks for following up with this.....
>
> (I meant to send this over a week ago, but I've been on vaction
> in Tasmania and my mobile has no coverage....)
>
[..]
>> =A0 =A0 =A0 md: set mddev readonly flag on blkdev BLKROSET ioctl
>
> This one I'm happy with. =A0I'll make sure it gets through.

This slippery bugger seems to have evaded upstream, do you want me to r=
esend?

Here is a link for reference:
http://marc.info/?l=3Dlinux-raid&m=3D123139948817348&w=3D2

I have seen another report of the md_write_start() BUG_ON triggering
so I'm wondering if there are other ways for mddev->ro and
bdev->bd_part->policy to get out of sync, or if they are just hitting
the bug that this patch fixes?

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
