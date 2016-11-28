From: Chris Murphy <lists@colorremedies.com>
Subject: Re: raid0 vs. mkfs
Date: Sun, 27 Nov 2016 21:11:16 -0700
Message-ID: <CAJCQCtR+PnJXq9k37V1pXVO4UmW0dbhvAZYo=Pius2eCz9X_kg@mail.gmail.com>
References: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56c83c4e-d451-07e5-88e2-40b085d8681c@scylladb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Avi Kivity <avi@scylladb.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Nov 27, 2016 at 8:24 AM, Avi Kivity <avi@scylladb.com> wrote:
> mkfs /dev/md0 can take a very long time, if /dev/md0 is a very large disk
> that supports TRIM/DISCARD (erase whichever is inappropriate)

Trim is the appropriate term. Term discard refers to a specific mount
time implementation of FITRIM ioctl, and fstrim refers to a user space
tool that does the same and can be scheduled or issued manually.



  That is
> because mkfs issues a TRIM/DISCARD (erase whichever is inappropriate) for
> the entire partition. As far as I can tell, md converts the large
> TRIM/DISCARD (erase whichever is inappropriate) into a large number of
> TRIM/DISCARD (erase whichever is inappropriate) requests, one per chunk-size
> worth of disk, and issues them to the RAID components individually.

You could strace the mkfs command. Each filesystem is doing it a
little differently the last time I compared mkfs.xfs and mkfs.btrfs;
but I can't qualify the differences relative to how the device is
going to react to those commands.

It's also possible to enable block device tracing and see the actual
SCSI or ATA commands sent to a drive.

There's a metric f tonne of bugs in this area so before anything I'd
consider researching if there's a firmware update for your hardware
and applying that and retesting. And then also after testing your
ideal deployed version, use something much close to upstream (Arch or
Fedora) and see if the problem is reproducible.



-- 
Chris Murphy
