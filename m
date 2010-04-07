From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Wed, 7 Apr 2010 11:30:35 +1000
Message-ID: <20100407113035.3ca437f2@notabene.brown>
References: <4BBA1289.4010705@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BBA1289.4010705@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>, Dan Williams <dan.j.williams@intel.com>
List-Id: linux-raid.ids

On Mon, 05 Apr 2010 12:40:41 -0400
Doug Ledford <dledford@redhat.com> wrote:

> We have incremental mode for supporting hot plug of devices.  However,
> we don't support hot-unplug.  This is something we need in order to
> enable automatic device replacement.  When implementing the support
> though, I found that we had a problem in that the device special file is
> already gone (well, not gone, but both open and lstat fail on the device
> special file, which really makes Manage_subdevs unhappy) by the time
> udev calls us to remove the device (even if I created a new udev rules
> file with a very low number this was still true).  So, along with adding
> the code shamelessly stolen from Hawrylewicz with modifications to make
> it work on non-container based arrays, I had to modify Manage_subdevs to
> work on sysfs subdevice entries in the fail and remove cases.  Anyway,
> with this in place, and with the modified udev rules file in place,
> hot-unplug now works (or at least it does in my testing, I didn't try a
> container device, I'll leave tweaking that to Dan or someone else from
> Intel, although it should more or less work, I don't know the Intel
> metadata rules and so didn't try to make it work myself).  And by
> changing Manage_subdevs to use either a valid device special file or
> sysfs entries, it will work on the command line with virtually any
> kernel, and work from a udev rules file on kernels recent enough to have
> the state entry in sysfs subdevs directories.
> 
> Oh, and Neil should review my man page additions to see if they are
> sufficient for his tastes.  I didn't get real wordy about the support,
> it's pretty straight forward.
> 

Thanks...

Observations:

-In udev-md-raid.rules you add 
       OPTIONS+="watch"
 Why?

- I cannot say I like the process of hunting through /proc/mdstat for
  a device name that textually matches the name that udev has just
  removed from /dev.  It feels too indirect.
  I was really hoping to just use /sys/$DEVPATH/holders to find the
  containing arrays, but $DEVPATH has been destroyed before udev
  gets to run anything .. even though the final object is still in
  use.  That is really sad!

  So we need to either use the block device name (e.g. sdb) as you
  did or the major:minor numbers. The most direct way to get these
  is with $name or $major:$minor.  And there is no direct way to map between
  them any more, so if mdadm needs both, we have to pass both.

  The name can be used for searching /proc/mdstat or
    /sys/class/block/md*/md/dev-*
  and can be used for failing/removing via sysfs.
  the major:minor can be use for searching with GET_DISK_INFO
  and for failing/removing via ioctl.

  So I'm probably going to have to be satisfied with hunting
  through /proc/mdstat even though I don't like it.
  But if we can just pass $name to mdadm instead of passing
  $ENV{DEVNAME} and stripping the "/dev/" it would be a little
  bit happier. i.e.

    mdadm -If sdb

  would it help do you think to support e.g.

    mdadm -If --devnum $major:$minor $name

  so that mdadm would have the major/minor in case of an old
  kernel without support for removing via sysfs?
  Or something horrible like
       mdadm -If $name($major:$minor)
  ?? maybe not.

- I'm not a big fan of in/out parameters, particularly when they mean
  different things (component device / array device).  I would rather
  replace mdstat_check_active with e.g. mstat_by_component which
  returns a 'struct mdstat_ent' having search for one with a component
  matching the arguement.

- SKIP_GONE_DEVS / KEEP_GONE_DEVS is starting to look really ugly.
  I wonder if we can get rid of both and always do what KEEP_GONE_DEVS
  does.  That will probably require changes elsewhere, but I think it would
  be a good thing.

- man page update looks OK though

+has a chance to include it in some array as appropriate.  Optionally,
+with the
+.I \-\-fail
+flag is passed in then we will remove the device from any active array
+instead of adding it.

  needs to lose 'is' or s/the/if/ or maybe be rewritten.

Thanks.  I'll try to find time to incorporate some of this - I'd like to
break it up into 2 or 3 patches.  One to add dev-name searching in mdstat,
maybe one to change how Manage parses device names so "sdb" can be understood
as a different thing to "/dev/whatever", and one to tie it all together
and provide the new functionality.
Oh, and maybe one to get ride of SKIP_GONE_DEVS.

NeilBrown
