From: David Greaves <david@dgreaves.com>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Tue, 24 Apr 2007 10:22:22 +0100
Message-ID: <462DCC4E.2020108@dgreaves.com>
References: <462CC91B.8030008@dgreaves.com>	<16046.1177356707@mdt.dhcp.pit.laurelnetworks.com> <17965.18112.135843.417561@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17965.18112.135843.417561@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Mike Accetta <maccetta@laurelnetworks.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Neil Brown wrote:
> This problem is very hard to solve inside the kernel.
> The partitions will not be visible until the array is opened *after*
> it has been created.  Making the partitions visible before that would
> be possible, but would be very easy.
> 
> I think the best solution is Mike's solution which is to simply
> open/close the array after it has been assembled.  I will make sure
> this is in the next release of mdadm.
> 
> Note that you can still access the partitions even though they do not
> appear in /proc/partitions. Any attempt to access and of them will
> make them all appear in /proc/partitions.  But I understand there is
> sometimes value in seeing them before accessing them.
> 
> NeilBrown

Um. Are you sure?
The reason I noticed is that I couldn't mount them until they appeared; see
these cut'n'pastes from my terminal history:

teak:~# mount /media/
mount: /dev/md_d0p1 is not a valid block device

teak:~# mount /dev/md_d0p1 /media
mount: you must specify the filesystem type

teak:~# xfs_repair -ln /dev/md_d0p2 /dev/md_d0p1
Usage: xfs_repair [-nLvV] [-o subopt[=value]] [-l logdev] [-r rtdev] devname
teak:~# ll /dev/md*
brw-rw---- 1 root disk 254, 0 2007-04-23 15:44 /dev/md_d0
brw-rw---- 1 root disk 254, 1 2007-04-23 14:46 /dev/md_d0p1
brw-rw---- 1 root disk 254, 2 2007-04-23 14:46 /dev/md_d0p2
brw-rw---- 1 root disk 254, 3 2007-04-23 15:44 /dev/md_d0p3
brw-rw---- 1 root disk 254, 4 2007-04-23 15:44 /dev/md_d0p4

/dev/md:
total 0
teak:~# /etc/init.d/mdadm-raid stop
Stopping MD array md_d0...done (stopped).
teak:~# /etc/init.d/mdadm-raid start
Assembling MD array md_d0...done (degraded [4/5]).
Generating udev events for MD arrays...done.
teak:~# cfdisk /dev/md_d0

teak:~# mount /dev/md_d0p1
mount: /dev/md_d0p1 is not a valid block device

and so on...

Notice the cfdisk command above. I did this to check the on-array table (it was
good). I assume cfdisk opens the array - but the partitions were still not there
afterwards. I did not do a 'Write' from in cfdisk this time.

I wouldn't be so concerned at a cosmetic thing in /proc/partitions - the problem
is that I can't mount my array after doing an assemble and I have to --create
each time - not the nicest solution.

Oh, I'm using udev FWIW.

David

