Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 087C5C77B76
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 16:06:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229753AbjBXQGA (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:06:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBXQF7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 11:05:59 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50BB3BDB6
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 08:05:57 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7F3B060A26;
        Fri, 24 Feb 2023 16:05:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677254756; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xko4fT7dRi7Du+KnnY9jTt30noZ94De5S4mWL87qPes=;
        b=UDHsl4tty8NDAfUHw//yS0YBAZUNXVqtYbwlMaA6/vDfUFcixRCoHCVsBfFBrV2J7z1Xeq
        qN+qqNJCOs8K+gM+xzHXVKnjC/g6U/t3aS1R+Xn+MMGNvSbd5qwRWyYlnqF7dlPSIlnA2i
        z0m3hBA8gpFZGNbc5KsWRUwcRZVVLHM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677254756;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Xko4fT7dRi7Du+KnnY9jTt30noZ94De5S4mWL87qPes=;
        b=oJc2juJ5UoNe6tdltXj/hREsqjn5IoKKw4b47z4bqPjgn0ouUWzg0ecJO88xtICfOpEqZH
        WYGQoezNE8cVCSCw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E37E713A3A;
        Fri, 24 Feb 2023 16:05:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id kKSvKmHg+GPhJAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 24 Feb 2023 16:05:53 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH mdadm v6 5/7] mdadm: Add --write-zeros option for Create
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221123190954.95391-6-logang@deltatee.com>
Date:   Sat, 25 Feb 2023 00:05:43 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <5E73C9FA-C85F-4960-AD36-8134870894F0@suse.de>
References: <20221123190954.95391-1-logang@deltatee.com>
 <20221123190954.95391-6-logang@deltatee.com>
To:     Logan Gunthorpe <logang@deltatee.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 23, 2022 at 12:09:52PM -0700, Logan Gunthorpe wrote:
> Add the --write-zeros option for Create which will send a write zeros
> request to all the disks before assembling the array. After zeroing
> the array, the disks will be in a known clean state and the initial
> sync may be skipped.
>=20
> Writing zeroes is best used when there is a hardware offload method
> to zero the data. But even still, zeroing can take several minutes on
> a large device. Because of this, all disks are zeroed in parallel =
using
> their own forked process and a message is printed to the user. The =
main
> process will proceed only after all the zeroing processes have =
completed
> successfully.
>=20
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>

Overall this patch is fine to me, except for the GNU C lib specific =
'%m'.

I would suggest to continue use the existed strerror(errno) to print out
the error string.

Thanks.

Coly Li

