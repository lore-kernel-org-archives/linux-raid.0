From: Ian Dall <ian@beware.dropbear.id.au>
Subject: Re: Proposed enhancement to mdadm:  Allow "--write-behind=" to be
	done	in grow mode.
Date: Wed, 04 Jul 2007 12:00:03 +0930
Message-ID: <1183516204.17720.16.camel@sibyl.beware.dropbear.id.au>
References: <1183038727.3792.9.camel@sibyl.beware.dropbear.id.au>
	 <1183130939.4544.6.camel@sibyl.beware.dropbear.id.au>
	 <1183468329.395.59.camel@sibyl.beware.dropbear.id.au>
	 <468A571E.7040304@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <468A571E.7040304@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: David Greaves <david@dgreaves.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2007-07-03 at 15:03 +0100, David Greaves wrote:
> Ian Dall wrote:
> > There doesn't seem to be any designated place to send bug reports and
> > feature requests to mdadm, so I hope I am doing the right thing by
> > sending it here.
> > 
> > I have a small patch to mdamd which allows the write-behind amount to be
> > set a array grow time (instead of currently only at grow or create
> > time). I have tested this fairly extensively on some arrays built out of
> > loop back devices, and once on a real live array. I haven't lot any data
> > and it seems to work OK, though it is possible I am missing something.
> 
> Sounds like a useful feature...
> 
> Did you test the bitmap cases you mentioned?

Yes. And I can use mdadm -X to see that the write behind parameter is
set in the superblock. I don't know any way to monitor how much the
write behind feature is being used though.

My motivation was for doing this was to enable me to experiment to see
how effective it is. Currently I have a Raid 0 array across 3 very fast
(15k rpm) scsi disks. This array is mirrored by a single large vanilla
ata (7.2k rpm) disk. I figure that the read performance of the
combination is basically the read performance of the Raid 0, and the
sustained write performance is basically that of the ata disk, which is
about 6:1 read to write speed. I also see typically about 6 times the
read traffic to write traffic. So I figure it should be close to optimal
IF the bursts of write activity are not too long.

Does anyone know how I can monitor the number of pending writes? Where
are these queued? Are they simply stuck on the block device queue (and I
could see with iostat) or does the md device maintain its own special
queue for this?


Ian
-- 
Ian Dall <ian@beware.dropbear.id.au>
