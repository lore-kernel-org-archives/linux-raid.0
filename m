From: "Jonathan Baker-Bates" <jonathan@bakerbates.com>
Subject: RE: The right way to recover from md partition failure?
Date: Mon, 30 Aug 2004 22:50:28 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <NDBBJAGHALMCJCFDHBILMEPCENAA.jonathan@bakerbates.com>
References: <41339D1D.2040101@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41339D1D.2040101@dgreaves.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: David Greaves [mailto:david@dgreaves.com]
> Sent: 30 August 2004 22:33
> To: Guy
> Cc: 'Jonathan Baker-Bates'; linux-raid@vger.kernel.org
> Subject: Re: The right way to recover from md partition failure?
>
>
> I think a better approach might be:
>
> mdadm /dev/md1 -r /dev/hde3
> dd if=/dev/hde3 of=/dev/null

Why the /dev/null-ing?

> check logs for nasty errors and only continue if there weren't any :)
> mdadm /dev/md1 -a /dev/hde3
>
> Having done this very thing this afternoon!!
>
> If you have "some console messages about a bad block or something" then
> I'd make damn sure your disk is good before putting it back.
> If you end up doing lots of retries during the resync and an error
> occurs on a remaining drive you'll be sorry!
>
> In general a raid failure means you should suspect a disk failure.
>

Now it's the issue of making sure the disk is good that was worrying me. How
do I make sure? Hence my question to Guy about fsck.

Jonathan


