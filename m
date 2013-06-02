From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: BUG - raid 1 deadlock on handle_read_error / wait_barrier
Date: Sun, 2 Jun 2013 15:43:41 +0300
Message-ID: <CAGRgLy4zTwopPS-cVwT1RKBr8pE7f3n-X3YLyFpktooQtTYGuQ@mail.gmail.com>
References: <1361487504.4863.54.camel@linux-lxtg.site>
	<20130225094350.4b8ef084@notabene.brown>
	<20130225110458.2b1b1e2d@notabene.brown>
	<1361808662.20264.4.camel@148>
	<alpine.DEB.2.02.1302260905390.1736@jlaw-desktop.mno.stratus.com>
	<CAGRgLy45byT7fxLBOqU6ZNjpOL0Xmq6nNsiwJSCTq+kd1Ya7Jg@mail.gmail.com>
	<20130520171753.002f07d9@notabene.brown>
	<CAGRgLy5m8KxKPxJE+AbtYbBDzo9uo81wez1ba=H4VY3Jiq32WQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary=20cf307d0454a2ef3e04de2b322f
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy5m8KxKPxJE+AbtYbBDzo9uo81wez1ba=H4VY3Jiq32WQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, linux-raid <linux-raid@vger.kernel.org>
Cc: Shyam Kaushik <shyam@zadarastorage.com>, yair@zadarastorage.com
List-Id: linux-raid.ids

--20cf307d0454a2ef3e04de2b322f
Content-Type: text/plain; charset=ISO-8859-1

Hello Neil,
I believe I have found what is causing the deadlock. It happens in two flavors:

1)
# raid1d() is called, and conf->pending_bio_list is non-empty at this point
# raid1d() calls md_check_recovery(), which eventually calls
raid1_add_disk(), which calls raise_barrier()
# Now raise_barrier will wait for conf->nr_pending to become 0, but it
cannot become 0, because there are bios sitting in
conf->pending_bio_list, which nobody will flush, because raid1d is the
one supposed to call flush_pending_writes(), either directly or via
handle_read_error. But it is stuck in raise_barrier.

2)
# raid1_add_disk() calls raise_barrier(), and waits for
conf->nr_pending to become 0, as before
# new WRITE comes and calls wait_barrier(), but this thread has a
non-empty current->bio_list
# In this case, the code allows the WRITE to go through
wait_barrier(), and trigger WRITEs to mirror legs, but these WRITEs
again end up in conf->pending_bio_list (either via raid1_unplug or
directly). But nobody will flush conf->pending_bio_list, because
raid1d is stuck in raise_barrier.

Previously, for example in kernel 3.2, raid1_add_disk did not call
raise_barrier, so this problem did not happen.

Attached is a reproduction with some prints that I added to
raise_barrier and wait_barrier (their code also attached). It
demonstrates case 2. It shows that once raise_barrier got called,
conf->nr_pending drops down, until it equals the number of
wait_barrier calls, that slipped through because of non-empty
current->bio_list. And at this point, this array hangs.

Can you please comment on how to fix this problem. It looks like a
real deadlock.
We can perhaps call md_check_recovery() after flush_pending_writes(),
but this only makes the window smaller, not closes it entirely. But it
looks like we really should not be calling raise_barrier from raid1d.

Thanks,
Alex.


