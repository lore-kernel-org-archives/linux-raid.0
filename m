From: David Rees <drees76@gmail.com>
Subject: Re: help with bad performing raid6
Date: Thu, 30 Jul 2009 14:09:19 -0700
Message-ID: <72dbd3150907301409t5ea20979gcf400e4c53a32d62@mail.gmail.com>
References: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cccedfc60907271219n1f3431c4w50033d4f5bc43edc@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon Nelson <jnelson-suse@jamponi.net>
Cc: LinuxRaid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jul 27, 2009 at 12:19 PM, Jon Nelson<jnelson-suse@jamponi.net> wrote:
> When I say "bad performance" I mean writes that vary down to 100KB/s
> or less, as reported by rsync. The "average" end-to-end speed for
> writing large (500MB to 5GB) files hovers around 3-4MB/s. This is over
> 100 MBit.

That doesn't sound too unexpected.  rsync does a lot of reading and
writing, so you're going to see less than network speeds.

> Often times while stracing rsync I will see rsync not make a single
> system call for sometimes more than a minute. Sometimes well in excess
> of that. If I look at the load on the server the top process is
> md0_raid5 (the raid6 process for md0, despite the raid5 in the name).
> The load hovers around 8 or 9 at this time.

High load seems a bit abnormal, but not too bad.  You probably have 8
nfsd daemons running on the server?

> Even during this period of high load, actual disk I/O is fairly low.
> I can get 70-80MB/s out of the actual underlying disks the entire time.
> Uncached.

Seems about right.

> vmstat reports up to 20MB/s writes (this is expected given 100Mbit and
> raid6) but most of the time it hovers between 2 and 6 MB/s.

Also seems about right, but you shouldn't be seeing more than 10MB/s
writes - the limit of 100Mbps network.

> What can I do to improve performance?

You might try the --inplace option of rsync.  By default, rsync will
create a copy of the file while it rebuilds it from the source, then
move the copy over the original when it's done.

Since you said you're dealing with large files, you could be
performing a lot of extra IO that doesn't necessarily need to be done
if you are migrating changes to large files over.

You could try rsync over SSH instead of directly over NFS.  That way,
only the changes will get transferred over the network instead of the
entire file being read over the network.

> Why is the load so high on the server? The client is absolutely bored
> (load less than 0.5 most of the time).

Load probably climbs to about the number of NFS daemons you have running.

> Is this some weird interaction between NFS(v3) and software raid6?

Probably not.

-Dave
