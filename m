From: =?UTF-8?Q?Bj=C3=B6rn_Augustsson?= <oggust@gmail.com>
Subject: Reshape stuck immediately, backup file all nulls
Date: Sat, 30 Jan 2016 13:21:37 +0100
Message-ID: <CABRqA0i7bAB3Xca1a29u2JYOF2UaE_w1sY73se3menp+ExWWKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Folks,

I wanted to add another disk to a RAID6 array I have. So I ran
$ mdadm --add /dev/md127 /dev/sdj1
$ mdadm --grow --raid-devices=8 --backup-file=/boot/grow_md127.bak  /dev/md127

This appeared to work right, but looking at /proc/mdstat, it says

$ cat /proc/mdstat
Personalities : [raid6] [raid5] [raid4]
md127 : active raid6 sdd1[8] sdj[6] sdg[0] sdk[4] sdh[1] sdi[2] sdc[5] sda1[7]
      14650675200 blocks super 1.2 level 6, 512k chunk, algorithm 2
[8/8] [UUUUUUUU]
      [>....................]  reshape =  0.0% (1/2930135040)
finish=445893299483.7min speed=0K/sec

unused devices: <none>

That is, it's stuck. And it's been that way since (about 36h now)

Looking at some logs, I found this in messages:

Jan 28 20:24:27 ooo systemd: Created slice
system-mdadm\x2dgrow\x2dcontinue.slice.
Jan 28 20:24:27 ooo audit: SERVICE_START pid=1 uid=0 auid=4294967295
ses=4294967295 subj=system_u:system_r:init_t:s0
msg='unit=mdadm-grow-continue@md127 comm="systemd"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=?
 res=success'
Jan 28 20:24:27 ooo systemd: Starting system-mdadm\x2dgrow\x2dcontinue.slice.
Jan 28 20:24:28 ooo audit: AVC avc:  denied  { write } for  pid=11103
comm="mdadm" name="grow_md127.bak" dev="sdf1" ino=426
scontext=system_u:system_r:mdadm_t:s0
tcontext=unconfined_u:object_r:boot_t:s0 tclass=file permissive=0
Jan 28 20:24:28 ooo audit: SYSCALL arch=c000003e syscall=2 success=no
exit=-13 a0=ec1fc0 a1=242 a2=180 a3=7800 items=0 ppid=1 pid=11103
auid=4294967295 uid=0 gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0
fsgid=0 tty=(none) ses=4294
967295 comm="mdadm" exe="/usr/sbin/mdadm"
subj=system_u:system_r:mdadm_t:s0 key=(null)
Jan 28 20:24:28 ooo systemd: mdadm-grow-continue@md127.service: Main
process exited, code=exited, status=1/FAILURE
Jan 28 20:24:28 ooo systemd: mdadm-grow-continue@md127.service: Unit
entered failed state.
Jan 28 20:24:28 ooo audit: SERVICE_STOP pid=1 uid=0 auid=4294967295
ses=4294967295 subj=system_u:system_r:init_t:s0
msg='unit=mdadm-grow-continue@md127 comm="systemd"
exe="/usr/lib/systemd/systemd" hostname=? addr=? terminal=?
res=failed'
Jan 28 20:24:28 ooo systemd: mdadm-grow-continue@md127.service: Failed
with result 'exit-code'.
Jan 28 20:24:32 ooo setroubleshoot: SELinux is preventing
/usr/sbin/mdadm from write access on the file grow_md127.bak. For
complete SELinux messages. run sealert -l
43815f80-8b00-40d9-86a3-4a6a432f3e05
Jan 28 20:24:32 ooo python3: SELinux is preventing /usr/sbin/mdadm
from write access on the file grow_md127.bak.#012#012*****  Plugin
kernel_modules (91.4 confidence) suggests
********************#012#012If you do not think m
dadm should try write access on grow_md127.bak.#012Then you may be
under attack by a hacker, since confined applications should not need
this access.#012Do#012contact your security administrator and report
this issue.#012#012**
***  Plugin catchall (9.59 confidence) suggests
**************************#012#012If you believe that mdadm should be
allowed write access on the grow_md127.bak file by default.#012Then
you should report this as a bug.#012You
 can generate a local policy module to allow this
access.#012Do#012allow this access for now by executing:#012# grep
mdadm /var/log/audit/audit.log | audit2allow -M mypol#012# semodule -i
mypol.pp#012

So it seems selinux is preventing writes to the backup file I specified.
(I put it in /boot, since that's the only file system I have that's
not on the array.)
Interestingly, the file exists

$ ls -l /boot/grow_md127.bak
-rw-------. 1 root root 15732736 Jan 28 20:24 /boot/grow_md127.bak
$
but it's all nulls (as in the case at
http://www.spinics.net/lists/raid/msg40771.html )

The question is, what kind of state am in now? And how should I recover?
Will just adding a policy to allow access to that file, and then
mdadm --grow --continue /dev/md127
fix it? Is the broken backup file going to be a problem?

The system is an uptodate Fedora 23, x86_64, with kernel
4.3.3-303.fc23.x86_64 and mdadm-3.3.4-2.fc23.x86_64.

Thanks,

/August.
-- 
Wrong on most accounts.  const Foo *foo; and Foo const *foo; mean the same: foo
being a pointer to const Foo.  const Foo const *foo; would mean the same but is
illegal (double const).  You are confusing this with Foo * const foo; and const
Foo * const foo; respectively. -David Kastrup, comp.os.linux.development.system