On Thu, May 30, 2013 at 5:30 PM, Alexander Lyakas
<alex.bolshoy@gmail.com> wrote:
> Hi Neil,
>
> On Mon, May 20, 2013 at 10:17 AM, NeilBrown <neilb@suse.de> wrote:
>> On Thu, 16 May 2013 17:07:04 +0300 Alexander Lyakas <alex.bolshoy@gmail.com>
>> wrote:
>>
>>> Hello Neil,
>>> we are hitting issue that looks very similar; we are on kernel 3.8.2.
>>> The array is a 2-device raid1, which experienced a drive failure, but
>>> then drive was removed and re-added back to the array (although
>>> rebuild never started). Relevant parts of the kernel log:
>>>
>>> May 16 11:12:14  kernel: [46850.090499] md/raid1:md2: Disk failure on
>>> dm-6, disabling device.
>>> May 16 11:12:14  kernel: [46850.090499] md/raid1:md2: Operation
>>> continuing on 1 devices.
>>> May 16 11:12:14  kernel: [46850.090511] md: super_written gets
>>> error=-5, uptodate=0
>>> May 16 11:12:14  kernel: [46850.090676] md/raid1:md2: dm-6:
>>> rescheduling sector 18040736
>>> May 16 11:12:14  kernel: [46850.090764] md/raid1:md2: dm-6:
>>> rescheduling sector 20367040
>>> May 16 11:12:14  kernel: [46850.090826] md/raid1:md2: dm-6:
>>> rescheduling sector 17613504
>>> May 16 11:12:14  kernel: [46850.090883] md/raid1:md2: dm-6:
>>> rescheduling sector 18042720
>>> May 16 11:12:15  kernel: [46850.229970] md/raid1:md2: redirecting
>>> sector 18040736 to other mirror: dm-13
>>> May 16 11:12:15  kernel: [46850.257687] md/raid1:md2: redirecting
>>> sector 20367040 to other mirror: dm-13
>>> May 16 11:12:15  kernel: [46850.268731] md/raid1:md2: redirecting
>>> sector 17613504 to other mirror: dm-13
>>> May 16 11:12:15  kernel: [46850.398242] md/raid1:md2: redirecting
>>> sector 18042720 to other mirror: dm-13
>>> May 16 11:12:23  kernel: [46858.448465] md: unbind<dm-6>
>>> May 16 11:12:23  kernel: [46858.456081] md: export_rdev(dm-6)
>>> May 16 11:23:19  kernel: [47515.062547] md: bind<dm-6>
>>>
>>> May 16 11:24:28  kernel: [47583.920126] INFO: task md2_raid1:15749
>>> blocked for more than 60 seconds.
>>> May 16 11:24:28  kernel: [47583.921829] "echo 0 >
>>> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
>>> May 16 11:24:28  kernel: [47583.923361] md2_raid1       D
>>> 0000000000000001     0 15749      2 0x00000000
>>> May 16 11:24:28  kernel: [47583.923367]  ffff880097c23c28
>>> 0000000000000046 ffff880000000002 00000000982c43b8
>>> May 16 11:24:28  kernel: [47583.923372]  ffff880097c23fd8
>>> ffff880097c23fd8 ffff880097c23fd8 0000000000013f40
>>> May 16 11:24:28  kernel: [47583.923376]  ffff880119b11740
>>> ffff8800a5489740 ffff880097c23c38 ffff88011609d3c0
>>> May 16 11:24:28  kernel: [47583.923381] Call Trace:
>>> May 16 11:24:28  kernel: [47583.923395]  [<ffffffff816eb399>] schedule+0x29/0x70
>>> May 16 11:24:28  kernel: [47583.923402]  [<ffffffffa0516736>]
>>> raise_barrier+0x106/0x160 [raid1]
>>> May 16 11:24:28  kernel: [47583.923410]  [<ffffffff8107fcc0>] ?
>>> add_wait_queue+0x60/0x60
>>> May 16 11:24:28  kernel: [47583.923415]  [<ffffffffa0516af7>]
>>> raid1_add_disk+0x197/0x200 [raid1]
>>> May 16 11:24:28  kernel: [47583.923421]  [<ffffffff81567fa4>]
>>> remove_and_add_spares+0x104/0x220
>>> May 16 11:24:28  kernel: [47583.923426]  [<ffffffff8156a02d>]
>>> md_check_recovery.part.49+0x40d/0x530
>>> May 16 11:24:28  kernel: [47583.923429]  [<ffffffff8156a165>]
>>> md_check_recovery+0x15/0x20
>>> May 16 11:24:28  kernel: [47583.923433]  [<ffffffffa0517e42>]
>>> raid1d+0x22/0x180 [raid1]
>>> May 16 11:24:28  kernel: [47583.923439]  [<ffffffff81045cd9>] ?
>>> default_spin_lock_flags+0x9/0x10
>>> May 16 11:24:28  kernel: [47583.923443]  [<ffffffff81045cd9>] ?
>>> default_spin_lock_flags+0x9/0x10
>>> May 16 11:24:28  kernel: [47583.923449]  [<ffffffff815624ed>]
>>> md_thread+0x10d/0x140
>>> May 16 11:24:28  kernel: [47583.923453]  [<ffffffff8107fcc0>] ?
>>> add_wait_queue+0x60/0x60
>>> May 16 11:24:28  kernel: [47583.923457]  [<ffffffff815623e0>] ?
>>> md_rdev_init+0x140/0x140
>>> May 16 11:24:28  kernel: [47583.923461]  [<ffffffff8107f0d0>] kthread+0xc0/0xd0
>>> May 16 11:24:28  kernel: [47583.923465]  [<ffffffff8107f010>] ?
>>> flush_kthread_worker+0xb0/0xb0
>>> May 16 11:24:28  kernel: [47583.923472]  [<ffffffff816f506c>]
>>> ret_from_fork+0x7c/0xb0
>>> May 16 11:24:28  kernel: [47583.923476]  [<ffffffff8107f010>] ?
>>> flush_kthread_worker+0xb0/0xb0
>>>
>>> dm-13 is the good drive, dm-6 is the one that failed.
>>>
>>> At this point, we have several threads calling submit_bio and all
>>> stuck like this:
>>>
>>> cat /proc/16218/stack
>>> [<ffffffffa0516d6e>] wait_barrier+0xbe/0x160 [raid1]
>>> [<ffffffffa0518627>] make_request+0x87/0xa90 [raid1]
>>> [<ffffffff81561ed0>] md_make_request+0xd0/0x200
>>> [<ffffffff8132bcaa>] generic_make_request+0xca/0x100
>>> [<ffffffff8132bd5b>] submit_bio+0x7b/0x160
>>> ...
>>>
>>> And md raid1 thread stuck like this:
>>>
>>> cat /proc/15749/stack
>>> [<ffffffffa0516736>] raise_barrier+0x106/0x160 [raid1]
>>> [<ffffffffa0516af7>] raid1_add_disk+0x197/0x200 [raid1]
>>> [<ffffffff81567fa4>] remove_and_add_spares+0x104/0x220
>>> [<ffffffff8156a02d>] md_check_recovery.part.49+0x40d/0x530
>>> [<ffffffff8156a165>] md_check_recovery+0x15/0x20
>>> [<ffffffffa0517e42>] raid1d+0x22/0x180 [raid1]
>>> [<ffffffff815624ed>] md_thread+0x10d/0x140
>>> [<ffffffff8107f0d0>] kthread+0xc0/0xd0
>>> [<ffffffff816f506c>] ret_from_fork+0x7c/0xb0
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> We have also two user-space threads stuck:
>>>
>>> one is trying to read /sys/block/md2/md/array_state and its kernel stack is:
>>> # cat /proc/2251/stack
>>> [<ffffffff81564602>] md_attr_show+0x72/0xf0
>>> [<ffffffff8120f116>] fill_read_buffer.isra.8+0x66/0xf0
>>> [<ffffffff8120f244>] sysfs_read_file+0xa4/0xc0
>>> [<ffffffff8119b0d0>] vfs_read+0xb0/0x180
>>> [<ffffffff8119b1f2>] sys_read+0x52/0xa0
>>> [<ffffffff816f511d>] system_call_fastpath+0x1a/0x1f
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> the other wants to read from /proc/mdstat and is:
>>> [<ffffffff81563d2b>] md_seq_show+0x4b/0x540
>>> [<ffffffff811bdd1b>] seq_read+0x16b/0x400
>>> [<ffffffff811ff572>] proc_reg_read+0x82/0xc0
>>> [<ffffffff8119b0d0>] vfs_read+0xb0/0x180
>>> [<ffffffff8119b1f2>] sys_read+0x52/0xa0
>>> [<ffffffff816f511d>] system_call_fastpath+0x1a/0x1f
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> mdadm --detail also gets stuck if attempted, in stack like this:
>>> cat /proc/2864/stack
>>> [<ffffffff81564602>] md_attr_show+0x72/0xf0
>>> [<ffffffff8120f116>] fill_read_buffer.isra.8+0x66/0xf0
>>> [<ffffffff8120f244>] sysfs_read_file+0xa4/0xc0
>>> [<ffffffff8119b0d0>] vfs_read+0xb0/0x180
>>> [<ffffffff8119b1f2>] sys_read+0x52/0xa0
>>> [<ffffffff816f511d>] system_call_fastpath+0x1a/0x1f
>>> [<ffffffffffffffff>] 0xffffffffffffffff
>>>
>>> Might your patch https://patchwork.kernel.org/patch/2260051/ fix this
>>
>> Probably.
>>
>>> issue? Is this patch alone applicable to kernel 3.8.2?
>>
>> Probably.
>
> This problem still happens in 3.8.13, which contains the above fix of
> yours. I am currently debugging it deeper, but still don't know what
> the issue is.
> The problem happens when raid1_add_disk() calls raise_barrier().
> conf->nr_waiting is 0 at this point. So then raise_barrier() starts
> waiting for conf->nr_pending getting to 0, but it never gets to 0.
> From this point, anybody that calls wait_barrier() is also stuck.
>
> This looks like a real deadlock in a non-ancient kernel. I realize
> that 3.8.x is EOL, but still it's only one stable behind.
> Can you help further with this problem?
>
> Another problem that I see often, is when a drive fails in RAID1, and
> then rdev is marked as "Blocked", but then Blocked bit never gets
> cleared for some reason. So this drive is not ejected from the array.
> Again, I was unable to debug it deeper at this point.
>
> Thanks,
> Alex.
>
>
>
>
>
>
>
>
>
>
>
>
>>
>>> Can you pls kindly comment on this.
>>>
>>
>> NeilBrown

--20cf307d0454a2ef3e04de2b322f
Content-Type: text/plain; charset=US-ASCII; name="repro.txt"
Content-Disposition: attachment; filename="repro.txt"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhg7zquj0

