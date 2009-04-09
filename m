From: Neil Brown <neilb@suse.de>
Subject: Re: RAID5 in strange state
Date: Thu, 9 Apr 2009 15:51:30 +1000
Message-ID: <18909.36066.257787.899820@notabene.brown>
References: <49DD1730.4070108@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Frank Baumgart on Wednesday April 8
Sender: linux-raid-owner@vger.kernel.org
To: Frank Baumgart <frank.baumgart@gmx.net>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wednesday April 8, frank.baumgart@gmx.net wrote:
> Dear List,
> 
> I use MD RAID 5 since some years and so far had to recover from single
> disk failures a few times which was always successful.

Good to hear!

> Now though, I am puzzled.
> 
> Setup:
> Some PC with 3x WD 1 TB SATA disk drives set up as RAID 5 using kernel
> 2.6.27.21 (now); the array ran fine for at least 6 months now.
> 
> I check the state of the RAID every few days with looking at
> /proc/mdstat manually.

You should set up "mdadm --monitor" to do that for you.
Run
  mdadm --monitor --email=root@myhost --scan
at boot time and
  mdadm --monitor --oneshot --scan --email=root@whatever
as a cron job once a day to nag you about degraded arrays

and you should get email whenever something is amiss.  It doesn't hurt
to also check manually occasionally of course.

> Apparently one drive had been kicked out of the array 4 days ago without
> me noticing it.
> Root cause seemed to be bad cabling but is not confirmed yet.
> Anyway, the disc in question ("sde") reports 23 UDMA_CRC errors,
> compared to 0 about 2 weeks ago.
> Reading the complete device just now via DD still reports those 23
> errors but no new ones.
> 
> Well, RAID 5 should survive a single disc failure (again) but after a
> reboot (due to non-RAID related reasons) the RAID came up as "md0 stopped".
> 
> cat /proc/mdstat
> 
> Personalities :
> md0 : inactive sdc1[1](S) sdd1[2](S) sde1[0](S)
>       2930279424 blocks
> 
> unused devices: <none>
> 
> 
> 
> What's that?

I would need to see kernel logs to be able to guess why.
Presumably it was mdadm which attempted to start the array.
If you can run
  mdadm --assemble -vv /dev/md0 /dev/sd[cde]1
and get useful messages that might help.   Though maybe it is too late
and you have already started the array.


> First, documentation on the web is rather outdated and/or incomplete.
> Second, my guess that "(S)" represents a spare is backuped up by the
> kernel source.

Yes, though when an array is "inactive", everything is considered to
be a spare.

> 
> The state though differs:
> 
> sdc1:
>     Update Time : Tue Apr  7 20:51:33 2009
>           State : clean
             ^^^^^^^^^^^^

The fact that the two devices that are still working think the array
is 'clean' should be enough to start the array.  If they thought it
was dirty (aka 'active'), mdadm would refuse to start the array
because an active degraded array could potentially have corrupted data
and you need to know that...

> sde1:
>           State : active
             ^^^^^^^^^^^^^

sde1 is active, but that is the failed device, so that fact that it is
active shouldn't have an effect... by maybe there is a bug somewhere
and it does.

What versions of mdadm and linux are you using?  I'll see if that
situation could cause a breakage.
> 
> My backup is a few days old and I would really like to keep the work on
> the RAID done in the meantime.
> 
> If the answer is just 2 or 3 mdadm command lines, I am yours :-)

If you haven't got it working already, 

  mdadm -A /dev/md0 -vvv /dev/sd[cde]1
and report the messages produced, then
  mdadm -A --force /dev/md0 -vvv /dev/sd[cd]1
  mdadm /dev/md0 -a /dev/sde1

NeilBrown
