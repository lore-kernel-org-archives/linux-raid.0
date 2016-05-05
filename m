From: Mike Lovell <mike.lovell@endurance.com>
Subject: problems with lots of arrays
Date: Thu, 5 May 2016 17:24:29 -0600
Message-ID: <CAK9wOaB+Cic3nR5kzB3n=nVpbRtfo8+Qr9j_VNM3hh5tJRw6YA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

we have a number of systems that have a large number of software
arrays running. its in the couple hundred range. we have been using a
custom built kernel based on 3.4 but are wanting to update to a
mainline kernel and have been experimenting with 4.4. the systems are
running recent centos 6 releases but we have been downgrading the
mdadm version from 3.3.2 in 6.7 to a custom build 3.2.6. we installed
the downgraded version due to a problem with array numbering. i
emailed the list a while ago explaining the issue and submitting a
patch to fix [1]. i never heard anything back and since we had a
simple fix i didn't follow up on it.

unfortunately, when testing the 3.2.6 mdadm with linux kernel 4.4
wasn't working. mdadm and the kernel would complain about the devices
not having a valid v1.2 superblock and not start the array. testing
with 3.3.2 from the current centos repos worked. i'd like to update
but we still have the issue with lots of arrays mentioned previously.

i spent some time checking to make sure that my patch rebases against
master properly (and it does) but during testing i was unable to
create an array with number larger than /dev/md511 when using the 4.4
kernel we were testing as well as the 4.2 kernel i had on another test
box. creating one larger than 511 on a system with a 3.16 kernel
worked. it looks like something broke between kernel 3.16 and 4.2 that
limited the number of arrays to 512 (/dev/md0 to /dev/md511). this was
a problem regardless of mdadm version and i haven't yet done much
digging into the problem.

there are a couple things that could potentially be done. the easiest,
would be to just modify find_free_devnm() in mdopen.c from wrapping to
(1<<20)-1 and instead have it wrap around to (1<<9))-1. this would
limit mdadm to 512 auto-generated array numbers. i'm guessing this
would be sufficient for the vast majority of cases and would solve the
problem i'm facing at work. the next option would be to apply the
patch in my previous email and then figuring out why the newer
versions of the kernel don't support more than 512 arrays. this would
take more work but probably the better long term approach.

what do you all think?

thanks
mike

[1] http://marc.info/?l=linux-raid&m=142387809409798&w=2
