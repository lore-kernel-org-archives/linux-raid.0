From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: 800G RAID5 w/ what FS?
Date: Tue, 6 Apr 2004 09:19:51 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0404060918480.23220@router.windsormachine.com>
References: <40719357.8050209@ocis.net> <40719CCA.8010709@wasp.net.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <40719CCA.8010709@wasp.net.au>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 5 Apr 2004, Brad Campbell wrote:

> I was using ext3 on a 720GB array, and now a 1.4TB array. I have no problems with it besides the 3-4
> hour fsck time when I decide to force a fsck :p)

Ext3 on a 700gb raid5 off a 3ware 7500-4lp.  Only problems I've had is
that the latency to do anything more with the disk goes sky high when
there's a lot of disk activity.

Which may or may not be related to the 700gb partition :)

Mike
