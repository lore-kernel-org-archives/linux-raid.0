From: Mike Hardy <mhardy@h3c.com>
Subject: Re: No syncing after crash. Is this a software raid bug?
Date: Wed, 01 Mar 2006 08:24:58 -0800
Message-ID: <4405CADA.3070204@h3c.com>
References: <20060301124432.GA3591@hactar.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20060301124432.GA3591@hactar.lan>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Why would you not be happy? resyncs in general are bad since they
indicate your data is possibly out-of-sync and the resync itself
consumes an enormous amount of resources

This is a feature of new-ish md driver code that more aggressively marks
the array as "clean" after writes

The end result is that the array will most likely be "clean" in all
circumstances even a crash, and you simply won't need to resync

That's a good thing!

-Mike

Kasper Dupont wrote:
> I have a FC4 installation (upgraded from FC3) using kernel
> version 2.6.15-1.1831_FC4. I see some symptoms in the software
> raid, which I'm not quite happy about.
> 
> After an unclean shutdown caused by a crash or power failure,
> it does not resync the md devices. I have tried comparing the
> contents of the two mirrors for each of the md devices. And I
> found that on the swap device, there were differences.
> 
> Isn't this a bug in the software raid? Shouldn't it always
> resync after reboot, if there could possibly be any difference
> between the contents on the two disks?
> 
> I know that as long as only swap is affected, it is not going
> to cause data loss. But how can I be sure it is not going to
> happen on file systems as well?
> 
> Should I report this as a bug in Fedora Core or did I miss
> something?
> 
