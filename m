From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Is my raid setup speed ok?!
Date: Wed, 19 Nov 2003 14:52:59 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200311191953.hAJJr3E25545@www.watkins-home.com>
References: <1069261606.16549.399.camel@aluminum>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1069261606.16549.399.camel@aluminum>
To: 'Matthew Mitchell' <matthew@geodev.com>
Cc: 'James R Bamford' <jim@jimtreats.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sysctl...That's new to me, thanks!

Guy

-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Matthew Mitchell
Sent: Wednesday, November 19, 2003 12:07 PM
To: Guy
Cc: 'James R Bamford'; linux-raid@vger.kernel.org
Subject: RE: Is my raid setup speed ok?!

On Wed, 2003-11-19 at 10:49, Guy wrote:

> It would be nice if /proc/mdstat would display the current min and max
speed
> limits.  It would also be nice if there was a place you could set them
just
> once.  Maybe /etc/raidtab.  Maybe a new file /etc/md.conf.  I would prefer
> to have an overall throughput speed limit, and a per array group speed
> limit.  The overall throughput speed limit would not be per disk, but
total
> disk i/o.

Setting it at boot time is a job for sysctl.  See /etc/sysctl.conf
and/or man sysctl.

-m


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html


