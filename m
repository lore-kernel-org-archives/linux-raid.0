From: Janek Kozicki <janek_listy@wp.pl>
Subject: Re: deleting mdadm array?
Date: Thu, 25 Oct 2007 15:36:06 +0200
Message-ID: <20071025153606.0741b477@absurd>
References: <20071025100619.3b3810be@absurd>
	<47206820.4020005@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <47206820.4020005@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

David Greaves said:     (by the date of Thu, 25 Oct 2007 10:55:44 +0100)

> How much later? This will, of course, destroy any data on the array (!) and
> you'll need to mkfs again...

Just after, I didn't even create LVM volume on it (not mentioning
formatting it).

> Also, if you don't mind me asking: why did you choose version 1.1 for the
> metadata/superblock version?

In "time to deprecate old RAID formats" Doug Ledford said, that 1.1
is safest when used with LVM. I wish that this info would get into
the man page. I just hope that grub will be able to boot from LVM 
from '/' partition raid1 (version 1.1), I didn't check this yet.


Doug Ledford said:     (by the date of Fri, 19 Oct 2007 12:15:34 -0400)

> 1.0, 1.1, and 1.2 are the same format, just in different positions on
> the disk.  Of the three, the 1.1 format is the safest to use since it
> won't allow you to accidentally have some sort of metadata between the
> beginning of the disk and the raid superblock (such as an lvm2
> superblock), and hence whenever the raid array isn't up, you won't be
> able to accidentally mount the lvm2 volumes, filesystem, etc.  (In worse
> case situations, I've seen lvm2 find a superblock on one RAID1 array
> member when the RAID1 array was down, the system came up, you used the
> system, the two copies of the raid array were made drastically
> inconsistent, then at the next reboot, the situation that prevented the
> RAID1 from starting was resolved, and it never know it failed to start
> last time, and the two inconsistent members we put back into a clean
> array).  So, deprecating any of these is not really helpful.  And you
> need to keep the old 0.90 format around for back compatibility with
> thousands of existing raid arrays.
> 


-- 
Janek Kozicki                                                         |
