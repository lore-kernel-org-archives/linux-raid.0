From: Holger Kiehl <Holger.Kiehl@dwd.de>
Subject: Re: Raid-5 long write wait while reading
Date: Wed, 23 May 2007 06:34:00 +0000 (GMT)
Message-ID: <Pine.LNX.4.64.0705230622320.14733@praktifix.dwd.de>
References: <4653306B.4090500@jager.no>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4653306B.4090500@jager.no>
Sender: linux-raid-owner@vger.kernel.org
To: Thomas Jager <lists@jager.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello

On Tue, 22 May 2007, Thomas Jager wrote:

> Hi list.
>
> I run a file server on MD raid-5.
> If a client reads one big file and at the same time another client tries to 
> write a file, the thread writing just sits in uninterruptible sleep until the 
> reader has finished. Only very small amount of writes get trough while the 
> reader is still working.
>
I assume from the vmstat numbers the reader does a lot of seeks (iowait > 80%!).

> I'm having some trouble pinpointing the problem.
> It's not consistent either sometimes it works as expected both the reader and 
> writer gets some transactions. On huge reads I've seen the writer blocked for 
> 30-40 minutes without any significant writes happening (Maybe a few 
> megabytes, of several gigs waiting). It happens with NFS, SMB and FTP, and 
> local with dd. And seems to be connected to raid-5. This does not happen on 
> block devices without raid-5. I'm also wondering if it can have anything to 
> do with loop-aes? I use loop-aes on top of the md, but then again i have not 
> observed this problem on loop-devices with disk backend. I do know that 
> loop-aes degrades performance but i didn't think it would do something like 
> this?
>
What IO scheduler are you using? Maybe try using a different scheduler
(eg. deadline) if that does make any difference.

Holger

