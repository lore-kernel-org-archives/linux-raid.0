From: Matthew Mitchell <matthew@geodev.com>
Subject: RE: Is my raid setup speed ok?!
Date: Wed, 19 Nov 2003 11:06:46 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1069261606.16549.399.camel@aluminum>
References: <200311191649.hAJGnTE25045@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200311191649.hAJGnTE25045@www.watkins-home.com>
To: Guy <bugzilla@watkins-home.com>
Cc: 'James R Bamford' <jim@jimtreats.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 2003-11-19 at 10:49, Guy wrote:

> It would be nice if /proc/mdstat would display the current min and max speed
> limits.  It would also be nice if there was a place you could set them just
> once.  Maybe /etc/raidtab.  Maybe a new file /etc/md.conf.  I would prefer
> to have an overall throughput speed limit, and a per array group speed
> limit.  The overall throughput speed limit would not be per disk, but total
> disk i/o.

Setting it at boot time is a job for sysctl.  See /etc/sysctl.conf
and/or man sysctl.

-m


