From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sat, 4 Apr 2009 00:57:19 -0500
Message-ID: <20090404055720.QDOH19140.cdptpa-omta03.mail.rr.com@Leslie>
References: <1238679355.4604.19.camel@cichlid.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1238679355.4604.19.camel@cichlid.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> The issue is the entire array will occasionally pause completely for
about
>> 40 seconds when a file is created. 

>I had symptoms like this once. It turned out to be a defective disk. The
>disk would never return a read or write error but just intermittently
>took a really long time to respond.

>I found it by running atop. All the other drives would be running at low
>utilization and this one drive would be at 100% when the symptoms
>occurred (which in atop gets colored red so it jumps out at you)

Thanks.  I gave this a try, but not being at all familiar with atop, I'm not
sure what, if anything, the results mean in terms of any additional
diagnostic data.  Depending somewhat upon the I/O load on the RAID array,
atop sometimes reports the drive utilization on several or all of the drives
to be well in excess of 85% - occasionally even 99%, but never flat 100% at
any time.  Oddly, even under relatively light loads of 20 or 30 Mbps,
sometimes the RAID members would show utilization in the high 90s, usually
on all the drives on a multiplier channel. I don't know if this is ordinary
behavior for atop, but all the drives also periodically disappear from the
status display.  Additionally, while atop is running and I am using my usual
video editor, Video Redo, on a Windows workstation to stream video from the
server, every time atop updates, the video and audio skip when reading from
a drive not on the RAID array.  I did not notice the same behavior from the
RAID array.  Odd.

Anyway, on to the diagnostics.

I ran both `atop` and `watch iostat 1 2` concurrently and triggered several
events while under heavy load ( >450 Mbps, total ). In atop, drives sdb,
sdd, sde, sdg, and sdi consistently disappeared from atop entirely, and
writes for the other drives fell to dead zero.  Reads fell to a very small
number.  The iostat session returned information in agreement with atop:
both reads and writes for sdb, sdd, sde, sdg, sdi, and md0 all fell to dead
zero from nominal values frequently exceeding 20,000 reads / sec and 5000
writes / sec.  Meanwhile, writes to sda, sdc, sdf, sdh, and sdj also dropped
to dead zero, but reads only fell to between 230 and 256 reads/sec.

