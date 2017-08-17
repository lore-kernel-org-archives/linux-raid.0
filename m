From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 17 Aug 2017 16:31:39 +0200
Message-ID: <7ca98351facca6e3668d3271422e1376@assyoma.it>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu>
 <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
 <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
 <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roger Heflin <rogerheflin@gmail.com>
Cc: Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Il 17-08-2017 14:41 Roger Heflin ha scritto:
> 
> Here is a guess based on what you determined was the cause.
> 
> The mid-layer does not know the writes were lost.   The writes were in
> the drives write cache (already submitted to the drive and confirmed
> back to the mid-layer as done, even though they were not yet on the
> platter), and when the driver lost power and "rebooted" those writes
> disappeared, the write(s) the mid-layer had in progress and that never
> got a done from the drive failed were retried and succeeded after the
> driver reset was completed.
> 
> In high reliability raid the solution is to turn off that write cache,
> *but* if you do direct io writes (most databases) with the drives
> write cache off and no battery backed up cache between the 2 then the
> drive becomes horribly slow since it must actually write the data to
> the platter before telling the next level up that the data was safe.

Sure, disabling caching should at least greatly reduce the problem (torn 
writes remain a problem, but their are inevitable).

However, the entire idea of barriers/cache flushes/FUAs was to *safely 
enable* unprotected write caches, even in the face of powerloss. Indeed, 
for full-system powerloss their are adequate. However, device-level 
micro-powerlosses seem to pose an bigger threat to data reliability.

I suspect that the recurrent "my RAID1 array develops huge amount of 
mismatch_cnt sectors" question, which is often labeled as "don't worry 
about RAID1 mismatches", really has a strong tie with this specific 
problem.

I suggest anyone reading this list to also read the current thread on 
the linux-scsi list - it is very interesting.
Regards.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
