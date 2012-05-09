From: Larkin Lowrey <llowrey@nuclearwinter.com>
Subject: Re: Interesting feature request for linux raid, waking up drives
Date: Wed, 09 May 2012 15:06:55 -0500
Message-ID: <4FAACE5F.2010004@nuclearwinter.com>
References: <CAAOsTSkxo2Lxb2FCO6A19CrWVbDm1VsrtsYwVEykcs7X=-1sTQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAAOsTSkxo2Lxb2FCO6A19CrWVbDm1VsrtsYwVEykcs7X=-1sTQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: patrik@dsl.sk
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I second this suggestion but I don't think it's the job of the raid
layer to keep track of whether the member drives are spinning or not.

I have implemented a similar setup to this but am suffering from the
sequential spin-up problem you described. It would be nice to have a
solution.

A userspace daemon could probably do the job. I found that relying on
the drive's internal power management for spinning them down was
unreliable (especially for WDC "green" drives) so I implemented a scrip=
t
that watches /sys/block/sdX/stat for activity and spins down the drive
directly (via hdparm) when no activity has been posted for a
configurable period of time. A daemon process that was responsible for
spinning down the constituent drives could also be responsible for
spinning them up by watching /sys/block/mdX/stat for pending transfers.
Perhaps you and I could work on such a project.

One thing mdadm could do which would help greatly is to enumerate the
member disk block devices (not just partitions or member raid devices)
for a given array. This information is known since concurrent sync
operations are serialized so no two sync operations occur at the same
time on the same physical devices.

--Larkin

On 5/9/2012 12:37 PM, Patrik Horn=EDk wrote:
> Hello Neil,
>
> I want to propose some functionality for linux raid subsystem that I
> think will be very practical for many users, automatic waking of
> drives. I am using my own user land script written years ago to do
> that and I dont know if there is some standard solution now. If there
> is some, please point me to it.
>
> I am using couple of big RAID5 arrays in servers working like NASes i=
n
> small office and home, which are in use only small part of the day. I
> am using low power server and aggressive power saving settings on HDD=
s
> to make power consumption substantially lower, for example drives are
> going to sleep after 15 min of inactivity. Normally problem with such
> settings is extremely long waking time when array is accessed.
> Software accessing data often first requests only chunk of data on
> first drive in array and waiting cca 20-30 sec for them, after
> processing them accessing data on another drive and waiting another
> 20-30 sec and so on.
>
> I solved it with my own script in PHP, which monitors drives' status
> periodically. When it detects that drive from RAID array woke up, it
> immediately wakes other drives. So total waking time is equal to
> waking of one drive plus couple of seconds. It works perfectly and
> smoothly for years for me.
>
> I attached the script from one of my servers, it is little cruel and
> using hwparm and smartctl to monitor and manipulating drives. It is
> little customized and specific for its server, for example one drive
> detected by model is not used to wake up other drives and two drives
> are also putting one another into sleep, because I found out the
> standby timeout setting was not working reliable on one drive. But yo=
u
> will get the idea.
>
> I think it could be useful for some users if there is possibility to
> use such feature. Do you think it would be useful? Do you think there
> is some place in linux raid infrastructure where it can be somehow
> implemented? (Possibly as some user land tool using some kernel APIs,
> I dont know.)
>
> Best regards,
>
> Patrik Horn=EDk
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
