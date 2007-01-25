From: Neil Brown <neilb@suse.de>
Subject: Re: Synchronous mdadm --add/--re-add operations
Date: Fri, 26 Jan 2007 09:19:24 +1100
Message-ID: <17849.11500.153192.854079@notabene.brown>
References: <20070125220031.GA30106@aym.net2.nerim.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Majorel on Thursday January 25
Sender: linux-raid-owner@vger.kernel.org
To: Andre Majorel <aym-xunil@teaser.fr>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday January 25, aym-xunil@teaser.fr wrote:
> How do I serialise mdadm --add/--re-add calls other than by
> writing some shell to poll /proc/mdstat ? Is there a way to make
> mdadm synchronous i.e., waiting until the operation completes or
> fails instead of starting it in the background and returning.

Something has to poll mdstat (or some /sys file).
In mdadm-2.6 where is a '-W' option which will wait for
resync/recovery to complete. So
  mdadm /dev/mdX -add /dev/thing
  mdadm -W /dev/mdX

might be what you want.

NeilBrown
