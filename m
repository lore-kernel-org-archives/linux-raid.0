From: Nigel Croxon <ncroxon@redhat.com>
Subject: Re: low memory deadlock with md devices and external (imsm) metadata
 handling
Date: Fri, 31 Jan 2020 12:10:55 -0500
Message-ID: <862c9a3d-bc4a-bcc2-1c94-3c062d87e827@redhat.com>
References: <71c1884d-a9fd-807b-86d0-4406457d605b@redhat.com>
 <5bdc7be3-e796-5da5-f0e0-5287d47f4900@cloud.ionos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5bdc7be3-e796-5da5-f0e0-5287d47f4900@cloud.ionos.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Guoqing Jiang <guoqing.jiang@cloud.ionos.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 1/31/20 11:22 AM, Guoqing Jiang wrote:
>
>
> On 1/31/20 3:43 PM, Nigel Croxon wrote:
>> Hello all,
>>
>> I have a customer issue,=C2=A0 low memory deadlock with md devices and=
=20
>> external (imsm) metadata handling
>>
>> https://bugzilla.redhat.com/show_bug.cgi?id=3D1703180
>>
>> Has anyone else seen this problem?
>
> I think most people out of RH are not authorized to the website.
>
> Guoqing
>
A customer has been having hung systems periodically.=C2=A0 A vmcore was=20
captured of one stuck system and tasks were found to be stuck in=20
md_write_start.=C2=A0 One example:

crash> bt 20908
PID: 20908=C2=A0 TASK: ffff96ce1e16c100=C2=A0 CPU: 46=C2=A0 COMMAND: "kwo=
rker/u114:1"
 =C2=A0#0 [ffff96c68627b728] __schedule at ffffffff8a567747
 =C2=A0#1 [ffff96c68627b7b0] schedule at ffffffff8a567c49
 =C2=A0#2 [ffff96c68627b7c0] md_write_start at ffffffff8a38ed7c
 =C2=A0#3 [ffff96c68627b820] raid1_write_request at ffffffffc053500c [rai=
d1]
 =C2=A0#4 [ffff96c68627b910] raid1_make_request at ffffffffc0535ac2 [raid=
1]
 =C2=A0#5 [ffff96c68627b9d0] md_handle_request at ffffffff8a38d740
 =C2=A0#6 [ffff96c68627ba40] md_make_request at ffffffff8a38d8a9
 =C2=A0#7 [ffff96c68627ba68] generic_make_request at ffffffff8a145267
 =C2=A0#8 [ffff96c68627bac0] submit_bio at ffffffff8a145510
 =C2=A0#9 [ffff96c68627bb18] xfs_submit_ioend at ffffffffc080f251 [xfs]
#10 [ffff96c68627bb40] xfs_vm_writepages at ffffffffc080f3bf [xfs]
#11 [ffff96c68627bbb0] do_writepages at ffffffff89fc3431
#12 [ffff96c68627bbc0] __writeback_single_inode at ffffffff8a06fee0
#13 [ffff96c68627bc08] writeback_sb_inodes at ffffffff8a070974
#14 [ffff96c68627bcb0] __writeback_inodes_wb at ffffffff8a070cdf
#15 [ffff96c68627bcf8] wb_writeback at ffffffff8a071513
#16 [ffff96c68627bd70] bdi_writeback_workfn at ffffffff8a071d9c
#17 [ffff96c68627be20] process_one_work at ffffffff89eb9d8f
#18 [ffff96c68627be68] worker_thread at ffffffff89ebae26
#19 [ffff96c68627bec8] kthread at ffffffff89ec1c71

The tasks were waiting for MD_SB_CHANGE_PENDING to clear.


crash> px ((struct mddev *)0xffff96c652c37800)->sb_flags
$5 =3D 0x4


But the system isn't using md-native metadata.=C2=A0 Instead, it's using=20
"imsm" metadata which is handled by mdmon not by the md device's kernel=20
thread.=C2=A0 The kernel notes the use of a metadata handling program by=20
having the mddev flagged as external:


crash> px ((struct mddev *)0xffff96c652c37800)->external
$14 =3D 0x1

And the sosreport shows the version as "imsm" and not an md version.

$ cat sos_commands/md/mdadm_-D_.dev.md | grep Version
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 Version : i=
msm

The mdmon task had been idle and waiting in select() for slighly longer=20
than the oldest tasks stuck in uninterruptible state:

crash> ps -m mdmon
[ 0 00:14:12.722] [IN]=C2=A0 PID: 12346=C2=A0 TASK: ffff96ce7ff3d140=C2=A0=
 CPU: 8=20
COMMAND: "mdmon"
[ 2 16:33:16.686] [IN]=C2=A0 PID: 12344=C2=A0 TASK: ffff96ce5d3430c0=C2=A0=
 CPU: 27=20
COMMAND: "mdmon"


crash> ps -m | grep UN | tail
[ 0 00:14:08.338] [UN]=C2=A0 PID: 310=C2=A0=C2=A0=C2=A0 TASK: ffff96ce7f7=
16180=C2=A0 CPU: 16=20
COMMAND: "kswapd1"
[ 0 00:14:08.404] [UN]=C2=A0 PID: 12057=C2=A0 TASK: ffff96bf61f78000=C2=A0=
 CPU: 0=20
COMMAND: "splunkd"
[ 0 00:14:08.150] [UN]=C2=A0 PID: 10929=C2=A0 TASK: ffff96c6571e5140=C2=A0=
 CPU: 20=20
