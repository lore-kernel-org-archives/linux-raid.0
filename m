From: Paul Clements <paul.clements@us.sios.com>
Subject: [BUG 2.6.32] md/raid1: barrier disabling does not work correctly in
 all cases
Date: Thu, 20 Jan 2011 11:52:32 -0500
Message-ID: <AANLkTikGsB=ZdA-TpjC+npqW-TM9NjwZkWpjWtUEzswn@mail.gmail.com>
References: <AANLkTimp7eGLu5UEr-wH9MVSGrQWA3PKMakW74_48gk7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimp7eGLu5UEr-wH9MVSGrQWA3PKMakW74_48gk7@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I'm having a problem with the 2.6.32 kernel (RHEL 6, actually) and the
barrier disabling code in raid1.

The gist of the problem is that when an fsync is done directly to
/dev/md0 (fsck.ext4 performs an fsync), the kernel
(blkdev_issue_flush, specifically) translates this into a zero-length
write with-barrier-attached. raid1 of course sends this down to its
component devices, which then return EOPNOTSUPP (in my case, a xen
block device, which doesn't support barriers). raid1 then strips the
BIO_RW_BARRIER off and retries the write.

Apparently, a zero-length write (bio) without barrier makes some/all
block drivers very unhappy (IDE, cciss, and xen-blkfront have been
tested and all failed on this). I think these zero-length writes must
normally get filtered out and discarded by filesystem/block layer
before drivers ever see them, but in this particular case, where md is
submitting the write directly to the underlying component driver, it
doesn't get filtered and causes -EIO to be returned (the disk gets
marked failed, the mirror breaks, chaos ensues...)

I can do an obvious hack, which is to assume all the time that
barriers don't work. That is, mark mddev->barriers_work as 0 or just
disable that check:

--- drivers/md/raid1.c.PRISTINE 2011-01-14 14:51:56.959809669 -0500
+++ drivers/md/raid1.c =A02011-01-20 10:17:11.001701186 -0500
@@ -819,6 +833,7 @@ static int make_request(mddev_t *mddev,
=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0finish_wait(&conf->wait_barrier, &w);
=A0=A0 =A0 =A0 =A0}
- =A0 =A0 =A0 =A0if (unlikely(!mddev->barriers_work &&
+ =A0 =A0 =A0 if ((
=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 bio_rw_flagged(bio, BIO_RW_B=
ARRIER))) {
=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0if (rw =3D=3D WRITE)
=A0=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0md_write_end(mddev);

That fixes things, but does Neil or someone else have an idea how best
to fix this?=A0Could we specifically just not retry a zero-length
barrier write? I think that would fix it, but is kind of a hack too.

I know barriers are being pulled out of the kernel, so this isn't a
problem for recent kernels, but as 2.6.32 is a long-term support
kernel, this may be something that others run into and will want
fixed.

Thanks,
Paul
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
