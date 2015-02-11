From: Phil Turmel <philip@turmel.org>
Subject: Re: ignoring %s as it reports %s as failed
Date: Tue, 10 Feb 2015 21:26:45 -0500
Message-ID: <54DABDE5.4040305@turmel.org>
References: <54DA29C4.2010000@lentijn.sess.ink>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54DA29C4.2010000@lentijn.sess.ink>
Sender: linux-raid-owner@vger.kernel.org
To: Valentijn <v@lentijn.sess.ink>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Valentijn,

On 02/10/2015 10:54 AM, Valentijn wrote:
> Hello list,
> 
> This is a repost - I sent it to linux-raid back in January, but you were
> all still having holidays - or hangovers or anything.

Lots of work travel for me for the past year or so. :-(  I'm sorry we
couldn't help then.

> So the "Active device 32768" seems to be the culprit here, is that correct?

Yup.

> I managed to get it *working* again by recreating it with:
> ./mdadm --create --assume-clean --data-offset=136 -e 1.2 --level=5
> --bitmap=none --raid-devices=4 --chunk=64 /dev/md99 /dev/mapper/disk1p5
> /dev/mapper/disk2p5 /dev/mapper/disk3p5 missing
> 
> ... but that feels a bit rude.

Indeed.  Many people use --create to their eventual dismay.  But --force
won't fix a misrecorded device role.

> So, is there a "proper" way to reassemble this array?

I would dig around in the superblock to fix the role.  Not terribly
user-friendly though.

A carefully constructed --create --assume-clean would have been my next
recommended step, preferably with a bootable thumb drive with the latest
stable kernel and latest mdadm version.

Phil
