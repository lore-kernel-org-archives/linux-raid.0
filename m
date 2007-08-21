From: "Greg Nicholson" <d0gz.net@gmail.com>
Subject: Re: Raid5 Reshape gone wrong, please help
Date: Mon, 20 Aug 2007 21:09:01 -0500
Message-ID: <c92bcddf0708201909w2534c25du6282fd661ed838f5@mail.gmail.com>
References: <c92bcddf0708171826n5991b3ffw1094e0e8c44c97e8@mail.gmail.com>
	 <18118.46141.966406.577626@notabene.brown>
	 <c92bcddf0708180837y4d92d2b4x3a4308e77b515ab3@mail.gmail.com>
	 <18120.9950.578786.624453@notabene.brown>
	 <c92bcddf0708190845k485a8460q609b16a8795bc288@mail.gmail.com>
	 <c92bcddf0708191944x4aab7770ga6815210109dca6f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <c92bcddf0708191944x4aab7770ga6815210109dca6f@mail.gmail.com>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 8/19/07, Greg Nicholson <d0gz.net@gmail.com> wrote:
> On 8/19/07, Greg Nicholson <d0gz.net@gmail.com> wrote:
> > On 8/19/07, Neil Brown <neilb@suse.de> wrote:
> > > On Saturday August 18, d0gz.net@gmail.com wrote:
> > > >
> > > > That looks to me like the first 2 gig is completely empty on the
> > > > drive.  I really don't think it actually started to do anything.
> > >
> > > The backup data is near the end of the device.  If you look at the
> > > last 2 gig you should see something.
> > >
> >
> > I figured something like that after I started thinking about it...
> > That device is currently offline while I do some DD's to new devices.
> >
> > > >
> > > > Do you have further suggestions on where to go now?
> > >
> > > Maybe an 'strace' of "mdadm -A ...." might show me something.
> > >
> > > If you feel like following the code, Assemble (in Assemble.c) should
> > > call Grow_restart.
> > > This should look in /dev/sdb1 (which is already open in 'fdlist') by
> > > calling 'load_super'.  It should then seek to 8 sectors before the
> > > superblock (or close to there) and read a secondary superblock which
> > > describes the backup data.
> > > If this looks good, it seeks to where the backup data is (which is
> > > towards the end of the device) and reads that.  It uses this to
> > > restore the 'critical section', and then updates the superblock on all
> > > devices.
> > >
> > > As you aren't getting the messages 'restoring critical section',
> > > something is going wrong before there.  It should fail:
> > >   /dev/md0: Failed to restore critical section for reshape, sorry.
> > > but I can see that there is a problem with the error return from
> > > 'Grow_restart'.  I'll get that fixed.
> > >
> > >
> > > >
> > > > Oh, and thank you very much for your help.  Most of the data on this
> > > > array I can stand to loose... It's not critical, but there are some of
> > > > my photographs on this that my backup is out of date on.  I can
> > > > destroy it all and start over, but really want to try to recover this
> > > > if it's possible.  For that matter, if it didn't actually start
> > > > rewriting the stripes, is there anyway to push it back down to 4 disks
> > > > to recover ?
> > >
> > > You could always just recreate the array:
> > >
> > >  mdadm -C /dev/md0 -l5 -n4 -c256 --assume-clean /dev/sdf1 /dev/sde1  \
> > >     /dev/sdd1 /dev/sdc1
> > >
> > > and make sure the data looks good (which it should).
> > >
> > > I'd still like to know that the problem is though....
> > >
> > > Thanks,
> > > NeilBeon
> > >
> >
> > My current plan of attack, which I've been proceeding upon for the
> > last 24 hours... I'm DDing the original drives to new devices.  Once I
> > have copies of the drives, I'm going to try to recreate the array as a
> > 4 device array.  Hopefully, at that point, the raid will come up, LVM
> > will initialize, and it's time to saturate the GigE offloading
> > EVERYTHING.
> >
> > Assuming the above goes well.... which will definitely take some time,
> > Then I'll take the original drives, run the strace and try to get some
> > additional data for you.  I'd love to know what's up with this as
> > well.  If there is additional information I can get you to help, let
> > me know.  I've grown several arrays before without any issue, which
> > frankly is why I didn't think this would have been an issue.... thus,
> > my offload of the stuff I actually cared about wasn't up to date.
> >
> > At the end of day (or more likely, week)  I'll completely destroy the
> > existing raid, and rebuild the entire thing to make sure I'm starting
> > from a good base.  At least at that point, I'll have additional
> > drives.  Given that I have dual File-servers that will have drives
> > added, it seems likely that I'll be testing the code again soon.  Big
> > difference being that this time, I won't make the assumption that
> > everything will be perfect. :)
> >
> > Thanks again for your help, I'll post on my results as well as try to
> > get you that strace.  It's been quite a while since I dove into kernel
> > internals, or C for that matter, so it's unlikely I'm going to find
> > anything myself.... But I'll definitely send results back if I can.
> >
>
>
> Ok, as an update.  ORDER MATTERS.  :)
>
> The above command didn't work.  It built, but LVM didn't recognize.
> So, after despair, I thought, that's not the way I built it.  So, I
> redid it in Alphabetical order... and it worked.
>
> I'm in the process of taring and pulling everything off.
>
> Once that is done, I'll put the original drives back in, and try to
> understand what went wrong with the original grow/build.
>

