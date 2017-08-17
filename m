From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 17 Aug 2017 23:51:03 +0100
Message-ID: <59961DD7.3060208@youngman.org.uk>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
 <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
 <7ca98351facca6e3668d3271422e1376@assyoma.it>
 <5995D377.9080100@youngman.org.uk>
 <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <83f4572f09e7fbab9d4e6de4a5257232@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Roger Heflin <rogerheflin@gmail.com>, Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/08/17 21:50, Gionatan Danti wrote:
> 
> It's more complex, actually. The hardware did not "lie" to me, as it
> correcly flushes caches when instructed to do.
> The problem is that a micro-powerloss wiped the cache *before* the drive
> had a chance to flush it, and the operating system did not detect this
> condition.

Except that that is not what should be happening. I don't know my hard
drive details, but I believe drives have an instruction "async write
this data and let me know when you have done so".

This should NOT return "yes I've flushed it TO cache". Which is how you
get your problem - the level above thinks it's been safely flushed to
disk (because the disk has said "yes I've got it"), but it then gets
lost because of your power fluctuation. It should only acknowledge it
*after* it's been flushed *from* cache.

And this is apparently exactly what cheap drives do ...

If the level above says "tell me when it's safely on disk", and the
drive truly does as its told, your problem won't happen because the disk
block layer will time out waiting for the acknowledgement and retry the
write.

Cheers,
Wol
