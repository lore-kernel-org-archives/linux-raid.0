From: Corey McGuire <coreyfro@coreyfro.com>
Subject: Re: RAID 5 lost two disks : anyone know of reiser recovery tools?
Date: Sat, 6 Mar 2004 14:25:52 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403061420.53173.coreyfro@coreyfro.com>
References: <200403050926.42047.coreyfro@coreyfro.com> <200403051225.30661.coreyfro@coreyfro.com> <200403060156.11808.coreyfro@coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200403060156.11808.coreyfro@coreyfro.com>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Well, 2.6 didn't stop the segfaulting... it did give a little more info, but 
nothing I can decipher.  I'll paste the section from /var/log/messages at the 
end of this post...

now, if noone knows how to get this thing mounting again, are there any tools 
that would allow me to extract files from the drive?  I am thinking something 
it an FTP like interface.

FSCK seems to SEE the files, and that gives me hope, but because I can't mount 
it, I now have a useless 1TB partition.

So instead of mounting it, is there anyway to get at the files in a primitive 
fashion?

Here's my dump 

Mar  6 13:14:42 ilneval kernel: found reiserfs format "3.6" with standard 
journal
Mar  6 13:14:43 ilneval kernel: Unable to handle kernel paging request at 
virtual address e0999004
Mar  6 13:14:43 ilneval kernel:  printing eip:
Mar  6 13:14:43 ilneval kernel: c019e12d
Mar  6 13:14:43 ilneval kernel: *pde = 1fe7c067
Mar  6 13:14:43 ilneval kernel: *pte = 00000000
Mar  6 13:14:43 ilneval kernel: Oops: 0002 [#1]
Mar  6 13:14:43 ilneval kernel: CPU:    0
Mar  6 13:14:43 ilneval kernel: EIP:    0060:[read_old_bitmaps+189/256]    Not 
tainted
Mar  6 13:14:43 ilneval kernel: EIP:    0060:[<c019e12d>]    Not tainted
Mar  6 13:14:43 ilneval kernel: EFLAGS: 00010282
Mar  6 13:14:43 ilneval kernel: EIP is at read_old_bitmaps+0xbd/0x100
Mar  6 13:14:43 ilneval kernel: eax: da87a4e0   ebx: e0991000   ecx: dfd3b940   
edx: da87a4e0
Mar  6 13:14:43 ilneval kernel: esi: dd619400   edi: 00001000   ebp: db847000   
esp: db90fdf0
Mar  6 13:14:43 ilneval kernel: ds: 007b   es: 007b   ss: 0068
Mar  6 13:14:43 ilneval kernel: Process mount (pid: 833, threadinfo=db90e000 
task=dbacc6e0)
Mar  6 13:14:43 ilneval kernel: Stack: dfda9040 00001003 00001000 00000003 
def6ac00 dd619400 83c30000 000000e5
Mar  6 13:14:43 ilneval kernel:        c019ec93 dd619400 00002000 def6ac1c 
db90fe40 db90fe44 db90fe48 ffffffea
Mar  6 13:14:43 ilneval kernel:        db847000 00000001 dd619510 db90fea0 
00000000 00000000 00000000 c02e07b7
Mar  6 13:14:43 ilneval kernel: Call Trace:
Mar  6 13:14:43 ilneval kernel:  [reiserfs_fill_super+707/1680] 
reiserfs_fill_super+0x2c3/0x690
Mar  6 13:14:43 ilneval kernel:  [<c019ec93>] reiserfs_fill_super+0x2c3/0x690
Mar  6 13:14:43 ilneval kernel:  [disk_name+175/208] disk_name+0xaf/0xd0
Mar  6 13:14:43 ilneval kernel:  [<c01819ff>] disk_name+0xaf/0xd0
Mar  6 13:14:43 ilneval kernel:  [sb_set_blocksize+31/80] 
sb_set_blocksize+0x1f/0x50
Mar  6 13:14:43 ilneval kernel:  [<c01566ff>] sb_set_blocksize+0x1f/0x50
Mar  6 13:14:43 ilneval kernel:  [get_sb_bdev+234/368] get_sb_bdev+0xea/0x170
Mar  6 13:14:43 ilneval kernel:  [<c01560ba>] get_sb_bdev+0xea/0x170
Mar  6 13:14:43 ilneval kernel:  [get_super_block+47/64] 
get_super_block+0x2f/0x40
Mar  6 13:14:43 ilneval kernel:  [<c019f0cf>] get_super_block+0x2f/0x40
Mar  6 13:14:43 ilneval kernel:  [reiserfs_fill_super+0/1680] 
reiserfs_fill_super+0x0/0x690
Mar  6 13:14:43 ilneval kernel:  [<c019e9d0>] reiserfs_fill_super+0x0/0x690
Mar  6 13:14:43 ilneval kernel:  [do_kern_mount+91/240] 
do_kern_mount+0x5b/0xf0
Mar  6 13:14:43 ilneval kernel:  [<c015636b>] do_kern_mount+0x5b/0xf0
Mar  6 13:14:43 ilneval kernel:  [do_add_mount+151/400] 
do_add_mount+0x97/0x190
Mar  6 13:14:43 ilneval kernel:  [<c016c3a7>] do_add_mount+0x97/0x190
Mar  6 13:14:43 ilneval kernel:  [do_mount+404/448] do_mount+0x194/0x1c0
Mar  6 13:14:43 ilneval kernel:  [<c016c744>] do_mount+0x194/0x1c0
Mar  6 13:14:43 ilneval kernel:  [copy_mount_options+140/272] 
copy_mount_options+0x8c/0x110
Mar  6 13:14:43 ilneval kernel:  [<c016c52c>] copy_mount_options+0x8c/0x110
Mar  6 13:14:43 ilneval kernel:  [sys_mount+191/320] sys_mount+0xbf/0x140
Mar  6 13:14:43 ilneval kernel:  [<c016cb3f>] sys_mount+0xbf/0x140
Mar  6 13:14:43 ilneval kernel:  [syscall_call+7/11] syscall_call+0x7/0xb
Mar  6 13:14:43 ilneval kernel:  [<c010906b>] syscall_call+0x7/0xb
Mar  6 13:14:43 ilneval kernel:
Mar  6 13:14:43 ilneval kernel: Code: 89 44 fb 04 8b 86 64 01 00 00 8b 50 08 
b8 01 00 00 00 8b 4c


On Saturday 06 March 2004 01:56 am, Corey McGuire wrote:
> Well, I got the RAID up, I had reiserfsck work its mojo (it looks like I
> lost lots of folder names, but the files appear to remember who they are)
>
> BUT mount segfaults (or something segfaults) every time I try to mount the
> damn thing...
>
> I'm going to try running 2.6.somthing, hoping that maybe of the tools I
> built was just too new for suse 8.2/linux 2.4.23... but i highly doubt
> it... who knows, maybe 2.6 will behave more nicely... i hope mount -o ro
> will be enough to protect me if it doesn't... who knows...
>
> any ideas what might be segfaulting mount?...
>
> this is from /var/log/messages from about the time I tried mounting
>
> Mar  6 01:14:39 ilneval kernel: raid5: switching cache buffer size, 4096
> --> 1024
> Mar  6 01:14:39 ilneval kernel: raid5: switching cache buffer size, 1024
> --> 4096
> Mar  6 01:14:39 ilneval kernel: reiserfs: found format "3.6" with standard
> journal
> Mar  6 01:14:41 ilneval kernel: Unable to handle kernel paging request at
> virtual address e09ce004
> Mar  6 01:14:41 ilneval kernel:  printing eip:
> Mar  6 01:14:41 ilneval kernel: c01839b5
> Mar  6 01:14:41 ilneval kernel: *pde = 1f5f7067
> Mar  6 01:14:41 ilneval kernel: *pte = 00000000
> Mar  6 01:14:41 ilneval kernel: Oops: 0002
> Mar  6 01:14:41 ilneval kernel: CPU:    0
> Mar  6 01:14:41 ilneval kernel: EIP:    0010:[<c01839b5>]    Not tainted
> Mar  6 01:14:41 ilneval kernel: EFLAGS: 00010286
> Mar  6 01:14:41 ilneval kernel: eax: dae13bc0   ebx: e09c6000   ecx:
> dae13c08 edx: dae13bc0
> Mar  6 01:14:41 ilneval kernel: esi: df26a000   edi: 00001000   ebp:
> dbf32000 esp: dbeb1e2c
> Mar  6 01:14:41 ilneval kernel: ds: 0018   es: 0018   ss: 0018
> Mar  6 01:14:41 ilneval kernel: Process mount (pid: 829,
> stackpage=dbeb1000) Mar  6 01:14:41 ilneval kernel: Stack: 00000902
> 00001003 00001000 00000003 00000001 df26a000 00000902 dbf32000
> Mar  6 01:14:41 ilneval kernel:        c01843cc df26a000 00000400 00002000
> dbeb1e68 00000001 00000000 00000000
> Mar  6 01:14:41 ilneval kernel:        00000246 00000000 00000000 00000902
> fffffff3 df26a000 00000001 c013a4ba
> Mar  6 01:14:41 ilneval kernel: Call Trace:    [<c01843cc>] [<c013a4ba>]
> [<c013ad4b>] [<c014c8ae>] [<c013b0d0>]
> Mar  6 01:14:41 ilneval kernel:   [<c014da3e>] [<c014dd6c>] [<c014db95>]
> [<c014e15a>] [<c010745f>]
> Mar  6 01:14:41 ilneval kernel:
> Mar  6 01:14:41 ilneval kernel: Code: 89 44 fb 04 b8 01 00 00 00 8b 96 f4
> 00 00 00 8b 4c fa 04 85
>
> On Friday 05 March 2004 12:25 pm, Corey McGuire wrote:
> > That kinda worked!!!!!! I need to FSCK it, but i'm still afraid of
> > fscking it up...
> >
> > Does anyone in San Jose/San Francisco/Anywhere-in-frag'n-California have
> > a free TB I can use for a DD?  I will offer you my first child!
> >
> > If I need to sweeten the deal, I have LOTS to share... I have a TB of
> > goodies just looking to be backed up!
> >
> > On Friday 05 March 2004 10:14 am, you wrote:
> > > I had a 2 disk failure; I will explain what I did.
> > > 1 disk was bad; it affected all disks on that SCSI buss.
> > > The RAID software got into a bad state, I think I needed to reboot, or
> > > power cycle.
> > > After the reboot, it said 2 disks were non fresh or whatever.
> > > My array had 14 disks, 7 on the buss with the 2 non fresh disks.
> > > I could not do a dd read test with much success on most of the disks,
> > > maybe 2 or 3 seemed ok, but not if I did 2 dd's at the same time.
> > > So I unplugged all disks but 1, tested the 1.  If success repeat with
> > > the next disk.  I found 1 disk that did not work.  So I connected the 6
> > > good disks.  Did 6 dd's at the same time, all was well.
> > >
> > > So, now I have 13 of 14 disks and 1 of the 13 is non fresh.  I issued
> > > this command.
> > >
> > > mdadm -A --force /dev/md2 --scan
> > > For some reason my filesystem was corrupt.  I noticed that the spare
> > > disk was in the list.  I knew the rebuild to the spare never finished. 
> > > It may not have been synced at all since so many disks were not
> > > working.  So, I knew the spare should not be part of the array, yet!
> > >
> > > I had trouble stopping the array, so reboot.
> > >
> > > This time I listed the disks excluding the spare and the failed disk.
> > >
> > > mdadm -A --force /dev/md2 /dev/sdk1 /dev/sdd1 /dev/sdl1 /dev/sde1
> > > /dev/sdm1 /dev/sdf1 /dev/sdn1 /dev/sdg1 /dev/sdh1 /dev/sdo1 /dev/sdi1
> > > /dev/sdp1 /dev/sdj1
> > >
> > > I did not include the missing disk, but I did include the non fresh
> > > disk. Now my filesystem is fine.
> > >
> > > I added the spare, it re-built, a good day!  I bet if this had happened
> > > to a hardware RAID it could not have been saved.
> > >
> > > I replaced the bad disk and added it as a spare.
> > > That was about 1 month ago, everything is still fine.
> > >
> > > You will need to install mdadm if you don't have it.  mdadm does not
> > > use raidtab, it uses /etc/mdadm.conf
> > >
> > > Man mdadm for details!
> > >
> > > Good luck!
> > >
> > > Guy
> > >
> > > =======================================================================
> > >== == = Tips:
> > >
> > > This will give details of each disk.
> > > mdadm -E /dev/hda3
> > > repeat for hdc3, hde3, hdg3, hdi3, hdk3.
> > >
> > > dd test...  To test a disk to determine if the surface is good.
> > > This is just a read test!
> > > dd if=/dev/hda of=/dev/null bs=64k
> > > repeat for hdc, hde, hdg, hdi, hdk.
> > >
> > > My mdadm.conf:
> > > MAILADDR bugzilla@watkins-home.com
> > > PROGRAM /root/bin/handle-mdadm-events
> > >
> > > DEVICE /dev/sd[abcdefghijklmnopqrstuvwxyz][12]
> > >
> > > ARRAY /dev/md0 level=raid1 num-devices=2
> > > UUID=1fb2890c:2c9c47bf:db12e1e3:16cd7ffe
> > >
> > > ARRAY /dev/md1 level=raid1 num-devices=2
> > > UUID=8f183b62:ea93fe30:a842431c:4b93c7bb
> > >
> > > ARRAY /dev/md2 level=raid5 num-devices=14
> > > UUID=8357a389:8853c2d1:f160d155:6b4e1b99
> >
> > -
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
