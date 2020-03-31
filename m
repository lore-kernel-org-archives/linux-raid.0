From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Raid-6 won't boot
Date: Tue, 31 Mar 2020 09:43:40 -0500
Message-ID: <CAAMCDed=3-=T0Mbr9=Pp0Ms_RPNqfJftaXhM2FjxBvAvunXuXg@mail.gmail.com>
References: <7ce3a1b9-7b24-4666-860a-4c4b9325f671@shenkin.org>
 <3868d184-5e65-02e1-618a-2afeb7a80bab@youngman.org.uk> <ccab6f84-aab3-f483-e473-64d95cbeb7cc@shenkin.org>
 <CAAMCDee6TcJ_wR6rkQw5V02KyqPQ+xDf+bK+pQPbbfaptO_Tvg@mail.gmail.com>
 <1f393884-dc48-c03e-f734-f9880d9eed96@shenkin.org> <CAAMCDedj7TQAAGzSfQgAftKSmrjNmzHgQUs-X2mQZyFPG62_-A@mail.gmail.com>
 <c8185f80-837e-9654-ee19-611a030a0d54@shenkin.org> <CAAMCDefr2FakGTz5ok-qvTZiDNTj87vQSWP9ynM_bxtnB=-fkw@mail.gmail.com>
 <fa7e9b6d-28f3-8c9f-0901-eeac761e382f@shenkin.org> <CAAMCDefXygV4CZdxadfRFAV+HeEqnY8nWG1hpsVi4tBf1PYYww@mail.gmail.com>
 <740b37a3-83fa-a03f-c253-785bb286cefc@shenkin.org> <CAAMCDecv1-rY9Rt1puDn6WPYxGZ1=Qzje1ju=7aEOonBzkekVw@mail.gmail.com>
 <98b9aff4-978c-5d8d-1325-bda26bf7997f@shenkin.org> <CAAMCDeeLYYy5NY9xTad0zyF3J-y=7sZGXTYoueP=TKNGSZaBww@mail.gmail.com>
 <7cbd271f-4b5a-f91c-a08e-cb0515a414bc@shenkin.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7cbd271f-4b5a-f91c-a08e-cb0515a414bc@shenkin.org>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Shenkin <al@shenkin.org>
Cc: antlists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Yes, you would have to activate it.   Since raid456 was not loaded
when the udev triggers happened at device creation then it would have
failed to be able to assemble it.

Do this: "lsinitrd /yourrealboot/initr*-younormalbootkernel | grep -i
raid456" if that returns nothing then that module is not in the initrd
and that would produce a failure to find the rootfs when the rootfs is
on a raid4/5/6 device.

You probably need to look at /etc/dracut.conf and/or
/etc/dracut.conf.d and make sure mdraid modules is being installed,
and rebuild the initrd, after rebuilding it then rerun the above test,
if it does not show raid456 then you will need to add explicit options
to include that specific module.

There should be instructions on how to rebuild an initrd from a livecd
boot, I have a pretty messy way to do it but my way may not be
necessary when livecd is very similar to boot os.  Most of the ones I
rebuild it, the livecd is much newer than the actual host os, so to
get a clean boot you have to mount the system at say /mnt (and any
others if you separate fs on root) and boot at /mnt/boot and do a few
bind mounts to get /proc /sys /dev visable under /mnt and chroot /mnt
and run the commands from the install to rebuild init and use the
config from the actual install.

