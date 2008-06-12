From: David Greaves <david@dgreaves.com>
Subject: Re: RAID5 losing initial synchronization on restart when one disk
 is spare
Date: Thu, 12 Jun 2008 09:03:56 +0100
Message-ID: <4850D86C.70402@dgreaves.com>
References: <48466AD9.5@free.fr> <18512.25477.431367.952164@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18512.25477.431367.952164@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Hubert Verstraete <hubskml@free.fr>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> When writing to the array, the new parity block will sometimes be
> calculated assuming that it was previously correct.  If all updates to
> a particular parity block are of this sort, then it will still be
> incorrect when you lose a drive, and data recovered based on that
> parity block will be incorrect.
> 
> Until you lose a drive, it will have no visible effect.

There is a slight chance that this happened to me recently - would a
  echo check > /sys/block/mdX/md/sync_action
detect this?
and would
  echo repair > /sys/block/mdX/md/sync_action
fix it?

David
