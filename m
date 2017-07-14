From: Gionatan Danti <g.danti@assyoma.it>
Subject: Re: Filesystem corruption on RAID1
Date: Fri, 14 Jul 2017 12:46:57 +0200
Message-ID: <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu>
 <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net>
 <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net>
Sender: linux-raid-owner@vger.kernel.org
To: Reindl Harald <h.reindl@thelounge.net>
Cc: Roman Mamedov <rm@romanrm.net>, linux-raid@vger.kernel.org, g.danti@assyoma.it
List-Id: linux-raid.ids

Il 14-07-2017 02:32 Reindl Harald ha scritto:
> because you won't be that happy when the kernel spits out a disk each
> time a random SATA command times out - the 4 RAID10 disks on my
> workstation are from 2011 and showed them too several times in the
> past while they are just fine
> 
> here you go:
> http://strugglers.net/~andy/blog/2015/11/09/linux-software-raid-and-drive-timeouts/

Hi, so a premature/preventive drive detachment is not a silver bullet, 
and I buy it. However, I would at least expect this behavior to be 
configurable. Maybe it is, and I am missing something?

Anyway, what really surprise me is *not* the drive to not be detached, 
rather permitting that corruption make its way into real data. I naively 
expect that when a WRITE_QUEUED or CACHE_FLUSH command aborts/fails 
(which *will* cause data corruption if not properly handled) the I/O 
layer has the following possibilities:

a) retry the write/flush. You don't want to retry indefinitely, so the 
kernel need some type of counter/threshold; when the counter is reached, 
continue with b). This would mask out sporadic errors, while propagating 
recurring ones;

b) notify the upper layer that a write error happened. For synchronized 
and direct writes it can notify that by simply returning the correct 
exit code to the calling function. In this case, the block layer should 
return an error to the MD driver, which must act accordlying: for 
example, dropping the disk from the array.

c) do nothing. This seems to me by far the worst choice.

If b) is correcly implemented, it should prevent corruption to 
accumulate on the drives.

Please also note the *type* of corrupted data: not only user data, but 
filesystem journal and metadata also. The latter should be protected by 
the using of write barriers / FUAs, so they should be able to stop 
themselves *before* corruption.

So I have some very important questions:
- how does MD behave when flushing data to disk?
- does it propagate write barriers?
- when a write barrier fails, is the error propagated to the upper 
layers?

Thanks you all.

-- 
Danti Gionatan
Supporto Tecnico
Assyoma S.r.l. - www.assyoma.it
email: g.danti@assyoma.it - info@assyoma.it
GPG public key ID: FF5F32A8
