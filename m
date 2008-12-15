From: Neil Brown <neilb@suse.de>
Subject: Re: status of raid 4/5 disk reduce
Date: Tue, 16 Dec 2008 10:18:09 +1100
Message-ID: <18758.58801.598933.281565@notabene.brown>
References: <493D8A95.2020700@mikebrancato.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Michael Brancato on Monday December 8
Sender: linux-raid-owner@vger.kernel.org
To: Michael Brancato <mike@mikebrancato.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Monday December 8, mike@mikebrancato.com wrote:
> I'm curious as to the status of the ability to reduce the number of 
> disks in a RAID 4/5 array.  I would like the ability to reshape a 4 disk 
> raid4/5 to a 3 disk raid4/5 for flexibility.
> 
> here is what I want to do....
> $ sudo mdadm /dev/md0 --fail /dev/disk4 --remove /dev/disk4
> mdadm: set /dev/disk4 faulty in /dev/md0
> mdadm: hot removed /dev/disk4
> $ sudo mdadm --grow /dev/md0 -n3
> mdadm: /dev/md0: Cannot reduce number of data disks (yet).
> 
> I know this capability is missing in the md driver.  What is needed to 
> make it work and is anyone currently working on it?

It is on my todo list, but I am not currently working on it.  Maybe
next year.

There are three sorts of restriping.

1/ When the total amount of space grows.
   In this case we are (for the most part) reading data from later in
   the devices and writing it somewhere earlier in the devices.
   So we progress forward through the devices (from low blocks
   addresses to high block address) often having two copies of the
   data that is currently being moved, so we can be sure of finding
   good data after a crash.

2/ When the total amount of space shrinks.
   This is the reverse of the above.  Data is moved from early in the
   device to later in the device, so we start at the end and move
   backwards (from high block addresses to low block addresses).
   Again, the data which is currently being moved is easily safe in
   the face of a system crash.

3/ When the total amount of space remains unchanged (e.g. raid5 to
   raid6 with one extra device).
   To make this crash proof we would need to copy N stripes of data
   into some backup area, then copy it back in the new layout, then
   update the metadata.
   So this will be much slower than other restriping (which is already
   slow). 

Only '1' is currently implemented.

'2' should be fairly easy.  There are some fiddly bits such as mapping
the forward progress that md insists on into a backwards progress, but
that is quite manageable.

'3' would require a user-space helper to be copying data to backup and
then allowing the restripe to progress a bit further.

NeilBrown