On Tue, Mar 31, 2020 at 9:28 AM Alexander Shenkin <al@shenkin.org> wrote:
>
> Thanks Roger,
>
> modprobe raid456 did the trick.  md126 is still showing up as inactive
> though.  Do I need to bring it online after I activate the raid456 module?
>
> I could copy the results of /proc/cmdline over here if still necessary,
> but I figure it's likely not now that we've found raid456...  It's just
> a single line specifying the BOOT_IMAGE...
>
> thanks,
> allie
>
> On 3/31/2020 2:53 PM, Roger Heflin wrote:
> > the fedora live cds I think used to have it.  It could be build into
> > the kernel or it could be loaded as a module.
> >
> > See if there is a config* file on /boot and if so do a "grep -i
> > raid456 configfilename"   if it is =y it is build into the kernel, if
> > =m it is a module and you should see it in lsmod so if you don't the
> > module is not loaded, but it was built  as a module.
> >
> > if=m then Try "modprobe raid456" that should load it if  it is on the livecd.
> >
> > if that fails do a find /lib/modules -name "raid456*" -ls and see if
> > it exists in the modules directory.
> >
> > If it is built into the kernel =y then something is probably wrong
> > with the udev rules not triggering and building and enabling the raid6
> > array on the livecd.  THere is a reasonable chance that whatever this
> > is is also the problem with your booting os as it would need the right
> > parts in the initramfs.
> >
> > What does cat /proc/cmdline look like?   There are some options on
> > there that can cause md's to get ignored at boot time.
> >
> >
> >
> > On Tue, Mar 31, 2020 at 5:08 AM Alexander Shenkin <al@shenkin.org> wrote:
> >>
> >> Thanks Roger,
> >>
> >> It seems only the Raid1 module is loaded.  I didn't find a
> >> straightforward way to get that module loaded... any suggestions?  Or,
> >> will I have to find another livecd that contains raid456?
> >>
> >> Thanks,
> >> Allie
> >>
> >> On 3/30/2020 9:45 PM, Roger Heflin wrote:
> >>> They all seem to be there, all seem to report all 7 disks active, so
> >>> it does not appear to be degraded. All event counters are the same.
> >>> Something has to be causing them to not be scanned and assembled at
> >>> all.
> >>>
> >>> Is the rescue disk a similar OS to what you have installed?  If it is
> >>> you might try a random say fedora livecd and see if it acts any
> >>> different.
> >>>
> >>> what does fdisk -l /dev/sda look like?
> >>>
> >>> Is the raid456 module loaded (lsmod | grep raid)?
> >>>
> >>> what does cat /proc/cmdline look like?
> >>>
> >>> you might also run this:
> >>> file -s /dev/sd*3
> >>> But I think it is going to show us the same thing as what the mdadm
> >>> --examine is reporting.
> >>>
> >>> On Mon, Mar 30, 2020 at 3:05 PM Alexander Shenkin <al@shenkin.org> wrote:
> >>>>
> >>>> See attached.  I should mention that the last drive i added is on a new
> >>>> controller that is separate from the other drives, but seemed to work
> >>>> fine for a bit, so kinda doubt that's the issue...
> >>>>
> >>>> thanks,
> >>>>
> >>>> allie
> >>>>
> >>>> On 3/30/2020 6:21 PM, Roger Heflin wrote:
> >>>>> do this against each partition that had it:
> >>>>>
> >>>>>  mdadm --examine /dev/sd***
> >>>>>
> >>>>> It seems like it is not seeing it as a md-raid.
> >>>>>
> >>>>> On Mon, Mar 30, 2020 at 11:13 AM Alexander Shenkin <al@shenkin.org> wrote:
> >>>>>> Thanks Roger,
> >>>>>>
> >>>>>> The only line that isn't commented out in /etc/mdadm.conf is "DEVICE
> >>>>>> partitions"...
> >>>>>>
> >>>>>> Thanks,
> >>>>>>
> >>>>>> Allie
> >>>>>>
> >>>>>> On 3/30/2020 4:53 PM, Roger Heflin wrote:
> >>>>>>> That seems really odd.  Is the raid456 module loaded?
> >>>>>>>
> >>>>>>> On mine I see messages like this for each disk it scanned and
> >>>>>>> considered as maybe possibly being an array member.
> >>>>>>>  kernel: [   83.468700] md/raid:md13: device sdi3 operational as raid disk 5
> >>>>>>> and messages like this:
> >>>>>>>  md/raid:md14: not clean -- starting background reconstruction
> >>>>>>>
> >>>>>>> You might look at /etc/mdadm.conf on the rescue cd and see if it has a
> >>>>>>> DEVICE line that limits what is being scanned.
> >>>>>>>
> >>>>>>> On Mon, Mar 30, 2020 at 10:13 AM Alexander Shenkin <al@shenkin.org> wrote:
> >>>>>>>> Thanks Roger,
> >>>>>>>>
> >>>>>>>> that grep just returns the detection of the raid1 (md127).  See dmesg
> >>>>>>>> and mdadm --detail results attached.
> >>>>>>>>
> >>>>>>>> Many thanks,
> >>>>>>>> allie
> >>>>>>>>
> >>>>>>>> On 3/28/2020 1:36 PM, Roger Heflin wrote:
> >>>>>>>>> Try this grep:
> >>>>>>>>> dmesg | grep "md/raid", if that returns nothing if you can just send
> >>>>>>>>> the entire dmesg.
> >>>>>>>>>
> >>>>>>>>> On Sat, Mar 28, 2020 at 2:47 AM Alexander Shenkin <al@shenkin.org> wrote:
> >>>>>>>>>> Thanks Roger.  dmesg has nothing in it referring to md126 or md127....
> >>>>>>>>>> any other thoughts on how to investigate?
> >>>>>>>>>>
> >>>>>>>>>> thanks,
> >>>>>>>>>> allie
> >>>>>>>>>>
> >>>>>>>>>> On 3/27/2020 3:55 PM, Roger Heflin wrote:
> >>>>>>>>>>> A non-assembled array always reports raid1.
> >>>>>>>>>>>
> >>>>>>>>>>> I would run "dmesg | grep md126" to start with and see what it reports it saw.
> >>>>>>>>>>>
> >>>>>>>>>>> On Fri, Mar 27, 2020 at 10:29 AM Alexander Shenkin <al@shenkin.org> wrote:
> >>>>>>>>>>>> Thanks Wol,
> >>>>>>>>>>>>
> >>>>>>>>>>>> Booting in SystemRescueCD and looking in /proc/mdstat, two arrays are
> >>>>>>>>>>>> reported.  The first (md126) in reported as inactive with all 7 disks
> >>>>>>>>>>>> listed as spares.  The second (md127) is reported as active
> >>>>>>>>>>>> auto-read-only with all 7 disks operational.  Also, the only
> >>>>>>>>>>>> "personality" reported is Raid1.  I could go ahead with your suggestion
> >>>>>>>>>>>> of mdadm --stop array and then mdadm --assemble, but I thought the
> >>>>>>>>>>>> reporting of just the Raid1 personality was a bit strange, so wanted to
> >>>>>>>>>>>> check in before doing that...
> >>>>>>>>>>>>
> >>>>>>>>>>>> Thanks,
> >>>>>>>>>>>> Allie
> >>>>>>>>>>>>
> >>>>>>>>>>>> On 3/26/2020 10:00 PM, antlists wrote:
> >>>>>>>>>>>>> On 26/03/2020 17:07, Alexander Shenkin wrote:
> >>>>>>>>>>>>>> I surely need to boot with a rescue disk of some sort, but from there,
> >>>>>>>>>>>>>> I'm not sure exactly when I should do.  Any suggestions are very welcome!
> >>>>>>>>>>>>> Okay. Find a liveCD that supports raid (hopefully something like
> >>>>>>>>>>>>> SystemRescueCD). Make sure it has a very recent kernel and the latest
> >>>>>>>>>>>>> mdadm.
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> All being well, the resync will restart, and when it's finished your
> >>>>>>>>>>>>> system will be fine. If it doesn't restart on its own, do an "mdadm
> >>>>>>>>>>>>> --stop array", followed by an "mdadm --assemble"
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> If that doesn't work, then
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> https://raid.wiki.kernel.org/index.php/Linux_Raid#When_Things_Go_Wrogn
> >>>>>>>>>>>>>
> >>>>>>>>>>>>> Cheers,
> >>>>>>>>>>>>> Wol
