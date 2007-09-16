From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: MD RAID1 performance very different from non-RAID partition
Date: Mon, 17 Sep 2007 00:08:05 +0200
Message-ID: <878x765kmy.fsf@informatik.uni-tuebingen.de>
References: <46EB6D67.1000802@quo.to>
	<20070915070914.GA21515@teal.hq.k1024.org> <46EC2043.5010006@quo.to>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <46EC2043.5010006@quo.to> (Jordan Russell's message of "Sat, 15
	Sep 2007 13:11:15 -0500")
Sender: linux-raid-owner@vger.kernel.org
To: Jordan Russell <jr-list-2007@quo.to>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jordan Russell <jr-list-2007@quo.to> writes:

> Iustin Pop wrote:
>> Maybe it's because md doesn't support barriers whereas the disks
>> supports them? In this case some filesystems, for example XFS, will work
>> faster on raid1 because they can't force the flush to disk using
>> barriers.
>
> It's an ext3 partition, so I guess that doesn't apply?
>
> I tried remounting /dev/sda2 with the "barrier=0" option (which I assume
> disables barriers, looking at the source), though, just to see if it
> would make any difference, but it didn't; the database build still took
> 31 minutes.

Compare the read ahead settings.

MfG
        Goswin
