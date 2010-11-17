From: Neil Brown <neilb@suse.de>
Subject: Re: How to recreate a dmraid RAID array with mdadm (was: no
 subject)
Date: Wed, 17 Nov 2010 12:53:37 +1100
Message-ID: <20101117125337.2ca80775@notabene.brown>
References: <BAY148-w337E193E7493BB69F27B31EF350@phx.gbl>
	<20101115162122.4fef2542@notabene.brown>
	<BAY148-w211AE8BF243615980CE527EF380@phx.gbl>
	<20101117122647.48c7b67a@notabene.brown>
	<4CE3325B.7050208@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4CE3325B.7050208@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Mike Viau <viaum@sheridanc.on.ca>, linux-raid@vger.kernel.org, debian-user@lists.debian.org
List-Id: linux-raid.ids

On Wed, 17 Nov 2010 01:39:39 +0000
John Robinson <john.robinson@anonymous.org.uk> wrote:

> On 17/11/2010 01:26, Neil Brown wrote:
> > On Tue, 16 Nov 2010 20:02:17 -0500
> > Mike Viau<viaum@sheridanc.on.ca>  wrote:
> [...]
> >> DEVICE partitions
> >> HOMEHOST<system>
> >> ARRAY metadata=imsm UUID=084b969a:0808f5b8:6c784fb7:62659383
> >> ARRAY /dev/md/OneTB-RAID1-PV container=084b969a:0808f5b8:6c784fb7:62659383 member=0 UUID=ae4a1598:72267ed7:3b34867b:9c56497a
> [...]
> > I would really expect that mdadm.conf file to successfully assemble the
> > RAID1.
> 
> The only thing that strikes me is that "DEVICE partitions" line - surely 
> imsm containers don't live in partitions?

No, they don't.

But "DEVICE partitions" actually means "any devices listed
in /proc/partitions", and that includes whole devices.
:-(

NeilBrown


> 
> Cheers,
> 
> John.

