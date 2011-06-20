From: Phil Turmel <philip@turmel.org>
Subject: Re: Issues with auto assembling or RAID10 (imsm) on boot
Date: Mon, 20 Jun 2011 16:16:05 -0400
Message-ID: <4DFFAA85.9060402@turmel.org>
References: <C70A636B101FD44999B82525C3E92AFAD36F3E@otis.burlington.evertz.tv> <4DFF9C19.1080801@turmel.org> <C70A636B101FD44999B82525C3E92AFAD36F71@otis.burlington.evertz.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <C70A636B101FD44999B82525C3E92AFAD36F71@otis.burlington.evertz.tv>
Sender: linux-raid-owner@vger.kernel.org
To: Sandra Escandor <sescandor@evertz.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/20/2011 03:55 PM, Sandra Escandor wrote:
> Hi Phil,
> 
> Attached is the complete dmesg. The last chunk of it is where I manually
> assemble the RAID after boot.
> 
> I just want to make sure I mention this if this is important: I built
> this from source and then I ran make install. I couldn't see any
> documentation that would suggest that I had to do anything else in /etc/
> (such as an init script - maybe this is what I need? I don't know enough
> about the inner workings of Linux just yet).

Based on the dmesg, you aren't using raid for your boot or root disks, so its not really an initramfs issue (or doesn't have to be).  It is almost certainly a missing initscript, or missing runlevel configuration for an initscript.  Unfortunately, I'm not terribly familiar with the ubuntu init system, so I can't point at anything specific to check.

By mentioning building from source, I assume you mean the mdadm package?  If so, you are probably missing the initscript and configuration files that ubuntu packages with mdadm to make their entire system "seamless".  Is there something you need from the latest and greatest mdadm?

Also, anyone else care to jump in?

Phil