> ---
> Create.c | 175 ++++++++++++++++++++++++++++++++++++++++++++++++++++++-
> ReadMe.c |   2 +
> mdadm.c  |   9 +++
> mdadm.h  |   5 ++
> 4 files changed, 189 insertions(+), 2 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index 4acda30c5256..a6bf1ccd296b 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -26,6 +26,10 @@
> #include	"md_u.h"
> #include	"md_p.h"
> #include	<ctype.h>
> +#include	<fcntl.h>
> +#include	<signal.h>
> +#include	<sys/signalfd.h>
> +#include	<sys/wait.h>
>=20
> static int round_size_and_verify(unsigned long long *size, int chunk)
> {
> @@ -91,9 +95,148 @@ int default_layout(struct supertype *st, int =
level, int verbose)
> 	return layout;
> }
>=20
> +static pid_t write_zeroes_fork(int fd, struct shape *s, struct =
supertype *st,
> +			       struct mddev_dev *dv)
> +
> +{
> +	const unsigned long long req_size =3D 1 << 30;
> +	unsigned long long offset_bytes, size_bytes, sz;
> +	sigset_t sigset;
> +	int ret =3D 0;
> +	pid_t pid;
> +
> +	size_bytes =3D KIB_TO_BYTES(s->size);
> +
> +	/*
> +	 * If size_bytes is zero, this is a zoned raid array where
> +	 * each disk is of a different size and uses its full
> +	 * disk. Thus zero the entire disk.
> +	 */
> +	if (!size_bytes && !get_dev_size(fd, dv->devname, &size_bytes))
> +		return -1;
> +
> +	if (dv->data_offset !=3D INVALID_SECTORS)
> +		offset_bytes =3D SEC_TO_BYTES(dv->data_offset);
> +	else
> +		offset_bytes =3D SEC_TO_BYTES(st->data_offset);
> +
> +	pr_info("zeroing data from %lld to %lld on: %s\n",
> +		offset_bytes, size_bytes, dv->devname);
> +
> +	pid =3D fork();
> +	if (pid < 0) {
> +		pr_err("Could not fork to zero disks: %m\n");
> +		return pid;
> +	} else if (pid !=3D 0) {
> +		return pid;
> +	}
> +
> +	sigemptyset(&sigset);
> +	sigaddset(&sigset, SIGINT);
> +	sigprocmask(SIG_UNBLOCK, &sigset, NULL);
> +
> +	while (size_bytes) {
> +		/*
> +		 * Split requests to the kernel into 1GB chunks seeing =
the
> +		 * fallocate() call is not interruptible and blocking a
> +		 * ctrl-c for several minutes is not desirable.
> +		 *
> +		 * 1GB is chosen as a compromise: the user may still =
have
> +		 * to wait several seconds if they ctrl-c on devices =
that
> +		 * zero slowly, but will reduce the number of requests
> +		 * required and thus the overhead on devices that =
perform
> +		 * better.
> +		 */
> +		sz =3D size_bytes;
> +		if (sz >=3D req_size)
> +			sz =3D req_size;
> +
> +		if (fallocate(fd, FALLOC_FL_ZERO_RANGE | =
FALLOC_FL_KEEP_SIZE,
> +			      offset_bytes, sz)) {
> +			pr_err("zeroing %s failed: %m\n", dv->devname);
> +			ret =3D 1;
> +			break;
> +		}
> +
> +		offset_bytes +=3D sz;
> +		size_bytes -=3D sz;
> +	}
> +
> +	exit(ret);
> +}
> +
> +static int wait_for_zero_forks(int *zero_pids, int count)
> +{
> +	int wstatus, ret =3D 0, i, sfd, wait_count =3D 0;
> +	struct signalfd_siginfo fdsi;
> +	bool interrupted =3D false;
> +	sigset_t sigset;
> +	ssize_t s;
> +
> +	for (i =3D 0; i < count; i++)
> +		if (zero_pids[i])
> +			wait_count++;
> +	if (!wait_count)
> +		return 0;
> +
> +	sigemptyset(&sigset);
> +	sigaddset(&sigset, SIGINT);
> +	sigaddset(&sigset, SIGCHLD);
> +	sigprocmask(SIG_BLOCK, &sigset, NULL);
> +
> +	sfd =3D signalfd(-1, &sigset, 0);
> +	if (sfd < 0) {
> +		pr_err("Unable to create signalfd: %m");
> +		return 1;
> +	}
> +
> +	while (1) {
> +		s =3D read(sfd, &fdsi, sizeof(fdsi));
> +		if (s !=3D sizeof(fdsi)) {
> +			pr_err("Invalid signalfd read: %m");
> +			close(sfd);
> +			return 1;
> +		}
> +
> +		if (fdsi.ssi_signo =3D=3D SIGINT) {
> +			printf("\n");
> +			pr_info("Interrupting zeroing processes, please =
wait...\n");
> +			interrupted =3D true;
> +		} else if (fdsi.ssi_signo =3D=3D SIGCHLD) {
> +			if (!--wait_count)
> +				break;
> +		}
> +	}
> +
> +	close(sfd);
> +
> +	for (i =3D 0; i < count; i++) {
> +		if (!zero_pids[i])
> +			continue;
> +
> +		waitpid(zero_pids[i], &wstatus, 0);
> +		zero_pids[i] =3D 0;
> +		if (!WIFEXITED(wstatus) || WEXITSTATUS(wstatus))
> +			ret =3D 1;
> +	}
> +
> +	if (interrupted) {
> +		pr_err("zeroing interrupted!\n");
> +		return 1;
> +	}
> +
> +	if (ret)
> +		pr_err("zeroing failed!\n");
> +	else
> +		pr_info("zeroing finished\n");
> +
> +	return ret;
> +}
> +
> static int add_disk_to_super(int mdfd, struct shape *s, struct context =
*c,
> 		struct supertype *st, struct mddev_dev *dv,
> -		struct mdinfo *info, int have_container, int major_num)
> +		struct mdinfo *info, int have_container, int major_num,
> +		int *zero_pid)
> {
> 	dev_t rdev;
> 	int fd;
> @@ -148,6 +291,14 @@ static int add_disk_to_super(int mdfd, struct =
shape *s, struct context *c,
> 	}
> 	st->ss->getinfo_super(st, info, NULL);
>=20
> +	if (fd >=3D 0 && s->write_zeroes) {
> +		*zero_pid =3D write_zeroes_fork(fd, s, st, dv);
> +		if (*zero_pid <=3D 0) {
> +			ioctl(mdfd, STOP_ARRAY, NULL);
> +			return 1;
> +		}
> +	}
> +
> 	if (have_container && c->verbose > 0)
> 		pr_err("Using %s for device %d\n",
> 		       map_dev(info->disk.major, info->disk.minor, 0),
> @@ -224,10 +375,23 @@ static int add_disks(int mdfd, struct mdinfo =
*info, struct shape *s,
> {
> 	struct mddev_dev *moved_disk =3D NULL;
> 	int pass, raid_disk_num, dnum;
> +	int zero_pids[total_slots];
> 	struct mddev_dev *dv;
> 	struct mdinfo *infos;
> +	sigset_t sigset, orig_sigset;
> 	int ret =3D 0;
>=20
> +	/*
> +	 * Block SIGINT so the main thread will always wait for the
> +	 * zeroing processes when being interrupted. Otherwise the
> +	 * zeroing processes will finish their work in the background
> +	 * keeping the disk busy.
> +	 */
> +	sigemptyset(&sigset);
> +	sigaddset(&sigset, SIGINT);
> +	sigprocmask(SIG_BLOCK, &sigset, &orig_sigset);
> +	memset(zero_pids, 0, sizeof(zero_pids));
> +
> 	infos =3D xmalloc(sizeof(*infos) * total_slots);
> 	enable_fds(total_slots);
> 	for (pass =3D 1; pass <=3D 2; pass++) {
> @@ -261,7 +425,7 @@ static int add_disks(int mdfd, struct mdinfo =
*info, struct shape *s,
>=20
> 				ret =3D add_disk_to_super(mdfd, s, c, =
st, dv,
> 						&infos[dnum], =
have_container,
> -						major_num);
> +						major_num, =
&zero_pids[dnum]);
> 				if (ret)
> 					goto out;
>=20
> @@ -287,6 +451,10 @@ static int add_disks(int mdfd, struct mdinfo =
*info, struct shape *s,
> 		}
>=20
> 		if (pass =3D=3D 1) {
> +			ret =3D wait_for_zero_forks(zero_pids, =
total_slots);
> +			if (ret)
> +				goto out;
> +
> 			ret =3D update_metadata(mdfd, s, st, map, info,
> 					      chosen_name);
> 			if (ret)
> @@ -295,7 +463,10 @@ static int add_disks(int mdfd, struct mdinfo =
*info, struct shape *s,
> 	}
>=20
> out:
> +	if (ret)
> +		wait_for_zero_forks(zero_pids, total_slots);
> 	free(infos);
> +	sigprocmask(SIG_SETMASK, &orig_sigset, NULL);
> 	return ret;
> }
>=20
> diff --git a/ReadMe.c b/ReadMe.c
> index 50a5e36d05fc..9424bfc3eeca 100644
> --- a/ReadMe.c
> +++ b/ReadMe.c
> @@ -138,6 +138,7 @@ struct option long_options[] =3D {
>     {"size",	  1, 0, 'z'},
>     {"auto",	  1, 0, Auto}, /* also for --assemble */
>     {"assume-clean",0,0, AssumeClean },
> +    {"write-zeroes",0,0, WriteZeroes },
>     {"metadata",  1, 0, 'e'}, /* superblock format */
>     {"bitmap",	  1, 0, Bitmap},
>     {"bitmap-chunk", 1, 0, BitmapChunk},
> @@ -390,6 +391,7 @@ char Help_create[] =3D
> "  --write-journal=3D      : Specify journal device for RAID-4/5/6 =
array\n"
> "  --consistency-policy=3D : Specify the policy that determines how =
the array\n"
> "                     -k : maintains consistency in case of unexpected =
shutdown.\n"
> +"  --write-zeroes        : Write zeroes to the disks before creating. =
This will bypass initial sync.\n"
> "\n"
> ;
>=20
> diff --git a/mdadm.c b/mdadm.c
> index 972adb524dfb..141838bd394f 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -602,6 +602,10 @@ int main(int argc, char *argv[])
> 			s.assume_clean =3D 1;
> 			continue;
>=20
> +		case O(CREATE, WriteZeroes):
> +			s.write_zeroes =3D 1;
> +			continue;
> +
> 		case O(GROW,'n'):
> 		case O(CREATE,'n'):
> 		case O(BUILD,'n'): /* number of raid disks */
> @@ -1306,6 +1310,11 @@ int main(int argc, char *argv[])
> 		}
> 	}
>=20
> +	if (s.write_zeroes && !s.assume_clean) {
> +		pr_info("Disk zeroing requested, setting --assume-clean =
to skip resync\n");
> +		s.assume_clean =3D 1;
> +	}
> +
> 	if (!mode && devs_found) {
> 		mode =3D MISC;
> 		devmode =3D 'Q';
> diff --git a/mdadm.h b/mdadm.h
> index 18c24915e94c..82e920fb523a 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -273,6 +273,9 @@ static inline void __put_unaligned32(__u32 val, =
void *p)
>=20
> #define ARRAY_SIZE(x) (sizeof(x)/sizeof(x[0]))
>=20
> +#define KIB_TO_BYTES(x)	((x) << 10)
> +#define SEC_TO_BYTES(x)	((x) << 9)
> +
> extern const char Name[];
>=20
> struct md_bb_entry {
> @@ -433,6 +436,7 @@ extern char Version[], Usage[], Help[], =
OptionHelp[],
>  */
> enum special_options {
> 	AssumeClean =3D 300,
> +	WriteZeroes,
> 	BitmapChunk,
> 	WriteBehind,
> 	ReAdd,
> @@ -593,6 +597,7 @@ struct shape {
> 	int	bitmap_chunk;
> 	char	*bitmap_file;
> 	int	assume_clean;
> +	bool	write_zeroes;
> 	int	write_behind;
> 	unsigned long long size;
> 	unsigned long long data_offset;
> --=20
> 2.30.2
>=20