And as a final update... I pulled all the data from the 4 disk array I
built from the copied Disks.  Everything looks to be intact.  That is
definitely a better feeling for me.

I then put the original disks back in, and compiled 2.6.3 to see if it
did any better on the assemble.  It appears that your update about the
critical section missing was successful, as mdadm cheerfully informed
me I was out of luck. :)

I'm attaching the strace, even though I don't think it will be of much
help... It appears that you solved the critical section failure.... at
least it's verbose about telling you.

I still don't know what happened originally... I think I had an older
copy of mdadm in my path, and that could have been the issue.
Obviously that's no longer the case.  I'll be using the backup file
flag from now on, and probably won't be quite as daring about flying
without a (current, tested) net. :)

Thanks for your help again.


Attached strace from 2.6.3
root@excimer { ~/mdadm-2.6.3 }$ strace mdadm -A /dev/md0 /dev/sd[bcdef]1
execve("/sbin/mdadm", ["mdadm", "-A", "/dev/md0", "/dev/sdb1",
"/dev/sdc1", "/dev/sdd1", "/dev/sde1", "/dev/sdf1"], [/* 20 vars */])
= 0
uname({sys="Linux", node="excimer", ...}) = 0
brk(0)                                  = 0x807b000
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
mmap2(NULL, 8192, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f78000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=51870, ...}) = 0
mmap2(NULL, 51870, PROT_READ, MAP_PRIVATE, 3, 0) = 0xb7f6b000
close(3)                                = 0
access("/etc/ld.so.nohwcap", F_OK)      = -1 ENOENT (No such file or directory)
open("/lib/tls/libc.so.6", O_RDONLY)    = 3
read(3, "\177ELF\1\1\1\0\0\0\0\0\0\0\0\0\3\0\3\0\1\0\0\0\240O\1"..., 512) = 512
fstat64(3, {st_mode=S_IFREG|0644, st_size=1241392, ...}) = 0
mmap2(NULL, 1251484, PROT_READ|PROT_EXEC, MAP_PRIVATE|MAP_DENYWRITE,
3, 0) = 0xb7e39000
mmap2(0xb7f61000, 28672, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x127) = 0xb7f61000
mmap2(0xb7f68000, 10396, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0xb7f68000
close(3)                                = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7e38000
mprotect(0xb7f61000, 20480, PROT_READ)  = 0
set_thread_area({entry_number:-1 -> 6, base_addr:0xb7e388e0,
limit:1048575, seg_32bit:1, contents:0, read_exec_only:0,
limit_in_pages:1, seg_not_present:0, useable:1}) = 0
munmap(0xb7f6b000, 51870)               = 0
time(NULL)                              = 1187661547
getpid()                                = 5453
brk(0)                                  = 0x807b000
brk(0x809c000)                          = 0x809c000
open("/etc/mdadm.conf", O_RDONLY)       = -1 ENOENT (No such file or directory)
open("/etc/mdadm/mdadm.conf", O_RDONLY) = 3
fstat64(3, {st_mode=S_IFREG|0644, st_size=191, ...}) = 0
mmap2(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0xb7f77000
read(3, "DEVICE /dev/sda1\nDEVICE /dev/sdb"..., 4096) = 191
read(3, "", 4096)                       = 0
read(3, "", 4096)                       = 0
close(3)                                = 0
munmap(0xb7f77000, 4096)                = 0
stat64("/dev/md0", {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 0), ...}) = 0
open("/dev/md0", O_RDWR)                = 3
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 0), ...}) = 0
ioctl(3, 0x800c0910, 0xbf828344)        = 0
uname({sys="Linux", node="excimer", ...}) = 0
fstat64(3, {st_mode=S_IFBLK|0660, st_rdev=makedev(9, 0), ...}) = 0
ioctl(3, 0x800c0910, 0xbf8280d4)        = 0
ioctl(3, 0x80480911, 0xbf8282b8)        = -1 ENODEV (No such device)
ioctl(3, 0x932, 0)                      = 0
open("/dev/sdb1", O_RDONLY|O_EXCL)      = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 17), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbf827fa0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
ioctl(4, BLKGETSIZE64, 0xbf827ee0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105207808, [500105207808], SEEK_SET) = 0
read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1024) = 1024
ioctl(4, BLKGETSIZE64, 0xbf827ee0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 0, [0], SEEK_SET)            = 0
read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1024) = 1024
ioctl(4, BLKGETSIZE64, 0xbf827ee0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 4096, [4096], SEEK_SET)      = 0
read(4, "\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0\0"...,
1024) = 1024
ioctl(4, BLKGETSIZE64, 0xbf827fa0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
open("/dev/sdc1", O_RDONLY|O_EXCL)      = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 33), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
open("/dev/sdd1", O_RDONLY|O_EXCL)      = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 49), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
open("/dev/sde1", O_RDONLY|O_EXCL)      = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 65), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
open("/dev/sdf1", O_RDONLY|O_EXCL)      = 4
fstat64(4, {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 81), ...}) = 0
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
open("/dev/sdb1", O_RDWR|O_EXCL)        = 4
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
stat64("/dev/sdb1", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 17), ...}) = 0
open("/dev/sdc1", O_RDWR|O_EXCL)        = 4
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
stat64("/dev/sdc1", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 33), ...}) = 0
open("/dev/sdd1", O_RDWR|O_EXCL)        = 4
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
stat64("/dev/sdd1", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 49), ...}) = 0
open("/dev/sde1", O_RDWR|O_EXCL)        = 4
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
stat64("/dev/sde1", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 65), ...}) = 0
open("/dev/sdf1", O_RDWR|O_EXCL)        = 4
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKPG, 0xbf828124)             = -1 EINVAL (Invalid argument)
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
stat64("/dev/sdf1", {st_mode=S_IFBLK|0660, st_rdev=makedev(8, 81), ...}) = 0
open("/dev/sdc1", O_RDONLY|O_EXCL)      = 4
ioctl(4, BLKGETSIZE64, 0xbf8280b0)      = 0
ioctl(4, BLKFLSBUF, 0)                  = 0
_llseek(4, 500105150464, [500105150464], SEEK_SET) = 0
read(4, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
close(4)                                = 0
open("/dev/sdc1", O_RDWR|O_EXCL)        = 4
open("/dev/sdd1", O_RDWR|O_EXCL)        = 5
open("/dev/sde1", O_RDWR|O_EXCL)        = 6
open("/dev/sdf1", O_RDWR|O_EXCL)        = 7
open("/dev/sdb1", O_RDWR|O_EXCL)        = 8
ioctl(8, BLKGETSIZE64, 0xbf826ed0)      = 0
ioctl(8, BLKFLSBUF, 0)                  = 0
_llseek(8, 500105150464, [500105150464], SEEK_SET) = 0
read(8, "\374N+\251\0\0\0\0[\0\0\0\0\0\0\0\0\0\0\0\323r\244\251"...,
4096) = 4096
_llseek(8, 500104949760, [500104949760], SEEK_SET) = 0
read(8, "md_backup_data-1\323r\244\251\2\306\206\225xo\5\177\267"..., 68) = 68
close(8)                                = 0
close(7)                                = 0
close(6)                                = 0
close(5)                                = 0
close(4)                                = 0
write(2, "mdadm: Failed to restore critica"..., 62mdadm: Failed to
restore critical section for reshape, sorry.
) = 62
exit_group(1)                           = ?
Process 5453 detached
