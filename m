From: David Greaves <david@dgreaves.com>
Subject: Re: Partitioned arrays initially missing from /proc/partitions
Date: Tue, 24 Apr 2007 11:49:06 +0100
Message-ID: <462DE0A2.6000701@dgreaves.com>
References: <462CC91B.8030008@dgreaves.com>	<16046.1177356707@mdt.dhcp.pit.laurelnetworks.com> <17965.18112.135843.417561@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------070707020607000404060703"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17965.18112.135843.417561@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------070707020607000404060703
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

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
> appear in /proc/partitions.  Any attempt to access and of them will
> make them all appear in /proc/partitions.  But I understand there is
> sometimes value in seeing them before accessing them.
> 
> NeilBrown

For anyone else who is in this boat and doesn't fancy finding somewhere in mdadm
 to hack, here's a simple program that issues the BLKRRPART ioctl.
This re-reads the block device partition table and 'works for me'.

I think partx -a would do the same job but for some reason partx isn't in
utils-linux for Debian...

Neil, isn't it easy to just do this after an assemble?

David


--------------070707020607000404060703
Content-Type: text/x-csrc;
 name="raid_readparts.c"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="raid_readparts.c"

#include <sys/types.h>
#include <sys/stat.h>
#include <sys/ioctl.h>
#include <stdlib.h>
#include <fcntl.h>
#include <stdio.h>

#include <linux/raid/md_u.h>
#include <linux/major.h>
#include </usr/include/linux/fs.h>

int main(int argc, char *argv[])
{
    int fd;

	if (argc != 2)
       fprintf(stderr, "Usage: %s <md device>\n", argv[0]);

	
    if ((fd = open(argv[1], O_RDONLY)) == -1) {
       fprintf(stderr, "Can't open md device %s\n", argv[1]);
       return -1;
    }

	if (ioctl(fd,  BLKRRPART, NULL) != 0) {
       fprintf(stderr, "ioctl failed\n");
        close (fd);
        return -1;
    }

    close (fd);

    return 0;
}


--------------070707020607000404060703--
