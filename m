From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Confused about reshape?
Date: Mon, 31 May 2010 00:32:07 -0500
Message-ID: <A6.8D.28437.6D9430C4@cdptpa-omtalb.mail.rr.com>
References: <20100531145027.73d85ffe@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100531145027.73d85ffe@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> Just tell mdadm what you want and it will do it, or report that it cannot.

	Um, OK, I tried it, and it failed:

Backup:/# mdadm --grow /dev/md0 --level=6
mdadm: no changes to --grow



