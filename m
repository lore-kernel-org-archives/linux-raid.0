From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 13 Jul 2017 21:48:56 +0500
Message-ID: <20170713214856.4a5c8778@natsu>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 13 Jul 2017 17:35:12 +0200
Gionatan Danti <g.danti@assyoma.it> wrote:

> Jul 10 03:24:01 nas kernel: ata1.00: failed command: READ FPDMA QUEUED

Failed reads are not as bad, as they are just retried.

> Jul 12 03:14:41 nas kernel: ata1.00: failed command: WRITE FPDMA QUEUED

But these WILL cause incorrect data written to disk, in my experience. After
that, one of your disks will contain some corruption, whether in files, or (as
you discovered) in the filesystem itself. mdadm may or may not read from that
disk, as it chooses the mirror for reads pretty much randomly, using the least
loaded one. And even though the other disk still contains good data, there is
no mechanism for the user-space to say "hey, this doesn't look right, what's
on the other mirror?"

Check your cables and/or disks themselves.

If you know that only one disk had these write errors all the time, you could
try disconnecting it from mirror, and checking if you can get a more
consistent view of the filesystem on the remaining one.

P.S: about my case (which I witnessed on a RAID6):

  * copy a file to the array, one disk will hit tons of WRITE FPDMA QUEUED
    errors (due to insufficient power and/or bad data cable).
  * the file that was just copied, turns out to be corrupted when reading back.
  * the problem disk WILL NOT get kicked from the array during this.

-- 
With respect,
Roman
