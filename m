From: Scott McDermott <vaxerdec@frontiernet.net>
Subject: Re: RAID5 reconfig
Date: Sun, 19 Jan 2003 22:48:34 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030119224834.G1276@newbox.localdomain>
References: <000f01c2ae90$3e9c4eb0$6500a8c0@system> <20030120001941.GB23750@unthought.net> <000701c2c032$4785e410$6500a8c0@system>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <000701c2c032$4785e410$6500a8c0@system>; from systemloc@earthlink.net on Sun, Jan 19, 2003 at 10:16:08PM -0500
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

TJ on Sun 19/01 22:16 -0500:
> I fscked before resize2fs, but forgot to do it again afterwards and
> mounted the filesystem and used it.

You should not have to.  I have never used e2fsck after resize2fs and
have never had a problem with perhaps a couple dozen resizes.
