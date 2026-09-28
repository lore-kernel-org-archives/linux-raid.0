Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 476593CE4B6
	for <linux-raid@vger.kernel.org>; Mon, 28 Sep 2026 20:26:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790627184; cv=none; b=eCImTsXdGzRPShXAzMF3Ot7LeSxHqKbtw0h1xfneLdZfDzLBbkiHcHx32eZBMuLRi7m9jR1kOIpPNahJv3Ij06cB+RBb9sIXrMGTKeIZ8e5O4Bkq+9NY48aqcdggOqJghH0Gcd/IrHjg6N2HYdZlnlxRTjzGLGOmPdy7ecOE+bo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790627184; c=relaxed/simple;
	bh=HlguAyoUIh7DrLY5QXpurDP7omIvHLoA+Mah9XvyRvU=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=NyGTW9KIJmxw4GCs0EGIHomfV62tuyjO+4x3fsAka/WE0L6RPm/uEZqvIrsJgo1zBKVJUNKWzA0IxPFb9mUrBP3HPhpwsk8loU4/SkUEO+kl8idCHF5hhMjtc/p7QCBXFqKFg+nMT4QfbEh/w4SWGxCxrWc+HslTk8MU4uzkXv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f+2CAn+o; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f+2CAn+o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1EC61F000FF;
	Mon, 28 Sep 2026 20:26:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790627182;
	bh=BQXgK8VQZquL2hpGUQiSwP0JOtk/VRGXqzAjrIXJpsU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=f+2CAn+oAJk+OOSuoWQhm049+fXG7b337O9l9yNbqS/tKI3ZGodbY62X0muNJYtbn
	 UW8xcxYJx422ba2wsDm349KZ05jWeaH4tETbBhjX2wTrDeT4B6iO9Ldr9umqJeCQ0+
	 YITO5i1sy5WqT+CGMvpRh+DzaETdnqleqMpZsj4iRZnfHqRbnio3X63W+PjyS6RB4y
	 YFZkg+eyS2QL5/rG9xp/BTfstvAqxqRWtDOXg2V4wCiZb5lYnwqGIqBLv9FwHlO1uP
	 MIIdGAJmfqBsTeeesvj/caCko9lGW2MhNzIvR1BPke/Rn97dCPKc/YwXeBArWY68jo
	 sFWEdaETfze9g==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/2] md: add a control device for array management
Reply-To: sashiko-reviews@lists.linux.dev
To: "Abd-Alrhman Masalkhi" <abd.masalkhi@gmail.com>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260928201224.3602262-3-abd.masalkhi@gmail.com>
References: <20260928201224.3602262-1-abd.masalkhi@gmail.com>
 <20260928201224.3602262-3-abd.masalkhi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Mon, 28 Sep 2026 20:26:22 +0000
Message-Id: <20260928202622.B1EC61F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 9 potential issue(=
s) to consider:
- [High] md: MD_STOP_ARRAY mutual exclusion bypass via control device
- [High] md: md_ctl_exit is marked __init and omitted from md_exit()
- [High] md: self-deadlock in get_mddev_dev and get_mddev_uuid via mddev_put
- [Medium] md: binary UUID lookup fails for UUIDs starting with 0x00
- [Medium] md: missing null-termination enforcement allows stack OOB read
- [Low] md: direct cast from __u64 to user pointer causes warnings
- [Low] md: uninitialized pointer passed to get_raid_version()
- [Low] md: unknown ioctl flags return -ENOTTY instead of -EINVAL
- [Low] md: unprivileged un-ratelimited pr_err allows log flooding
--

commit dd168c18138734c235c0b8b1c097fa7a18b6baa8
Author: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
Subject: md: add a control device for array management

This patch introduces a misc character device, /dev/md-control, to allow
MD management ioctls without holding a block device reference. New 64-bit
safe ioctls are provided that specify the target array by name, UUID, or
device number.

>     The new ioctls use the existing MD_MAJOR ioctl type, starting at 0x40,
>     with an MD_ prefix. Every request structure has a flags field. Unknown
>     flags are rejected with -EINVAL.

[Severity: Low]
The implementation of ctl_flags_valid() below actually returns -ENOTTY for
unknown flags. Should the implementation be updated to match this documented
behavior?

