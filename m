Received: from mail-108-mta189.mxroute.com (mail-108-mta189.mxroute.com [136.175.108.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D1A4214A6A
	for <linux-raid@vger.kernel.org>; Mon, 28 Jul 2025 06:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753684828; cv=none; b=XbVWS4dpOwfEr6woSLcO8u45nWBCNw3tn/LFHFhdHd7y2LK90KX8+msgdlW2LDBmT6cX3lpAHDnrFes1Q105rkJkoqncHJQkw9OVfezw5rdya0IqeNRjRb5tgyqTJL4MNHCoNigQOelX/pp8G56emKWlTCGcRtNL/1YpRkhqqgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753684828; c=relaxed/simple;
	bh=lD53OpwUBqb9he73feuZqac0CtKyGe7Nx5KvIjbdZTw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=OhddlCddRsnjqtazvnIGOuzC4WcYjaoGj/rpykPOZSz/h7EEgmQn4DWOyxZaaky/V9hO1nexDq0B0gOSnHNhv2++ZFrXXw7vuWRyo2EJg0a+y3Uq6V9QyXAwyNX1TtNK8NEyZLuGfu3hbT8XhsEFBmBI/QY8CotdrxcvZBWGeq4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=X9bBgDuF; arc=none smtp.client-ip=136.175.108.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="X9bBgDuF"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta189.mxroute.com (ZoneMTA) with ESMTPSA id 1984fbe1c670008631.005
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 28 Jul 2025 06:35:15 +0000
X-Zone-Loop: 8dc3c7a68c9daf61ca7b762180467dee92aaeca50d50
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Date:References:In-Reply-To:Subject:Cc:To:
	From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:Content-Description
	:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:
	List-Id:List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:
	List-Archive; bh=BU2lvssTPbewNJdSHWf5G0S49iukGOU1QAnTAb9Pe1M=; b=X9bBgDuF5yUU
	ZXpiNP3cohzqeApUjOhROv4eLUfE79rj4vusVOFSx/vJj7NTGR4asuPnILB9Eu/v+Lfmpi6BLLNvN
	YirLOfqI0tBfWJ6L6COXcjRerJ8KqDtX+cRyzpEZzR7mvcKoakYE9ghLlwIDpOlL/qc1eJvgZFlRZ
	3mS1If7mv0Lc9KmxXeVrGTZmHsBL/rYRzhmnzRwKER0Tc1MddcvNadOlju6RFoYn7nmUjIDgKngBd
	TbmCTOGfmbMZDrwxNm8vU8Q/QxlowczXPCJND+Pqng/vmVqcEkxAOGoGt3ya2nipigI45nMmUAdBU
	N5oLcEEHAUWVxCpAtuIKsA==;
From: Su Yue <l@damenly.org>
To: Heming Zhao <heming.zhao@suse.com>
Cc: song@kernel.org,  yukuai1@huaweicloud.com,  glass.su@suse.com,
  linux-raid@vger.kernel.org
Subject: Re: [PATCH] md/md-cluster: handle REMOVE message earlier
In-Reply-To: <20250728042145.9989-1-heming.zhao@suse.com> (Heming Zhao's
	message of "Mon, 28 Jul 2025 12:21:40 +0800")
References: <20250728042145.9989-1-heming.zhao@suse.com>
User-Agent: mu4e 1.12.7; emacs 30.1
Date: Mon, 28 Jul 2025 14:35:06 +0800
Message-ID: <wm7sj011.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Mon 28 Jul 2025 at 12:21, Heming Zhao <heming.zhao@suse.com> 
wrote:

> Commit a1fd37f97808 ("md: Don't wait for MD_RECOVERY_NEEDED for
> HOT_REMOVE_DISK ioctl") introduced a regression in the 
> md_cluster
> module. (Failed cases 02r1_Manage_re-add & 02r10_Manage_re-add)
>
> Consider a 2-node cluster:
> - node1 set faulty & remove command on a disk.
> - node2 must correctly update the array metadata.
>
> Before a1fd37f97808, on node1, the delay between 
> msg:METADATA_UPDATED
> (triggered by faulty) and msg:REMOVE was sufficient for node2 to
> reload the disk info (written by node1).
> After a1fd37f97808, node1 no longer waits between faulty and 
> remove,
> causing it to send msg:REMOVE while node2 is still reloading 
> disk info.
> This often results in node2 failing to remove the faulty disk.
>
> == how to trigger ==
>
> set up a 2-node cluster (node1 & node2) with disks vdc & vdd.
>
> on node1:
> mdadm -CR /dev/md0 -l1 -b clustered -n2 /dev/vdc /dev/vdd 
> --assume-clean
> ssh node2-ip mdadm -A /dev/md0 /dev/vdc /dev/vdd
> mdadm --manage /dev/md0 --fail /dev/vdc --remove /dev/vdc
>
> check array status on both nodes with "mdadm -D /dev/md0".
> node1 output:
>     Number   Major   Minor   RaidDevice State
>        -       0        0        0      removed
>        1     254       48        1      active sync   /dev/vdd
> node2 output:
>     Number   Major   Minor   RaidDevice State
>        -       0        0        0      removed
>        1     254       48        1      active sync   /dev/vdd
>
>        0     254       32        -      faulty   /dev/vdc
>
> Fixes: a1fd37f97808 ("md: Don't wait for MD_RECOVERY_NEEDED for 
> HOT_REMOVE_DISK ioctl")
> Signed-off-by: Heming Zhao <heming.zhao@suse.com>
> ---
>  drivers/md/md.c | 9 ++++++---
>  1 file changed, 6 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 0f03b21e66e4..de9f9a345ed3 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -9758,8 +9758,8 @@ void md_check_recovery(struct mddev 
> *mddev)
>  			 * remove disk.
>  			 */
>  			rdev_for_each_safe(rdev, tmp, mddev) {
> -				if (test_and_clear_bit(ClusterRemove, 
> &rdev->flags) &&
> -						rdev->raid_disk < 0)
>
ClusterRemove and MD_RECOVERY_NEEDED are set in removed 
rdev->flags on node 2 by process_remove_disk().
After commit a1fd37f97808, node 2 could receive REMOVE in short 
time after receive of
METADATA_UPDATED, MD_RECOVERY_NEEDED will be cleared by 
md_check_recovery() but in that time
rdev->raid_disk could be unchanged. Then MD_RECOVERY_NEEDED will 
be cleared in the end of md_check_recovery()
no more chance to meet the condition.

Reviewed-by: Su Yue <glass.su@suse.com>

> +				if (rdev->raid_disk < 0 &&
> +				    test_and_clear_bit(ClusterRemove, 
> &rdev->flags))
>  					md_kick_rdev_from_array(rdev);
>  			}
>  		}
> @@ -10065,8 +10065,11 @@ static void check_sb_changes(struct 
> mddev *mddev, struct md_rdev *rdev)
>
>  	/* Check for change of roles in the active devices */
>  	rdev_for_each_safe(rdev2, tmp, mddev) {
> -		if (test_bit(Faulty, &rdev2->flags))
> +		if (test_bit(Faulty, &rdev2->flags)) {
> +			if (test_bit(ClusterRemove, &rdev2->flags))
> +				set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
>  			continue;
> +		}
>
>  		/* Check if the roles changed */
>  		role = le16_to_cpu(sb->dev_roles[rdev2->desc_nr]);
