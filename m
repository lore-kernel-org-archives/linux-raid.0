From: David Brown <david.brown@hesbynett.no>
Subject: Re: Running check and e2fsck simultaneously
Date: Mon, 11 Nov 2013 09:09:50 +0100
Message-ID: <528090CE.4040504@hesbynett.no>
References: <B385A1A4-3EB2-48CA-8EA5-FE8A0F5C2BA0@gmail.com> <527FCBAF.4070208@hardwarefreak.com> <58CD4AD8-0A1E-42E8-984D-F4727EE2B8F0@gmail.com> <527FDBC1.4000009@hardwarefreak.com> <D691C632-1025-4D32-9138-55BF9DE47300@gmail.com> <527FE89A.4010608@hardwarefreak.com> <89667845-9A4C-4402-91BE-0817BCB02C6F@gmail.com> <52805251.2010102@hardwarefreak.com> <6DC2162E-B592-4183-B645-71BC8AC21C76@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6DC2162E-B592-4183-B645-71BC8AC21C76@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ivan Lezhnjov IV <ivan.lezhnjov.iv@gmail.com>, stan@hardwarefreak.com
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 11/11/13 08:52, Ivan Lezhnjov IV wrote:
> 
> On Nov 11, 2013, at 5:43 AM, Stan Hoeppner <stan@hardwarefreak.com>
> wrote:
> 
>>> What about filesystem state? Does it matter if a filesystem is
>>> mounted when check is run?
>> 
>> I'm not an EXT user.  See "man e2fsck".
>> 
>> With XFS you can check while mounted using "xfs_repair -n
>> [device]", but no repairs will be performed, you simply get a
>> report.  To repair a damaged XFS filesystem use the same command
>> sans "-n" on the unmounted filesystem.  xfs_repair will abort if
>> the filesystem is mounted, and "-n" is not specified.  xfs_repair
>> is not to be automated via script/cron.  It is only to be run
>> if/when errors are encountered, usually after a crash, power loss,
>> controller failure, etc.
> 
> Oh, I meant 'check' as in
> 
> echo check > /sys/block/$DEVICE/md/sync_action

In general, you can happily do a raid check while the system is in use
(i.e., the filesystem is mounted).  Of course, if you are using the
system heavily then things will slow down, but it will all work fine.
Raid is designed for maximal uptime - you don't have to stop arrays or
umount filesystems for raid maintenance.

You can also run raid check simultaneously with e2fsck.

But you can't run e2fsck very well while it is mounted.  You /can/ run
it in read-only mode, and if nothing writes to the filesystem (including
touching access times) then it will work.  But in general you will get
false error messages when inconsistencies are found as structures are
written during the check.  (Other tricks include re-mounting as
read-only, and doing an lvm snapshot of the volume then fsck'ing that.)

> 
> That, and I also read on my distro's wiki that 'check' will pick up
> where it was interrupted automatically in those cases when a system
> is rebooted before 'check' is complete. Well, apparently it does not
> work that way because I was only some 4% into 'check' yesterday
> evening, and after resume from sleep mdstat does not show that
> 'check' is running. So, does the distro's wiki contain erroneous
> information?
> 

I can't say anything about that other than general points about "sleep"
being a half-way house between rebooting and running.  It does not
surprise me that you get issues with things not restarting after a sleep
and wakeup.

As far as I understand your posts, you have a laptop that you use as a
normal machine and also as a server.  Presumably you are connected to
mains power rather than a battery.  Why not just let the thing run
overnight?  It's a laptop - it's low power already.  As long as things
like the display turn off (and perhaps the disks too, after some period
without use), the power used will be tiny.  So keep it turned on, or
turn it off - then you don't have any sleep problems.

I don't think you mentioned what distro you are using (I might have
missed it), which makes it difficult to guess what the "distro's wiki" says.


