From: Neil Brown <neilb@suse.de>
Subject: Re: Proper partition type for components with V1.x superblocks?
Date: Mon, 7 Jul 2008 13:17:48 +1000
Message-ID: <18545.35548.800516.532854@notabene.brown>
References: <484F9A3E.7020709@rabbit.us>
	<18512.25940.653867.623185@notabene.brown>
	<486BFB03.7060100@zytor.com>
	<1215062276.14196.6.camel@firewall.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Doug Ledford on Thursday July 3
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 3, dledford@redhat.com wrote:
> On Wed, 2008-07-02 at 15:02 -0700, H. Peter Anvin wrote:
> > 
> > Why 0xDA?
> > 
> > As far as I know, the closest thing there is to a registry is the list 
> > that aeb at least used to maintain.

Yes. 
http://www.win.tue.nl/~aeb/partitions/partition_types-1.html
lists 0xDA as

    da Non-FS Data

        Added on request of John Hardin (johnh@aproposretail.com).

which is the closest we could come to "you won't want to look at
or do anything to this partition".

> 
> Actually, if you are going to use version 1 superblocks anyway, then
> just list the partitions as normal linux partitions.  The whole
> linux-raid-autodetect partition type was originally only for auto detect
> at bootup.  If you weren't using that feature, then standard linux type
> was good enough.  And if you use version 1.1 or 1.2 superblocks, then
> you really don't have anything to worry about since the location of the
> superblock and the data start offset means that the partition won't get
> accidentally recognized as a non-raid partition.

But if you use 1.0, then some well-meaning install program might mount
one drive from a raid1 as a filesystem, write to it, and get your RAID
all out of sync.

The whole point of this exercise was to find a way to make sure code
that took the partition type to mean something didn't make the wrong
decision.  0xDA seems the best answer for that.

NeilBrown
 