WyAgNTE0LjcxNDQyNV0gbWQ6IGJpbmQ8ZG0tNT4KWyAgNTE0LjcxODc1MV0gbWQyOiByYWlzZV9i
YXJyaWVyKDEpOiBjb25mLT5iYXJyaWVyPTAgY29uZi0+bnJfd2FpdGluZz0wIGNvbmYtPm5yX3Bl
bmRpbmc9MTkxIGNvbmYtPnBlbmRpbmdfY291bnQ9MApbICA1MTQuNzE4NzU1XSBtZDI6IHJhaXNl
X2JhcnJpZXIoMik6IGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTAgY29uZi0+bnJf
cGVuZGluZz0xOTEgY29uZi0+cGVuZGluZ19jb3VudD0wClsgIDUxNC43MjA1NjRdIG1kMjogd2Fp
dF9iYXJyaWVyKFBJRD03MDc5LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTEg
Y29uZi0+bnJfcGVuZGluZz0xOTEgY29uZi0+cGVuZGluZ19jb3VudD0wClsgIDUxNC43MjIwNzNd
IG1kMjogd2FpdF9iYXJyaWVyKFBJRD03MDY5LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93
YWl0aW5nPTIgY29uZi0+bnJfcGVuZGluZz0xOTEgY29uZi0+cGVuZGluZ19jb3VudD0wClsgIDUx
NC43MjQ2MDJdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05OTIyLDEpIGNvbmYtPmJhcnJpZXI9MSBj
b25mLT5ucl93YWl0aW5nPTMgY29uZi0+bnJfcGVuZGluZz0xOTEgY29uZi0+cGVuZGluZ19jb3Vu
dD0wClsgIDUxNC43MjU1NzVdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05OTA5LDEpIGNvbmYtPmJh
cnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTQgY29uZi0+bnJfcGVuZGluZz0xODcgY29uZi0+cGVu
ZGluZ19jb3VudD0wClsgIDUxNC43MjU2NjFdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD03MDgyLDEp
IGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTUgY29uZi0+bnJfcGVuZGluZz0xODcg
Y29uZi0+cGVuZGluZ19jb3VudD0wClsgIDUxNC43MjU4MzZdIG1kMjogd2FpdF9iYXJyaWVyKFBJ
RD05OTEwLDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTYgY29uZi0+bnJfcGVu
ZGluZz0xNzggY29uZi0+cGVuZGluZ19jb3VudD0wClsgIDUxNC43MjU4NDhdIG1kMjogd2FpdF9i
YXJyaWVyKFBJRD05OTE4LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTcgY29u
Zi0+bnJfcGVuZGluZz0xNzggY29uZi0+cGVuZGluZ19jb3VudD0wClsgIDUxNC43MjU4NjBdIG1k
Mjogd2FpdF9iYXJyaWVyKFBJRD03MDc3LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0
aW5nPTggY29uZi0+bnJfcGVuZGluZz0xNzggY29uZi0+cGVuZGluZ19jb3VudD0wClsgIDUxNC43
MjU4NzJdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05OTA1LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25m
LT5ucl93YWl0aW5nPTkgY29uZi0+bnJfcGVuZGluZz0xNzggY29uZi0+cGVuZGluZ19jb3VudD0w
ClsgIDUxNC43MjU4ODRdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD03MTQ3LDEpIGNvbmYtPmJhcnJp
ZXI9MSBjb25mLT5ucl93YWl0aW5nPTEwIGNvbmYtPm5yX3BlbmRpbmc9MTc4IGNvbmYtPnBlbmRp
bmdfY291bnQ9MApbICA1MTQuNzI1OTE3XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9MTAyMTcsMSkg
Y29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MTEgY29uZi0+bnJfcGVuZGluZz0xNzgg
Y29uZi0+cGVuZGluZ19jb3VudD0wClsgIDUxNC43MjcxMjJdIG1kMjogd2FpdF9iYXJyaWVyKFBJ
RD03MTc3LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTEyIGNvbmYtPm5yX3Bl
bmRpbmc9MTU1IGNvbmYtPnBlbmRpbmdfY291bnQ9MApbICA1MTQuNzI3NDQ2XSBtZDI6IHdhaXRf
YmFycmllcihQSUQ9OTkwNCwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0xMyBj
b25mLT5ucl9wZW5kaW5nPTE1NSBjb25mLT5wZW5kaW5nX2NvdW50PTAKWyAgNTE0LjcyNzQ3NV0g
bWQyOiB3YWl0X2JhcnJpZXIoUElEPTk4OTQsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dh
aXRpbmc9MTQgY29uZi0+bnJfcGVuZGluZz0xNTUgY29uZi0+cGVuZGluZ19jb3VudD0wClsgIDUx
NC43Mjc0ODldIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05ODk4LDEpIGNvbmYtPmJhcnJpZXI9MSBj
b25mLT5ucl93YWl0aW5nPTE1IGNvbmYtPm5yX3BlbmRpbmc9MTU1IGNvbmYtPnBlbmRpbmdfY291
bnQ9MApbICA1MTQuNzI3NTA3XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NzA3MiwxKSBjb25mLT5i
YXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0xNiBjb25mLT5ucl9wZW5kaW5nPTE1NSBjb25mLT5w
ZW5kaW5nX2NvdW50PTAKWyAgNTE0LjcyNzY1MV0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk4OTks
MSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MTcgY29uZi0+bnJfcGVuZGluZz0x
NTAgY29uZi0+cGVuZGluZ19jb3VudD0wClsgIDUxNC43Mjc4NTNdIG1kMjogd2FpdF9iYXJyaWVy
KFBJRD05OTA2LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTE4IGNvbmYtPm5y
X3BlbmRpbmc9MTUwIGNvbmYtPnBlbmRpbmdfY291bnQ9MApbICA1MTQuNzI3ODY3XSBtZDI6IHdh
aXRfYmFycmllcihQSUQ9OTkxMiwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0x
OSBjb25mLT5ucl9wZW5kaW5nPTE1MCBjb25mLT5wZW5kaW5nX2NvdW50PTAKWyAgNTE0LjcyNzkx
NV0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTY4ODgsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5y
X3dhaXRpbmc9MjAgY29uZi0+bnJfcGVuZGluZz0xNTAgY29uZi0+cGVuZGluZ19jb3VudD0wClsg
IDUxNC43MjgxMDldIG1kMjogd2FpdF9iYXJyaWVyKFBJRD03MDgwLDEpIGNvbmYtPmJhcnJpZXI9
MSBjb25mLT5ucl93YWl0aW5nPTIxIGNvbmYtPm5yX3BlbmRpbmc9MTUwIGNvbmYtPnBlbmRpbmdf
Y291bnQ9MApbICA1MTQuNzI4MTEyXSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NzA4MCwyKSBjb25m
LT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0yMCBjb25mLT5ucl9wZW5kaW5nPTE1MSBjb25m
LT5wZW5kaW5nX2NvdW50PTAKWyAgNTE0LjcyODEzNl0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTcw
ODAsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MjEgY29uZi0+bnJfcGVuZGlu
Zz0xNTEgY29uZi0+cGVuZGluZ19jb3VudD0xClsgIDUxNC43MjgxMzhdIG1kMjogd2FpdF9iYXJy
aWVyKFBJRD03MDgwLDIpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTIwIGNvbmYt
Pm5yX3BlbmRpbmc9MTUyIGNvbmYtPnBlbmRpbmdfY291bnQ9MQpbICA1MTQuNzI4MTQzXSBtZDI6
IHdhaXRfYmFycmllcihQSUQ9NzA4MCwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGlu
Zz0yMSBjb25mLT5ucl9wZW5kaW5nPTE1MiBjb25mLT5wZW5kaW5nX2NvdW50PTIKWyAgNTE0Ljcy
ODE0NV0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTcwODAsMikgY29uZi0+YmFycmllcj0xIGNvbmYt
Pm5yX3dhaXRpbmc9MjAgY29uZi0+bnJfcGVuZGluZz0xNTMgY29uZi0+cGVuZGluZ19jb3VudD0y
ClsgIDUxNC43MjgxNDldIG1kMjogd2FpdF9iYXJyaWVyKFBJRD03MDgwLDEpIGNvbmYtPmJhcnJp
ZXI9MSBjb25mLT5ucl93YWl0aW5nPTIxIGNvbmYtPm5yX3BlbmRpbmc9MTUzIGNvbmYtPnBlbmRp
bmdfY291bnQ9MwpbICA1MTQuNzMwMTEwXSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTkxOSwxKSBj
b25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0yMiBjb25mLT5ucl9wZW5kaW5nPTE1MyBj
b25mLT5wZW5kaW5nX2NvdW50PTMKWyAgNTE0LjczMDE4OF0gbWQyOiB3YWl0X2JhcnJpZXIoUElE
PTU3NzMsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MjMgY29uZi0+bnJfcGVu
ZGluZz0xNTMgY29uZi0+cGVuZGluZ19jb3VudD0zClsgIDUxNC43MzExMzldIG1kMjogd2FpdF9i
YXJyaWVyKFBJRD03MTc0LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTI0IGNv
bmYtPm5yX3BlbmRpbmc9MTUzIGNvbmYtPnBlbmRpbmdfY291bnQ9MwpbICA1MTQuNzMxMTQzXSBt
ZDI6IHdhaXRfYmFycmllcihQSUQ9NzE3NCwyKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2Fp
dGluZz0yMyBjb25mLT5ucl9wZW5kaW5nPTE1NCBjb25mLT5wZW5kaW5nX2NvdW50PTMKWyAgNTE0
LjczMTE3Nl0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTcxNzQsMSkgY29uZi0+YmFycmllcj0xIGNv
bmYtPm5yX3dhaXRpbmc9MjQgY29uZi0+bnJfcGVuZGluZz0xNTQgY29uZi0+cGVuZGluZ19jb3Vu
dD00ClsgIDUxNC43MzExNzldIG1kMjogd2FpdF9iYXJyaWVyKFBJRD03MTc0LDIpIGNvbmYtPmJh
cnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTIzIGNvbmYtPm5yX3BlbmRpbmc9MTU1IGNvbmYtPnBl
bmRpbmdfY291bnQ9NApbICA1MTQuNzMxMTgzXSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NzE3NCwx
KSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0yNCBjb25mLT5ucl9wZW5kaW5nPTE1
NSBjb25mLT5wZW5kaW5nX2NvdW50PTUKWyAgNTE0LjczMTE4Nl0gbWQyOiB3YWl0X2JhcnJpZXIo
UElEPTcxNzQsMikgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MjMgY29uZi0+bnJf
cGVuZGluZz0xNTYgY29uZi0+cGVuZGluZ19jb3VudD01ClsgIDUxNC43MzExOTNdIG1kMjogd2Fp
dF9iYXJyaWVyKFBJRD03MTc0LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTI0
IGNvbmYtPm5yX3BlbmRpbmc9MTU2IGNvbmYtPnBlbmRpbmdfY291bnQ9NgpbICA1MTQuNzMxMzcx
XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NzA3MCwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJf
d2FpdGluZz0yNSBjb25mLT5ucl9wZW5kaW5nPTE1NiBjb25mLT5wZW5kaW5nX2NvdW50PTYKWyAg
NTE0LjczMTM3NF0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTcwNzAsMikgY29uZi0+YmFycmllcj0x
IGNvbmYtPm5yX3dhaXRpbmc9MjQgY29uZi0+bnJfcGVuZGluZz0xNTcgY29uZi0+cGVuZGluZ19j
b3VudD02ClsgIDUxNC43MzEzODJdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD03MDcwLDEpIGNvbmYt
PmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTI1IGNvbmYtPm5yX3BlbmRpbmc9MTU3IGNvbmYt
PnBlbmRpbmdfY291bnQ9NwpbICA1MTQuNzMxMzg1XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NzA3
MCwyKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0yNCBjb25mLT5ucl9wZW5kaW5n
PTE1OCBjb25mLT5wZW5kaW5nX2NvdW50PTcKWyAgNTE0LjczMTM4OF0gbWQyOiB3YWl0X2JhcnJp
ZXIoUElEPTcwNzAsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MjUgY29uZi0+
bnJfcGVuZGluZz0xNTggY29uZi0+cGVuZGluZ19jb3VudD04ClsgIDUxNC43MzEzOTBdIG1kMjog
d2FpdF9iYXJyaWVyKFBJRD03MDcwLDIpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5n
PTI0IGNvbmYtPm5yX3BlbmRpbmc9MTU5IGNvbmYtPnBlbmRpbmdfY291bnQ9OApbICA1MTQuNzMx
Mzk0XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NzA3MCwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+
bnJfd2FpdGluZz0yNSBjb25mLT5ucl9wZW5kaW5nPTE1OSBjb25mLT5wZW5kaW5nX2NvdW50PTkK
WyAgNTE0LjczMTQ5MV0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk4ODgsMSkgY29uZi0+YmFycmll
cj0xIGNvbmYtPm5yX3dhaXRpbmc9MjYgY29uZi0+bnJfcGVuZGluZz0xNTkgY29uZi0+cGVuZGlu
Z19jb3VudD05ClsgIDUxNC43MzE0OTRdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05ODg4LDIpIGNv
bmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTI1IGNvbmYtPm5yX3BlbmRpbmc9MTYwIGNv
bmYtPnBlbmRpbmdfY291bnQ9OQpbICA1MTQuNzMxNTAyXSBtZDI6IHdhaXRfYmFycmllcihQSUQ9
OTg4OCwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0yNiBjb25mLT5ucl9wZW5k
aW5nPTE2MCBjb25mLT5wZW5kaW5nX2NvdW50PTEwClsgIDUxNC43MzE1MDVdIG1kMjogd2FpdF9i
YXJyaWVyKFBJRD05ODg4LDIpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTI1IGNv
bmYtPm5yX3BlbmRpbmc9MTYxIGNvbmYtPnBlbmRpbmdfY291bnQ9MTAKWyAgNTE0LjczMTUwOF0g
bWQyOiB3YWl0X2JhcnJpZXIoUElEPTk4ODgsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dh
aXRpbmc9MjYgY29uZi0+bnJfcGVuZGluZz0xNjEgY29uZi0+cGVuZGluZ19jb3VudD0xMQpbICA1
MTQuNzMxNTEwXSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTg4OCwyKSBjb25mLT5iYXJyaWVyPTEg
Y29uZi0+bnJfd2FpdGluZz0yNSBjb25mLT5ucl9wZW5kaW5nPTE2MiBjb25mLT5wZW5kaW5nX2Nv
dW50PTExClsgIDUxNC43MzE1MTRdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05ODg4LDEpIGNvbmYt
PmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTI2IGNvbmYtPm5yX3BlbmRpbmc9MTYyIGNvbmYt
PnBlbmRpbmdfY291bnQ9MTIKWyAgNTE0LjczMTc1NV0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk4
OTUsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MjcgY29uZi0+bnJfcGVuZGlu
Zz0xNjIgY29uZi0+cGVuZGluZ19jb3VudD0xMgpbICA1MTQuNzMxNzU4XSBtZDI6IHdhaXRfYmFy
cmllcihQSUQ9OTg5NSwyKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0yNiBjb25m
LT5ucl9wZW5kaW5nPTE2MyBjb25mLT5wZW5kaW5nX2NvdW50PTEyClsgIDUxNC43MzE3NjddIG1k
Mjogd2FpdF9iYXJyaWVyKFBJRD05ODk1LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0
aW5nPTI3IGNvbmYtPm5yX3BlbmRpbmc9MTYzIGNvbmYtPnBlbmRpbmdfY291bnQ9MTMKWyAgNTE0
LjczMTc2OV0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk4OTUsMikgY29uZi0+YmFycmllcj0xIGNv
bmYtPm5yX3dhaXRpbmc9MjYgY29uZi0+bnJfcGVuZGluZz0xNjQgY29uZi0+cGVuZGluZ19jb3Vu
dD0xMwpbICA1MTQuNzMxNzczXSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTg5NSwxKSBjb25mLT5i
YXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0yNyBjb25mLT5ucl9wZW5kaW5nPTE2NCBjb25mLT5w
ZW5kaW5nX2NvdW50PTE0ClsgIDUxNC43MzE3NzVdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05ODk1
LDIpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTI2IGNvbmYtPm5yX3BlbmRpbmc9
MTY1IGNvbmYtPnBlbmRpbmdfY291bnQ9MTQKWyAgNTE0LjczMTgyNl0gbWQyOiB3YWl0X2JhcnJp
ZXIoUElEPTk4OTUsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MjcgY29uZi0+
bnJfcGVuZGluZz0xNjUgY29uZi0+cGVuZGluZ19jb3VudD0xNQpbICA1MTQuNzMxODc1XSBtZDI6
IHdhaXRfYmFycmllcihQSUQ9OTg5NywxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGlu
Zz0yOCBjb25mLT5ucl9wZW5kaW5nPTE2NSBjb25mLT5wZW5kaW5nX2NvdW50PTE1ClsgIDUxNC43
MzE4NzhdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05ODk3LDIpIGNvbmYtPmJhcnJpZXI9MSBjb25m
LT5ucl93YWl0aW5nPTI3IGNvbmYtPm5yX3BlbmRpbmc9MTY2IGNvbmYtPnBlbmRpbmdfY291bnQ9
MTUKWyAgNTE0LjczMTg4NF0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk4OTcsMSkgY29uZi0+YmFy
cmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MjggY29uZi0+bnJfcGVuZGluZz0xNjYgY29uZi0+cGVu
ZGluZ19jb3VudD0xNgpbICA1MTQuNzMxODg3XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTg5Nywy
KSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0yNyBjb25mLT5ucl9wZW5kaW5nPTE2
NyBjb25mLT5wZW5kaW5nX2NvdW50PTE2ClsgIDUxNC43MzE4OTBdIG1kMjogd2FpdF9iYXJyaWVy
KFBJRD05ODk3LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTI4IGNvbmYtPm5y
X3BlbmRpbmc9MTY3IGNvbmYtPnBlbmRpbmdfY291bnQ9MTcKWyAgNTE0LjczMTg5M10gbWQyOiB3
YWl0X2JhcnJpZXIoUElEPTk4OTcsMikgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9
MjcgY29uZi0+bnJfcGVuZGluZz0xNjggY29uZi0+cGVuZGluZ19jb3VudD0xNwpbICA1MTQuNzMx
OTAyXSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTg5NywxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+
bnJfd2FpdGluZz0yOCBjb25mLT5ucl9wZW5kaW5nPTE2OCBjb25mLT5wZW5kaW5nX2NvdW50PTE4
ClsgIDUxNC43MzE5NzFdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05ODk2LDEpIGNvbmYtPmJhcnJp
ZXI9MSBjb25mLT5ucl93YWl0aW5nPTI5IGNvbmYtPm5yX3BlbmRpbmc9MTY4IGNvbmYtPnBlbmRp
bmdfY291bnQ9MTgKWyAgNTE0LjczMjMwNF0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk5MDgsMSkg
Y29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MzAgY29uZi0+bnJfcGVuZGluZz0xNjgg
Y29uZi0+cGVuZGluZ19jb3VudD0xOApbICA1MTQuNzMyMzA3XSBtZDI6IHdhaXRfYmFycmllcihQ
SUQ9OTkwOCwyKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0yOSBjb25mLT5ucl9w
ZW5kaW5nPTE2OSBjb25mLT5wZW5kaW5nX2NvdW50PTE4ClsgIDUxNC43MzIzNDBdIG1kMjogd2Fp
dF9iYXJyaWVyKFBJRD05OTA4LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTMw
IGNvbmYtPm5yX3BlbmRpbmc9MTY5IGNvbmYtPnBlbmRpbmdfY291bnQ9MTkKWyAgNTE0LjczMjM0
M10gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk5MDgsMikgY29uZi0+YmFycmllcj0xIGNvbmYtPm5y
X3dhaXRpbmc9MjkgY29uZi0+bnJfcGVuZGluZz0xNzAgY29uZi0+cGVuZGluZ19jb3VudD0xOQpb
ICA1MTQuNzMyMzQ2XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTkwOCwxKSBjb25mLT5iYXJyaWVy
PTEgY29uZi0+bnJfd2FpdGluZz0zMCBjb25mLT5ucl9wZW5kaW5nPTE3MCBjb25mLT5wZW5kaW5n
X2NvdW50PTIwClsgIDUxNC43MzIzNDldIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05OTA4LDIpIGNv
bmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTI5IGNvbmYtPm5yX3BlbmRpbmc9MTcxIGNv
bmYtPnBlbmRpbmdfY291bnQ9MjAKWyAgNTE0LjczMjM1Ml0gbWQyOiB3YWl0X2JhcnJpZXIoUElE
PTk5MDgsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MzAgY29uZi0+bnJfcGVu
ZGluZz0xNzEgY29uZi0+cGVuZGluZ19jb3VudD0yMQpbICA1MTQuNzMyMzk3XSBtZDI6IHdhaXRf
YmFycmllcihQSUQ9NTc3NCwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0zMSBj
b25mLT5ucl9wZW5kaW5nPTE3MSBjb25mLT5wZW5kaW5nX2NvdW50PTIxClsgIDUxNC43MzI0MDBd
IG1kMjogd2FpdF9iYXJyaWVyKFBJRD01Nzc0LDIpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93
YWl0aW5nPTMwIGNvbmYtPm5yX3BlbmRpbmc9MTcyIGNvbmYtPnBlbmRpbmdfY291bnQ9MjEKWyAg
NTE0LjczMjQxMl0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTU3NzQsMSkgY29uZi0+YmFycmllcj0x
IGNvbmYtPm5yX3dhaXRpbmc9MzEgY29uZi0+bnJfcGVuZGluZz0xNzIgY29uZi0+cGVuZGluZ19j
b3VudD0yMgpbICA1MTQuNzMyNDE0XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NTc3NCwyKSBjb25m
LT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0zMCBjb25mLT5ucl9wZW5kaW5nPTE3MyBjb25m
LT5wZW5kaW5nX2NvdW50PTIyClsgIDUxNC43MzI0MTldIG1kMjogd2FpdF9iYXJyaWVyKFBJRD01
Nzc0LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTMxIGNvbmYtPm5yX3BlbmRp
bmc9MTczIGNvbmYtPnBlbmRpbmdfY291bnQ9MjMKWyAgNTE0LjczMjQyMV0gbWQyOiB3YWl0X2Jh
cnJpZXIoUElEPTU3NzQsMikgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MzAgY29u
Zi0+bnJfcGVuZGluZz0xNzQgY29uZi0+cGVuZGluZ19jb3VudD0yMwpbICA1MTQuNzMyNDI0XSBt
ZDI6IHdhaXRfYmFycmllcihQSUQ9NTc3NCwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2Fp
dGluZz0zMSBjb25mLT5ucl9wZW5kaW5nPTE3NCBjb25mLT5wZW5kaW5nX2NvdW50PTI0ClsgIDUx
NC43MzI0NTldIG1kMjogd2FpdF9iYXJyaWVyKFBJRD03MDY4LDEpIGNvbmYtPmJhcnJpZXI9MSBj
b25mLT5ucl93YWl0aW5nPTMyIGNvbmYtPm5yX3BlbmRpbmc9MTc0IGNvbmYtPnBlbmRpbmdfY291
bnQ9MjQKWyAgNTE0LjczMjQ2MV0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTcwNjgsMikgY29uZi0+
YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MzEgY29uZi0+bnJfcGVuZGluZz0xNzUgY29uZi0+
cGVuZGluZ19jb3VudD0yNApbICA1MTQuNzMyNDY3XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NzA2
OCwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0zMiBjb25mLT5ucl9wZW5kaW5n
PTE3NSBjb25mLT5wZW5kaW5nX2NvdW50PTI1ClsgIDUxNC43MzI0NjldIG1kMjogd2FpdF9iYXJy
aWVyKFBJRD03MDY4LDIpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTMxIGNvbmYt
Pm5yX3BlbmRpbmc9MTc2IGNvbmYtPnBlbmRpbmdfY291bnQ9MjUKWyAgNTE0LjczMjQ3M10gbWQy
OiB3YWl0X2JhcnJpZXIoUElEPTcwNjgsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRp
bmc9MzIgY29uZi0+bnJfcGVuZGluZz0xNzYgY29uZi0+cGVuZGluZ19jb3VudD0yNgpbICA1MTQu
NzMyNDc1XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NzA2OCwyKSBjb25mLT5iYXJyaWVyPTEgY29u
Zi0+bnJfd2FpdGluZz0zMSBjb25mLT5ucl9wZW5kaW5nPTE3NyBjb25mLT5wZW5kaW5nX2NvdW50
PTI2ClsgIDUxNC43MzI0NzhdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD03MDY4LDEpIGNvbmYtPmJh
cnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTMyIGNvbmYtPm5yX3BlbmRpbmc9MTc3IGNvbmYtPnBl
bmRpbmdfY291bnQ9MjcKWyAgNTE0LjczNDgwN10gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk5MDEs
MSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MzMgY29uZi0+bnJfcGVuZGluZz0x
NzcgY29uZi0+cGVuZGluZ19jb3VudD0yNwpbICA1MTQuNzM0ODMwXSBtZDI6IHdhaXRfYmFycmll
cihQSUQ9OTkyMywxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz0zNCBjb25mLT5u
cl9wZW5kaW5nPTE3NyBjb25mLT5wZW5kaW5nX2NvdW50PTI3ClsgIDUxNC43MzU5NzVdIG1kMjog
d2FpdF9iYXJyaWVyKFBJRD03MTc1LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5n
PTM1IGNvbmYtPm5yX3BlbmRpbmc9MTU4IGNvbmYtPnBlbmRpbmdfY291bnQ9MjcKWyAgNTE0Ljcz
NTk5Ml0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTcwODEsMSkgY29uZi0+YmFycmllcj0xIGNvbmYt
Pm5yX3dhaXRpbmc9MzYgY29uZi0+bnJfcGVuZGluZz0xNTggY29uZi0+cGVuZGluZ19jb3VudD0y
NwpbICA1MTQuNzM2MDgzXSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTkyMSwxKSBjb25mLT5iYXJy
aWVyPTEgY29uZi0+bnJfd2FpdGluZz0zNyBjb25mLT5ucl9wZW5kaW5nPTE1OCBjb25mLT5wZW5k
aW5nX2NvdW50PTI3ClsgIDUxNC43MzY2NzBdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD03MDc1LDEp
IGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTM4IGNvbmYtPm5yX3BlbmRpbmc9MTU4
IGNvbmYtPnBlbmRpbmdfY291bnQ9MjcKWyAgNTE0Ljc0MDQyNV0gbWQyOiB3YWl0X2JhcnJpZXIo
UElEPTk5MjUsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9MzkgY29uZi0+bnJf
cGVuZGluZz0xMjUgY29uZi0+cGVuZGluZ19jb3VudD0yNwpbICA1MTQuNzQwNDQ4XSBtZDI6IHdh
aXRfYmFycmllcihQSUQ9NDEsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9NDAg
Y29uZi0+bnJfcGVuZGluZz0xMjUgY29uZi0+cGVuZGluZ19jb3VudD0yNwpbICA1MTQuNzQwNDY1
XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NzA4MywxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJf
d2FpdGluZz00MSBjb25mLT5ucl9wZW5kaW5nPTEyNSBjb25mLT5wZW5kaW5nX2NvdW50PTI3Clsg
IDUxNC43NDA0NzhdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05OTExLDEpIGNvbmYtPmJhcnJpZXI9
MSBjb25mLT5ucl93YWl0aW5nPTQyIGNvbmYtPm5yX3BlbmRpbmc9MTI1IGNvbmYtPnBlbmRpbmdf
Y291bnQ9MjcKWyAgNTE0Ljc0MDQ5Ml0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk5MDMsMSkgY29u
Zi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9NDMgY29uZi0+bnJfcGVuZGluZz0xMjUgY29u
Zi0+cGVuZGluZ19jb3VudD0yNwpbICA1MTQuNzQxMDY3XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9
NzA3MSwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz00NCBjb25mLT5ucl9wZW5k
aW5nPTEyNSBjb25mLT5wZW5kaW5nX2NvdW50PTI3ClsgIDUxNC43NDM0NjNdIG1kMjogd2FpdF9i
YXJyaWVyKFBJRD05OTIwLDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTQ1IGNv
bmYtPm5yX3BlbmRpbmc9MTA1IGNvbmYtPnBlbmRpbmdfY291bnQ9MjcKWyAgNTE0Ljc0MzQ3OF0g
bWQyOiB3YWl0X2JhcnJpZXIoUElEPTk5MjQsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dh
aXRpbmc9NDYgY29uZi0+bnJfcGVuZGluZz0xMDUgY29uZi0+cGVuZGluZ19jb3VudD0yNwpbICA1
MTQuNzQzNDg5XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9NzE0NiwxKSBjb25mLT5iYXJyaWVyPTEg
Y29uZi0+bnJfd2FpdGluZz00NyBjb25mLT5ucl9wZW5kaW5nPTEwNSBjb25mLT5wZW5kaW5nX2Nv
dW50PTI3ClsgIDUxNC43NDU3NjVdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05ODkwLDEpIGNvbmYt
PmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTQ4IGNvbmYtPm5yX3BlbmRpbmc9ODkgY29uZi0+
cGVuZGluZ19jb3VudD0yNwpbICA1MTQuNzQ1Nzg0XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTg3
OSwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz00OSBjb25mLT5ucl9wZW5kaW5n
PTg5IGNvbmYtPnBlbmRpbmdfY291bnQ9MjcKWyAgNTE0Ljc0NjU1Nl0gbWQyOiB3YWl0X2JhcnJp
ZXIoUElEPTYsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9NTAgY29uZi0+bnJf
cGVuZGluZz04MSBjb25mLT5wZW5kaW5nX2NvdW50PTI3ClsgIDUxNC43NDg4OTddIG1kMjogd2Fp
dF9iYXJyaWVyKFBJRD05OTY2LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTUx
IGNvbmYtPm5yX3BlbmRpbmc9NzUgY29uZi0+cGVuZGluZ19jb3VudD0yNwpbICA1MTQuNzQ5MTk1
XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTkwMCwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJf
d2FpdGluZz01MiBjb25mLT5ucl9wZW5kaW5nPTY3IGNvbmYtPnBlbmRpbmdfY291bnQ9MjcKWyAg
NTE0Ljc1MDA0N10gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk4ODcsMSkgY29uZi0+YmFycmllcj0x
IGNvbmYtPm5yX3dhaXRpbmc9NTMgY29uZi0+bnJfcGVuZGluZz01NyBjb25mLT5wZW5kaW5nX2Nv
dW50PTI3ClsgIDUxNC43NTAwNjVdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD05ODg5LDEpIGNvbmYt
PmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTU0IGNvbmYtPm5yX3BlbmRpbmc9NTcgY29uZi0+
cGVuZGluZ19jb3VudD0yNwpbICA1MTQuNzUwMDc2XSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTg5
MywxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz01NSBjb25mLT5ucl9wZW5kaW5n
PTU3IGNvbmYtPnBlbmRpbmdfY291bnQ9MjcKWyAgNTE0Ljc1MjU2NV0gbWQyOiB3YWl0X2JhcnJp
ZXIoUElEPTk5MTUsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9NTYgY29uZi0+
bnJfcGVuZGluZz00OCBjb25mLT5wZW5kaW5nX2NvdW50PTI3ClsgIDUxNC43NTI1ODBdIG1kMjog
d2FpdF9iYXJyaWVyKFBJRD03MDc0LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5n
PTU3IGNvbmYtPm5yX3BlbmRpbmc9NDggY29uZi0+cGVuZGluZ19jb3VudD0yNwpbICA1MTQuNzUy
NTkyXSBtZDI6IHdhaXRfYmFycmllcihQSUQ9OTkwMiwxKSBjb25mLT5iYXJyaWVyPTEgY29uZi0+
bnJfd2FpdGluZz01OCBjb25mLT5ucl9wZW5kaW5nPTQ4IGNvbmYtPnBlbmRpbmdfY291bnQ9MjcK
WyAgNTE0Ljc1MjYwM10gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTk5MTYsMSkgY29uZi0+YmFycmll
cj0xIGNvbmYtPm5yX3dhaXRpbmc9NTkgY29uZi0+bnJfcGVuZGluZz00OCBjb25mLT5wZW5kaW5n
X2NvdW50PTI3ClsgIDUxNC43NTI5MjZdIG1kMjogd2FpdF9iYXJyaWVyKFBJRD00MiwxKSBjb25m
LT5iYXJyaWVyPTEgY29uZi0+bnJfd2FpdGluZz02MCBjb25mLT5ucl9wZW5kaW5nPTI3IGNvbmYt
PnBlbmRpbmdfY291bnQ9MjcKWyAgNTE0Ljc1Mjk0Nl0gbWQyOiB3YWl0X2JhcnJpZXIoUElEPTcw
NzMsMSkgY29uZi0+YmFycmllcj0xIGNvbmYtPm5yX3dhaXRpbmc9NjEgY29uZi0+bnJfcGVuZGlu
Zz0yNyBjb25mLT5wZW5kaW5nX2NvdW50PTI3ClsgIDUxNC43NTI5NjBdIG1kMjogd2FpdF9iYXJy
aWVyKFBJRD05OTE0LDEpIGNvbmYtPmJhcnJpZXI9MSBjb25mLT5ucl93YWl0aW5nPTYyIGNvbmYt
Pm5yX3BlbmRpbmc9MjcgY29uZi0+cGVuZGluZ19jb3VudD0yNwoK
--20cf307d0454a2ef3e04de2b322f
Content-Type: text/x-csrc; charset=US-ASCII; name="raise_wait_barrier.c"
Content-Disposition: attachment; filename="raise_wait_barrier.c"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_hhg80bmo1

