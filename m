From: Gordon Henderson <gordon@drogon.net>
Subject: Re: mdadm and monitoring
Date: Wed, 8 Feb 2006 11:06:42 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0602081101090.18903@lion.drogon.net>
References: <2818693.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2818693.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: discman <ixguy@hotmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 8 Feb 2006, discman (sent by Nabble.com) wrote:

> Hi.
>
> Anyone with some experience on mdadm?

Just about everyone here, I'd hope ;-)

> I have a running RAID0-array with mdadm and it`s using monitor-mode with an
> e-mail address.
> Anyone knows how to remove that e-mail adress without deleting the raid?

It all depends on how you setup mdadm in the first place - or if it was
supplied with your distro.

mdadm will be running in monitor mode with flags something like:

  /sbin/mdadm -F -i /var/run/mdadm.pid -m root -f -s

The -m flag says who gets emailled. If it's started at boot-time then
you'll need to trace through the /etc/init.d/mdadm (probably) file to see
where it gets it's parameters from.

Debian (sarge) puts this email address directly in the /etc/init.d/mdadm
file, and stoping & starting the monitor process won't have any effect on
your array whatsoever.

Gordon
