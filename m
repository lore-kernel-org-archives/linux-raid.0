Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F34821CA03
	for <linux-raid@vger.kernel.org>; Thu, 27 Aug 2026 03:07:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787800058; cv=none; b=pIfZFMQFmBw+k0h0x2F+C3tTA6ei29qbwSvXc3MBXiGTkgtecpYnHDlM73dyxuY7HrwTwJGhcHnR+dlPjjSBHm0HPL9tpkh67xjfjBAg/G7AwHlkbmQsfjuRIaCfsLn6r8nAwosq/aD9a6TxmMZ4fs9cTBCKkBYybn4zzw2U9do=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787800058; c=relaxed/simple;
	bh=e9SsGMXDy4wWZTQv4WizJ4443nJhXQL4mMw5ZIiHa4k=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=qn9ppnRTuf4Q0kujcjQ9NUzWSHBeaxJmu9us/Chjsie1NbpugPgxIYC0Vez+5CS57/folOjKwXMp1njrZ6Nhm0Ij9NhrfVvdDZmwTeEBviBswKxCXAp7W/Wg4oiB0QNp5dvy8g+ljSlq4kDyyh1ruWoFgD7sSEz+RWqtaYZzLmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=IGot+Zd7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="IGot+Zd7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF6621F000E9;
	Thu, 27 Aug 2026 03:07:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787800057;
	bh=kcSutco9PQYdy/MOL1NGLwnHvsma5AI02zIqSFect5M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IGot+Zd7AHwXp3MbQAKuFMJxPLOW6lDPyBoMYLT8iicSGJxlJ8IeNcpKqOQNg9oFb
	 QagIzpCwgyrSEdPLPXRm5B/64V4vYOLbVOBkkNvM27yPqOG4e250bkQqwZSXvaH2jp
	 tl9YgrXqoDUlLDL4h8e4kZdxV9DXz2SOx21OcpRpYY/d2e6EWiyPx/sbY+IbIexT/L
	 +sBip3nGcY6K7m7K8JQXqSn/cDPR6bHGyzNE/biWmMttFgrQ8CQQ89bPOyzv7F6hBN
	 6tWQgN2aldURLZt2zV+TiQ7lpS6VyYlKnR2+ihYQHOiq+w1Ncmk7rbyLu1IF9Z98XC
	 4bxckFF2YY8KQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] md-cluster: check pers->resize() return value in
 update_size()
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
In-Reply-To: <20260827025229.40138-1-ghuicao@163.com>
References: <20260827025229.40138-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 03:07:36 +0000
Message-Id: <20260827030736.CF6621F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] Missing superblock update after reverting array size leads to =
cluster-wide metadata inconsistency.
- [High] Cluster capacity change failures are incorrectly masked from users=
pace.
- [High] DLM lock leaked in EX state if down-conversion fails in `__sendmsg=
()`.
--

commit 716b34ca47de8d73645de2da63206339cac7a868
Author: Cao Guanghui <caoguanghui@kylinos.cn>

md-cluster: check pers->resize() return value in update_size()

This commit checks the return value of pers->resize() during an array capac=
ity
revert and logs an error if it fails, ensuring the failure is visible.

> diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
> index 24dac6f09da82..0c6da16aecbfa 100644
> --- a/drivers/md/md-cluster.c
> +++ b/drivers/md/md-cluster.c
> @@ -1349,6 +1349,9 @@ static void update_size(struct mddev *mddev, sector=
_t old_dev_sectors)
>  	} else {
>  		/* revert to previous sectors */
>  		ret =3D mddev->pers->resize(mddev, old_dev_sectors);
> +		if (ret)
> +			pr_err("%s:%d: failed to revert array size\n",
> +			       __func__, __LINE__);

[Severity: High]
This is a pre-existing issue, but since update_size() has a void return typ=
e,
cluster capacity change failures like this are not propagated back to the c=
ore
MD layer.

In drivers/md/md.c:update_size(), the return state of the cluster size
update is ignored:

	if (mddev_is_clustered(mddev))
		mddev->cluster_ops->update_size(mddev, old_dev_sectors);

This allows the function to return success (0) even if the cluster resize
failed and was reverted here. Should we change the signature of update_size=
()
so userspace is accurately informed of the failure?

[Severity: Critical]
This is a pre-existing issue, but is there a missing superblock update befo=
re
sending the METADATA_UPDATED message?

If the resize operation fails and the in-memory size is reverted via
mddev->pers->resize(), the on-disk superblock still retains the new size
written earlier.

Because md_update_sb() is not called before broadcasting METADATA_UPDATED,
other nodes reading the on-disk superblock will adopt the new size while the
initiator runs with the old size. Can this lead to cluster-wide metadata
inconsistency and data corruption?

>  		ret =3D __sendmsg(cinfo, &cmsg);

[Severity: High]
This is a pre-existing issue, but I have a question about the __sendmsg()
error handling.

Looking at __sendmsg(), if the down-conversion of the lock fails:

	/*down-convert EX to CR on Ack*/
	error =3D dlm_lock_sync(cinfo->ack_lockres, DLM_LOCK_CR);
	if (error) {
		pr_err("md-cluster: failed to convert EX to CR on ACK(%d)\n",
				error);
		goto failed_ack;
	}

failed_ack:
	while ((unlock_error =3D dlm_unlock_sync(cinfo->message_lockres)))
		pr_err("md-cluster: failed convert to NL on MESSAGE(%d)\n",
			unlock_error);
	return error;

The cleanup block handles message_lockres but completely ignores ack_lockre=
s.
Does this permanently leak the DLM lock in EX state if the down-conversion
fails, potentially causing a cluster-wide deadlock?

>  		if (ret)
>  			pr_err("%s:%d: failed to send METADATA_UPDATED msg\n",

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827025229.4013=
8-1-ghuicao@163.com?part=3D1
