From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: RAID 6 Failure follow up
Date: Mon, 09 Nov 2009 07:01:53 +1300
Message-ID: <4AF70791.9080007@sauce.co.nz>
References: <4AF6D0A9.6000901@gmail.com> <4AF6D461.3050109@gmail.com> <4AF6D5FD.2010602@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AF6D5FD.2010602@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Andrew Dunn <andrew.g.dunn@gmail.com>
Cc: Roger Heflin <rogerheflin@gmail.com>, robin@robinhill.me.uk, linux-raid list <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Andrew Dunn wrote:

> Do you think that the controller is dropping out? I know that I have 4
> drives on one controller (AOC-USAS-L8i) and 5 drives on the other
> controller (SAME make/model). but I think they are sequentially
> connected... as in sd[efghi] should be on one device and sd[jklm] should
> be on the other... any easy way to verify?

If you are running smartd, cease doing so and do not use the smartctl 
command on drives attached to these controllers - use causes drives to 
be offlined.

It appears the smartctl is broken with LSISAS 1068E based controllers.

See:

https://bugzilla.redhat.com/show_bug.cgi?id=452389

and

http://marc.info/?l=linux-scsi&m=125673590221135&w=2

Regards,

Richard