c3RhdGljIHZvaWQgcmFpc2VfYmFycmllcihzdHJ1Y3QgcjFjb25mICpjb25mKQp7CglzcGluX2xv
Y2tfaXJxKCZjb25mLT5yZXN5bmNfbG9jayk7CgoJcHJfaW5mbygiJXM6IHJhaXNlX2JhcnJpZXIo
MSk6IGNvbmYtPmJhcnJpZXI9JWQgY29uZi0+bnJfd2FpdGluZz0lZCBjb25mLT5ucl9wZW5kaW5n
PSVkIGNvbmYtPnBlbmRpbmdfY291bnQ9JWRcbiIsIG1kbmFtZShjb25mLT5tZGRldiksIGNvbmYt
PmJhcnJpZXIsIGNvbmYtPm5yX3dhaXRpbmcsIGNvbmYtPm5yX3BlbmRpbmcsIGNvbmYtPnBlbmRp
bmdfY291bnQpOwoKCS8qIFdhaXQgdW50aWwgbm8gYmxvY2sgSU8gaXMgd2FpdGluZyAqLwoJd2Fp
dF9ldmVudF9sb2NrX2lycShjb25mLT53YWl0X2JhcnJpZXIsICFjb25mLT5ucl93YWl0aW5nLAoJ
CQkgICAgY29uZi0+cmVzeW5jX2xvY2spOwoKCS8qIGJsb2NrIGFueSBuZXcgSU8gZnJvbSBzdGFy
dGluZyAqLwoJY29uZi0+YmFycmllcisrOwoKCXByX2luZm8oIiVzOiByYWlzZV9iYXJyaWVyKDIp
OiBjb25mLT5iYXJyaWVyPSVkIGNvbmYtPm5yX3dhaXRpbmc9JWQgY29uZi0+bnJfcGVuZGluZz0l
ZCBjb25mLT5wZW5kaW5nX2NvdW50PSVkXG4iLCBtZG5hbWUoY29uZi0+bWRkZXYpLCBjb25mLT5i
YXJyaWVyLCBjb25mLT5ucl93YWl0aW5nLCBjb25mLT5ucl9wZW5kaW5nLCBjb25mLT5wZW5kaW5n
X2NvdW50KTsKCgkvKiBOb3cgd2FpdCBmb3IgYWxsIHBlbmRpbmcgSU8gdG8gY29tcGxldGUgKi8K
CXdhaXRfZXZlbnRfbG9ja19pcnEoY29uZi0+d2FpdF9iYXJyaWVyLAoJCQkgICAgIWNvbmYtPm5y
X3BlbmRpbmcgJiYgY29uZi0+YmFycmllciA8IFJFU1lOQ19ERVBUSCwKCQkJICAgIGNvbmYtPnJl
c3luY19sb2NrKTsKCglwcl9pbmZvKCIlczogcmFpc2VfYmFycmllcigzKTogY29uZi0+YmFycmll
cj0lZCBjb25mLT5ucl93YWl0aW5nPSVkIGNvbmYtPm5yX3BlbmRpbmc9JWQgY29uZi0+cGVuZGlu
Z19jb3VudD0lZFxuIiwgbWRuYW1lKGNvbmYtPm1kZGV2KSwgY29uZi0+YmFycmllciwgY29uZi0+
bnJfd2FpdGluZywgY29uZi0+bnJfcGVuZGluZywgY29uZi0+cGVuZGluZ19jb3VudCk7CgoJc3Bp
bl91bmxvY2tfaXJxKCZjb25mLT5yZXN5bmNfbG9jayk7Cn0KCnN0YXRpYyB2b2lkIHdhaXRfYmFy
cmllcihzdHJ1Y3QgcjFjb25mICpjb25mKQp7CglpbnQgd2FpdGVkID0gMDsKCQoJc3Bpbl9sb2Nr
X2lycSgmY29uZi0+cmVzeW5jX2xvY2spOwoJaWYgKGNvbmYtPmJhcnJpZXIpIHsKCQljb25mLT5u
cl93YWl0aW5nKys7CgoJCXdhaXRlZCA9IDE7CgkJcHJfaW5mbygiJXM6IHdhaXRfYmFycmllcihQ
SUQ9JWQsMSkgY29uZi0+YmFycmllcj0lZCBjb25mLT5ucl93YWl0aW5nPSVkIGNvbmYtPm5yX3Bl
bmRpbmc9JWQgY29uZi0+cGVuZGluZ19jb3VudD0lZFxuIiwgbWRuYW1lKGNvbmYtPm1kZGV2KSwg
Y3VycmVudC0+cGlkLCAKCQkJICAgIGNvbmYtPmJhcnJpZXIsIGNvbmYtPm5yX3dhaXRpbmcsIGNv
bmYtPm5yX3BlbmRpbmcsIGNvbmYtPnBlbmRpbmdfY291bnQpOwoJCWlmIChjb25mLT5ucl9wZW5k
aW5nICYmIGN1cnJlbnQtPmJpb19saXN0ICYmICFiaW9fbGlzdF9lbXB0eShjdXJyZW50LT5iaW9f
bGlzdCkpCgkJCWR1bXBfc3RhY2soKTsKCgkJLyogV2FpdCBmb3IgdGhlIGJhcnJpZXIgdG8gZHJv
cC4KCQkgKiBIb3dldmVyIGlmIHRoZXJlIGFyZSBhbHJlYWR5IHBlbmRpbmcKCQkgKiByZXF1ZXN0
cyAocHJldmVudGluZyB0aGUgYmFycmllciBmcm9tCgkJICogcmlzaW5nIGNvbXBsZXRlbHkpLCBh
bmQgdGhlCgkJICogcHJlLXByb2Nlc3MgYmlvIHF1ZXVlIGlzbid0IGVtcHR5LAoJCSAqIHRoZW4g
ZG9uJ3Qgd2FpdCwgYXMgd2UgbmVlZCB0byBlbXB0eQoJCSAqIHRoYXQgcXVldWUgdG8gZ2V0IHRo
ZSBucl9wZW5kaW5nCgkJICogY291bnQgZG93bi4KCQkgKi8KCQl3YWl0X2V2ZW50X2xvY2tfaXJx
KGNvbmYtPndhaXRfYmFycmllciwKCQkJCSAgICAhY29uZi0+YmFycmllciB8fAoJCQkJICAgIChj
b25mLT5ucl9wZW5kaW5nICYmCgkJCQkgICAgIGN1cnJlbnQtPmJpb19saXN0ICYmCgkJCQkgICAg
ICFiaW9fbGlzdF9lbXB0eShjdXJyZW50LT5iaW9fbGlzdCkpLAoJCQkJICAgIGNvbmYtPnJlc3lu
Y19sb2NrKTsKCQljb25mLT5ucl93YWl0aW5nLS07Cgl9Cgljb25mLT5ucl9wZW5kaW5nKys7CgoJ
aWYgKHdhaXRlZCkKCQlwcl9pbmZvKCIlczogd2FpdF9iYXJyaWVyKFBJRD0lZCwyKSBjb25mLT5i
YXJyaWVyPSVkIGNvbmYtPm5yX3dhaXRpbmc9JWQgY29uZi0+bnJfcGVuZGluZz0lZCBjb25mLT5w
ZW5kaW5nX2NvdW50PSVkXG4iLCBtZG5hbWUoY29uZi0+bWRkZXYpLCBjdXJyZW50LT5waWQsIAoJ
CQkgICAgY29uZi0+YmFycmllciwgY29uZi0+bnJfd2FpdGluZywgY29uZi0+bnJfcGVuZGluZywg
Y29uZi0+cGVuZGluZ19jb3VudCk7CgoJc3Bpbl91bmxvY2tfaXJxKCZjb25mLT5yZXN5bmNfbG9j
ayk7Cn0K
--20cf307d0454a2ef3e04de2b322f--