COMMAND: "splunkd"
[ 0 00:14:08.180] [UN]=C2=A0 PID: 1=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 TASK: f=
fff96bf74b60000=C2=A0 CPU: 33=20
COMMAND: "systemd"
[ 0 00:14:08.231] [UN]=C2=A0 PID: 11179=C2=A0 TASK: ffff96c6b2bc6180=C2=A0=
 CPU: 55=20
COMMAND: "splunkd"
[ 0 00:14:08.138] [UN]=C2=A0 PID: 11713=C2=A0 TASK: ffff96ce7f711040=C2=A0=
 CPU: 15=20
COMMAND: "splunkd"
[ 0 00:14:08.155] [UN]=C2=A0 PID: 12017=C2=A0 TASK: ffff96c6ef518000=C2=A0=
 CPU: 17=20
COMMAND: "splunkd"
[ 0 00:14:08.224] [UN]=C2=A0 PID: 11963=C2=A0 TASK: ffff96bf745f8000=C2=A0=
 CPU: 52=20
COMMAND: "splunkd"
[ 0 00:14:09.561] [UN]=C2=A0 PID: 20684=C2=A0 TASK: ffff96c65342c100=C2=A0=
 CPU: 8=20
COMMAND: "kworker/8:2"
[ 0 00:14:09.757] [UN]=C2=A0 PID: 22690=C2=A0 TASK: ffff96ce502ad140=C2=A0=
 CPU: 42=20
COMMAND: "kworker/42:1"

mdmon never handled the change event and called into md to clear the=20
flag because the file it was polling never received the event md starts=20
by calling sysfs_notify_dirent().=C2=A0 The processing to push the event =
to=20
the file and wake up any polling tasks was still waiting in the kernfs=20
notify list.



crash> px ((struct mddev *)0xffff96c652c37800)->sysfs_state
$30 =3D (struct kernfs_node *) 0xffff96c658f90d20

crash> p kernfs_notify_list
kernfs_notify_list =3D $31 =3D (struct kernfs_node *) 0xffff96c658f90d20

This was still waiting as the work item which would handle the notify=20
events on this list was unable to receive a kworker from low memory.=C2=A0=
=20
kernfs uses the generic system_wq workqueue for this work item.=C2=A0 Thi=
s=20
work item was waiting in a worker_pool for cpu 8:


crash> struct worker_pool 0xffff96c65f81a400
struct worker_pool {
 =C2=A0 lock =3D {
 =C2=A0=C2=A0=C2=A0 {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 rlock =3D {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 raw_lock =3D {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 val =3D {
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 count=
er =3D 0
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
 =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 }
 =C2=A0=C2=A0=C2=A0 }
 =C2=A0 },
 =C2=A0 cpu =3D 8,
 =C2=A0 node =3D 0,
 =C2=A0 id =3D 16,
 =C2=A0 flags =3D 0,
 =C2=A0 watchdog_ts =3D 8210378176,
 =C2=A0 worklist =3D {
 =C2=A0=C2=A0=C2=A0 next =3D 0xffffffff8aab4a88,
 =C2=A0=C2=A0=C2=A0 prev =3D 0xffff96c65f817d08
 =C2=A0 },
 =C2=A0 nr_workers =3D 2,
 =C2=A0 nr_idle =3D 0,
...


Walking the list of pending items:

crash> struct worker_pool.worklist 0xffff96c65f81a400 -o
struct worker_pool {
 =C2=A0 [ffff96c65f81a420] struct list_head worklist;
}

crash> list -H ffff96c65f81a420 -o work_struct.entry -s work_struct.func
ffffffff8aab4a80
 =C2=A0 func =3D 0xffffffff8a0cb660
ffff96c65d561428
 =C2=A0 func =3D 0xffffffffc0839d30
ffff96c65a62b108
 =C2=A0 func =3D 0xffffffffc03bec80 <dm_wq_work>
ffff96c652c34108
 =C2=A0 func =3D 0xffffffffc03bec80 <dm_wq_work>
ffff96c65a629108
 =C2=A0 func =3D 0xffffffffc03bec80 <dm_wq_work>
ffff96ce5a4af9f0
 =C2=A0 func =3D 0xffffffff8a2560d0
ffff96bf7fd5b800
 =C2=A0 func =3D 0xffffffff8a25f4b0
ffff96ce4dadbd10
 =C2=A0 func =3D 0xffffffff89eb7300
ffff96c65f817d00
 =C2=A0 func =3D 0xffffffff89fd7b40

crash> sym 0xffffffff8a0cb660
ffffffff8a0cb660 (t) kernfs_notify_workfn=20
/usr/src/debug/kernel-3.10.0-957.5.1.el7/linux-3.10.0-957.5.1.el7.x86_64/=
fs/kernfs/file.c:=20
800

The first item on the list was the work item to process the notifications=
.

md's use of notifications through sysfs (kernfs) files with alternate=20
metadata formats like imsm can deadlock under memory pressure.=C2=A0 In o=
rder=20
for writes to advance and free up memory, md needs a notification to=20
wake up mdmon to complete.=C2=A0 But the notification cannot advance as t=
he=20
memory pressure means there is no kworker task to run kernfs's notify=20
work item.=C2=A0 The system deadlocked.

This issue is triggered by md's use of notifications through sysfs, but=20
I'm not sure this really belongs as an md bug. kernfs's workqueue usage=20
makes what md is doing to send file events unreliable.
