From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [linux-lvm] Q: Online resizing ext3 FS
Date: Wed, 12 Sep 2007 16:56:50 +0200
Message-ID: <46E7FE32.7010404@wpkg.org>
References: <20070912163621.1f951876@slopi>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070912163621.1f951876@slopi>
Sender: linux-raid-owner@vger.kernel.org
To: LVM general discussion and development <linux-lvm@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Chris Osicki schrieb:
> Hi
> 
> I apologize in advance for asking a question not really appropriate
> for this mailing list, but I couldn't find a better place with lots of
> people managing lots of disk space. 
> 
> The question:
> Has anyone of you been using ext2online to resize (large) ext3 filesystems?
> I have to do it going from 500GB to 1TB on a productive system I was
> wondering if you have some horror/success stories.
> I'm using RHEL4/U4 (kernel 2.6.9) on this system.

Yes, I tried to online resize a similar filesystem (600 MB to 1.2 TB) 
and it didn't work.

At some point, resize2fs would just exit with errors.
I tried to do it several times before I figured out what's missing; 
sometimes, I interrupted the process with ctrl+c. No data loss occurred.

To do an online ext3 resize, the filesystem needs a "resize_inode" 
feature. You can check the features with dumpe2fs:

# dumpe2fs -h /dev/sda1
(...)
Filesystem features:      has_journal resize_inode dir_index filetype 
needs_recovery sparse_super large_file
(...)

This flag is added by default only in the recent versions of e2progs 
(1.39 and later AFAIR); before, it had to be specified manually. So with 
RHEL4, you may be out of luck.


In the end, I had to to an offline resize.


I had this volume mirrored on another machine, so I didn't worry that 
much though.


Also, to resize a filesystem of that size you would need plenty of RAM 
(if you have about 1 GB RAM free, it should be just enough; otherwise, 
your machine will be swapping, and the process will take longer).
Before, I tried to resize it on a machine with 256 MB and several 
snapshots; resize2fs was killed because of OOM, and still, no data loss.


If you have that an old kernel, take care if you're using snapshots; I 
believe they are stable only as of 2.6.22 (before 2.6.22 snapshots 
needed a lot of RAM; before 2.6.18 there were problems with snapshots 
removing etc.).


Would be good to add some of that info to LVM HOWTO.


-- 
Tomasz Chmielewski
http://wpkg.org
