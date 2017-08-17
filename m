From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Filesystem corruption on RAID1
Date: Thu, 17 Aug 2017 07:41:00 -0500
Message-ID: <CAAMCDefXYdDKrFjEgeS8JAYt1GNP0-fL1chEXrGqxY8=xEf4Cw@mail.gmail.com>
References: <c2fe6593-c806-ab9f-fcff-8327c013237b@assyoma.it>
 <20170713214856.4a5c8778@natsu> <592f19bf608e9a959f9445f7f25c5dad@assyoma.it>
 <d1255092-73f5-1ca4-0e68-69ff37631a26@thelounge.net> <cd37f90b86eb67be4c893b7fdf112692@assyoma.it>
 <770b09d3-cff6-b6b2-0a51-5d11e8bac7e9@thelounge.net> <9eea45ddc0f80f4f4e238b5c2527a1fa@assyoma.it>
 <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f01b4649-df39-9835-728d-545cbd45976d@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Gionatan Danti <g.danti@assyoma.it>
Cc: Reindl Harald <h.reindl@thelounge.net>, Roman Mamedov <rm@romanrm.net>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Aug 17, 2017 at 3:23 AM, Gionatan Danti <g.danti@assyoma.it> wrote:
> On 14/07/2017 12:46, Gionatan Danti wrote:> Hi, so a premature/preventive
> drive detachment is not a silver bullet,

> but is this the right solution)?
> - how to deal with this problem (other than being 100% sure power is never
> lost by any disks)?
>
> Thank you all,
> regards.
>

Here is a guess based on what you determined was the cause.

The mid-layer does not know the writes were lost.   The writes were in
the drives write cache (already submitted to the drive and confirmed
back to the mid-layer as done, even though they were not yet on the
platter), and when the driver lost power and "rebooted" those writes
disappeared, the write(s) the mid-layer had in progress and that never
got a done from the drive failed were retried and succeeded after the
driver reset was completed.

In high reliability raid the solution is to turn off that write cache,
*but* if you do direct io writes (most databases) with the drives
write cache off and no battery backed up cache between the 2 then the
drive becomes horribly slow since it must actually write the data to
the platter before telling the next level up that the data was safe.
