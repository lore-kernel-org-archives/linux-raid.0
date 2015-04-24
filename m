From: Charles Bertsch <cbertsch@cox.net>
Subject: Re: PROBLEM: write to jbod with 3TB and 160GB drives hits BUG/oops
Date: Fri, 24 Apr 2015 13:11:06 -0700
Message-ID: <553AA35A.5050300@cox.net>
References: <55398462.1000202@cox.net> <KdvS1q00X1hjKLY01dvTMG>
Reply-To: bertschc@acm.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <KdvS1q00X1hjKLY01dvTMG>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, "BertschC@acm.org" <BertschC@acm.org>
List-Id: linux-raid.ids

On 04/23/2015 06:55 PM, NeilBrown wrote:
>
> By "jbod" I assume you mean "linear array".
>
> You say this happens without any filesystem on the array, yet the stack
> traces clearly show ext2 in use.
> Maybe some weird interaction is happening between the the filesystem and the
> linear array.
> But please confirm that the stack trace happened when there was no filesystem
> on the array you were testing, and report what filesystems you do have which
> use ext2.
>
Neil --
Yes, I do mean linear array.

At the point of the stack trace, there was no file-system on the linear 
2-drive array.  The test-jbod-2 script would create the array and then 
write directly to /dev/md0.  Any evidence of previous existence of a 
file-system would have been obliterated by earlier runs copying 
/dev/zero everywhere.

The file-systems in use --
-- The rootfs is an initrd file, squashfs, and mounted read-only.
-- An ext3 for configuration and logs is mounted RW on /flash
-- An ext2 using 8MB of RAM is mounted RW on /var
-- The file-server is derived from a much earlier design that required 
some RW directories within the root.  These entries appear in the mount 
command as ext2, but are part of /var (and not separate file systems) --
-- mount --bind /var/hd /hd
-- mount --bind /var/home /home

-- A devtmpfs mounted on /dev, tmpfs on /dev/shm, proc on /proc, sysfs 
on /sys, and another mount --bind from within /flash for nfs.

# mount
/dev/root on / type squashfs (ro,relatime)
devtmpfs on /dev type devtmpfs 
(rw,relatime,size=1002600k,nr_inodes=250650,mode=755)
proc on /proc type proc (rw,relatime)
sysfs on /sys type sysfs (rw,relatime)
/dev/ram1 on /var type ext2 (rw,relatime,errors=continue)
/dev/ram1 on /hd type ext2 (rw,relatime,errors=continue)
/dev/ram1 on /home type ext2 (rw,relatime,errors=continue)
tmpfs on /dev/shm type tmpfs (rw,relatime)
/dev/sdb1 on /flash type ext3 
(rw,noatime,errors=continue,commit=60,barrier=1,data=ordered)
/dev/sdb1 on /var/lib/nfs type ext3 
(rw,noatime,errors=continue,commit=60,barrier=1,data=ordered)
nfsd on /proc/fs/nfsd type nfsd (rw,relatime)
#

 > Is there any chance you could use "git bisect" to find out exactly which
 > commit introduced the problem?  That is the mostly likely path to a 
solution.
 >


I am not familiar with "git bisect".  Would this be similar to 
downloading a series of kernel releases from linux-3.3.5 up to 3.18.5 
using a binary search to find which release (rather than which commit) 
has the problem ?

Thanks

Charles Bertsch