diff --git a/drivers/md/md-ctl.c b/drivers/md/md-ctl.c
new file mode 100644
index 0000000000000..84923b0a2fa3c
--- /dev/null
+++ b/drivers/md/md-ctl.c
@@ -0,0 +1,597 @@
[ ... ]
+static struct mddev *get_mddev_dev(dev_t dev)
+{
+	struct mddev *mddev, *ret =3D NULL;
+
+	if (MINOR(dev) >=3D (1 << MINORBITS))
+		return ERR_PTR(-EINVAL);
+
+	if (MAJOR(dev) !=3D MD_MAJOR)
+		dev &=3D ~((1 << MdpMinorShift) - 1);
+
+	spin_lock(&all_mddevs_lock);
+	list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
+		if (mddev->unit =3D=3D dev) {
+			ret =3D mddev_get(mddev);
+			if (ret && !mddev->gendisk) {
+				mddev_put(mddev);
[Severity: High]
Does calling mddev_put() while holding all_mddevs_lock cause a self-deadloc=
k?

If the reference count was 0 before mddev_get(), mddev_put() will drop it
back to 0 and internally call atomic_dec_and_lock(&mddev->active,
&all_mddevs_lock). Since the current CPU already holds the non-recursive
all_mddevs_lock, this will deadlock the system. This pattern also appears
in get_mddev_uuid().

+				ret =3D ERR_PTR(-EBUSY);
+			}
+			break;
+		}
+	}
+	spin_unlock(&all_mddevs_lock);
+
+	return ret ? ret : ERR_PTR(-ENODEV);
+}
+
+static struct mddev *get_mddev_name(const char *name)
+{
+	unsigned long minor;
+	struct mddev *mddev, *ret =3D NULL;
+
+	if (strncmp(name, "md", 2))
+		return ERR_PTR(-EINVAL);
+
+	if (name[2] !=3D '_' && (!isdigit(name[2]) ||
+			       kstrtoul(&name[2], 10, &minor) ||
[Severity: Medium]
Can this result in an out-of-bounds read on the kernel stack?

The name field is populated via copy_from_user() on the md_ctl structure
without enforcing null-termination. If a user populates the entire 32-byte
name field without a null terminator, kstrtoul() will read past the array
bounds into adjacent stack memory until it finds a non-digit character.

+			       minor > MINORMASK))
+		return ERR_PTR(-EINVAL);
[ ... ]
+static struct mddev *ctl_find_mddev(struct mdu_ioctl *md_ctl)
+{
+	struct mddev *ret =3D ERR_PTR(-EINVAL);
+
+	if (*md_ctl->uuid) {
[Severity: Medium]
Does this correctly evaluate the binary UUID?

Checking *md_ctl->uuid only evaluates the first byte of the 16-byte array.
If an array is created with a randomly generated UUID that happens to start
with 0x00, the UUID lookup will be skipped and fallback to checking the name
or device number instead.

+		if (*md_ctl->name || md_ctl->dev) {
+			pr_err("md: only supply one of name, uuid or dev number\n");
[Severity: Low]
Could this allow an unprivileged user to flood the kernel log buffer?

Since this is triggered directly by user input via ioctl, using an
un-ratelimited pr_err() here instead of pr_err_ratelimited() or pr_debug()
allows dmesg flooding.

+			return ret;
+		}
[ ... ]
+static long md_ctl_ioctl(struct file *filp, uint cmd, ulong u)
+{
+	int err;
+	unsigned int old_cmd;
+	unsigned int noio_flags =3D 0;
+	struct mddev *mddev;
+	void __user *arg;
+	struct mdu_ioctl md_ctl;
+
+	err =3D ctl_ioctl_valid(cmd);
+	if (err)
+		return err;
+
+	if (cmd =3D=3D MD_RAID_VERSION)
+		return get_raid_version(mddev, (struct mdu_version64 __user *)u);
[Severity: Low]
Does this pass an uninitialized mddev pointer to get_raid_version()?

mddev is evaluated and passed in a register before it is initialized by
ctl_find_mddev(), resulting in undefined behavior.

+
+	if (copy_from_user(&md_ctl, (void __user *)u, sizeof(md_ctl)))
+		return -EFAULT;
+
+	err =3D ctl_flags_valid(cmd, md_ctl.flags);
+	if (err)
+		return err;
+
+	mddev =3D ctl_find_mddev(&md_ctl);
+	if (IS_ERR(mddev))
+		return PTR_ERR(mddev);
+
+	old_cmd =3D try_convert_ioctl_cmd(cmd, md_ctl.flags);
+	if (old_cmd) {
+		err =3D md_do_ioctl(mddev->gendisk->part0, 0, old_cmd, md_ctl.arg);
[Severity: High]
Does delegating to md_do_ioctl() bypass the MD_STOP_ARRAY mutual exclusion?

When MD_STOP_ARRAY is called here via the control device, md_do_ioctl() cal=
ls
mddev_set_closing_and_sync_blockdev(mddev, 1), which assumes the caller hol=
ds
the block device open. Because the control ioctl caller doesn't hold the
block device, atomic_read(&mddev->openers) > 1 will evaluate to false if
exactly one other task has the array open, allowing the array to be stopped
while it is actively in use.

+		goto out;
+	}
+
+	arg =3D (void __user *)md_ctl.arg;
[Severity: Low]
Does this direct cast from __u64 to a pointer cause compiler warnings on
32-bit architectures?

It is recommended to use u64_to_user_ptr() to handle the pointer translation
correctly for compat userspace.

+	switch (cmd) {
[ ... ]
+void __init md_ctl_exit(void)
+{
+	misc_deregister(&md_ctl_misc);
+}
[Severity: High]
Is md_ctl_exit() marked __init by mistake?

Additionally, it appears this function is completely omitted from the
module unload path (md_exit() in md.c doesn't call it). This would leak the
misc device when the md module is unloaded, and any subsequent access to
/dev/md-control would cause a use-after-free panic.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260928201224.3602=
262-1-abd.masalkhi@gmail.com?part=3D2
