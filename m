From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 13 Jul 2017 23:28:16 +0200
Message-ID: <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20170713214856.4a5c8778@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

Il 13-07-2017 18:48 Roman Mamedov ha scritto:
> 
> Failed reads are not as bad, as they are just retried.
> 

I agree, I reported them only to give a broad picture of the system 
state :)

>> Jul 12 03:14:41 nas kernel: ata1.00: failed command: WRITE FPDMA 
>> QUEUED
> 
> But these WILL cause incorrect data written to disk, in my experience. 
> After
> that, one of your disks will contain some corruption, whether in files, 
> or (as
> you discovered) in the filesystem itself.

This is the "scary" part: if the write was not acknowledged as committed 
to disk, why the block layer did not report it to the MD driver? Or if 
the block layer reported that, why MD did not kick the disk out of the 
array?

> mdadm may or may not read from that
> disk, as it chooses the mirror for reads pretty much randomly, using 
> the least
> loaded one. And even though the other disk still contains good data, 
> there is
> no mechanism for the user-space to say "hey, this doesn't look right, 
> what's
> on the other mirror?"

I understand and agree with that. I'm fully aware that MD can not (by 
design) detect/correct corrupted data. However, I wonder if, and why, a 
disk with obvious errors was not kicked out of the array.

> 
> Check your cables and/or disks themselves.
> 

I tried reseating and inverting the cables ;)
Let see if the problem disappears or if it "follow" the 
cable/drive/interface...

> If you know that only one disk had these write errors all the time, you 
> could
> try disconnecting it from mirror, and checking if you can get a more
> consistent view of the filesystem on the remaining one.
> 
> P.S: about my case (which I witnessed on a RAID6):
> 
>   * copy a file to the array, one disk will hit tons of WRITE FPDMA 
> QUEUED
>     errors (due to insufficient power and/or bad data cable).
>   * the file that was just copied, turns out to be corrupted when 
> reading back.
>   * the problem disk WILL NOT get kicked from the array during this.

Wow, a die-hard data corruption. It seems VERY similar to what happened 
to me, and the key problem seems the same: a failing drive was not 
detached from the array in a timely fashion.

Thanks very much for reporting, Roman.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
