From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Question about mdadm commit d6508f0cfb60edf07b36f1532eae4d9cddf7178b
 "be more careful about add attempts"
Date: Wed, 26 Oct 2011 19:02:37 +0200
Message-ID: <CAGRgLy6Q9Qq8TeykEseXX45goi4kS8wOwrUOo1+tNZyxdyFHkw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings everybody,
I have a question about the following code in Manage.c:Manage_subdevs()

disc.number = mdi.disk.number;
if (ioctl(fd, GET_DISK_INFO, &disc) != 0
    || disc.major != 0 || disc.minor != 0
    || !enough_fd(fd))
    goto skip_re_add;

I do not underatand why the checks: disc.major != 0 || disc.minor != 0
are required. This basically means that the kernel already has an
rdev->desc_nr equal to disc.number. But why fail the re-add procedure?

Let's say that enough_fd() returns true, and we go ahead an issue
ioctl(ADD_NEW_DISK). In this case, according to the kernel code in
add_new_disk(), it will not even look at info->number. It will
initialize rdev->desc_nr to -1, and will allocate a free desc_nr for
the rdev later.

Doing this with mdadm 3.1.4, where this check is not present, actually
succeeds. I understand that this code was added for cases when
enough_fd() returns false, which sounds perfectly fine to protect
from.

I was thinking that this code should actually check something like:
if (ioctl(fd, GET_DISK_INFO, &disc) != 0
    || disk.raid_disk != mdi.disk.raid_disk
    || !enough_fd(fd))
    goto skip_re_add;

That is to check that the slot that was being occupied by the drive we
are trying to add, is already occupied by a different drive (need also
to cover cases of raid_disk <0, raid_disk >= raid_disks etc...) and
not the desc_nr, which does not have any persistent meaning.

Perhaps there are some compatibility issues with old kernels? Or
special considerations for ... containers? non-persistent arrays?

Thanks!
Alex.
