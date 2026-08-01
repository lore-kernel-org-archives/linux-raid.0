Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2673009D6
	for <linux-raid@vger.kernel.org>; Sat,  1 Aug 2026 17:55:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785606943; cv=none; b=sp+mRUk3tBp80+3UCo3+ESZ/Opdb6N3Z79zSDUuZG0Y1wRJEGNGCtHpgBusV1uw1yx6WofovKEtIlzeJdlkQ+FQ4RBn4lRIBd80CO2sX+fAPZE46PpVRlABUNbHuJREGZySudKCPe3gYz+i5nxewKSG2/9VtO2ArVNmRbK4hUhw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785606943; c=relaxed/simple;
	bh=vUECSWJWvIgLbldiv5unaVNNOWFG1fwl848xubxnkB4=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=mHRvOnBpxYRBHEZ9ypA6V/EtPOrNKrCop1ytQvbnwaRgYA8pFKRtAGzVPRZqLo7zsnRbsydzVz+gIX5N/5WqPp5GrS19xgpPERjo4X/7BK+8Ehie9y9wHZGYMatZ/UqErWhKtLlMJnCufKxFhwFABJbnswx3cBTM10lh5vzM/7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X3qjVYMQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X3qjVYMQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DCED1F00AC4;
	Sat,  1 Aug 2026 17:55:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785606942;
	bh=8AC9fGf7LSv64NZkwAHL0uLUlc4UxzQsfLxzR4OogA4=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=X3qjVYMQmWsAYRGiwR2zsmnQBseS2UtHcWAoCI9qI1f9Juq9BLEjPvc/d9tvzocjR
	 shR2xWpp9iQQhRK9ku7+JXRq1P/eRxKw1wWH03AvReCNmDW3HBIa6Tzs6i7SHg1xRb
	 1wz2M8LHVeUMIN1bwC8onu8P3zbPFuKMQoTQYbyRMe87AfSPeMJQTNlYb5Jeaezgqa
	 IKckHwwtGAWbYzeunR61jOS2b9bMGHsn/V2FhMKAulpvt2ZOnbn8cZztmKiFPZDOkS
	 upAUd6SBmjyYAqaVcs7WNgyXfZD2mJ0zmBAKeNbuM6uA0++pbp2EFdUuqC3rmZVNq5
	 T/2QcTtGKWumg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 18/25] md/md-llbitmap: clamp state-machine walks to
 tracked bits
Reply-To: sashiko-reviews@lists.linux.dev
To: "Yu Kuai" <yukuai@kernel.org>
Cc: yukuai@fygo.io, linux-raid@vger.kernel.org
In-Reply-To: <20260801172519.2982121-19-yukuai@kernel.org>
References: <20260801172519.2982121-1-yukuai@kernel.org>
 <20260801172519.2982121-19-yukuai@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 01 Aug 2026 17:55:41 +0000
Message-Id: <20260801175542.2DCED1F00AC4@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [Critical] TOCTOU race in llbitmap_state_machine() allows chunk state to =
be blindly overwritten by concurrent actions, leading to data corruption.
--

--- Patch [18]: [PATCH v4 18/25] md/md-llbitmap: clamp state-machine walks =
to tracked bits ---
commit 5929c29d9f90d552df02364e1245faa32b6df618
Author: Yu Kuai <yukuai@fygo.io>

md/md-llbitmap: clamp state-machine walks to tracked bits

This commit addresses an issue where llbitmap_state_machine() can be called
with an end bit beyond the tracked chunks. It clamps the start and end valu=
es
to ensure the state machine does not walk past the tracked bitmap boundarie=
s.

> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
> --- a/drivers/md/md-llbitmap.c
> +++ b/drivers/md/md-llbitmap.c
> @@ -1012,7 +1012,10 @@ static enum llbitmap_state llbitmap_state_machine(=
struct llbitmap *llbitmap,
>  		llbitmap_init_state(llbitmap);
>  		return BitNone;
>  	}
> -
> +	if (start >=3D llbitmap->chunks)
> +		return BitNone;
> +	if (end >=3D llbitmap->chunks)
> +		end =3D llbitmap->chunks - 1;
>  	while (start <=3D end) {
>  		enum llbitmap_state c =3D llbitmap_read(llbitmap, start);

[Severity: Critical]
This is a pre-existing issue, but does this lockless read-modify-write cycle
allow concurrent updates to overwrite each other?

When llbitmap_state_machine() calculates the new state and eventually calls
llbitmap_write(), it blindly overwrites the state without an atomic cmpxchg
loop or per-chunk locking.

Could this cause data corruption during concurrent execution? For example, =
if
llbitmap_start_sync() is running lockless with BitmapActionClearUnwritten
across all chunks, and llbitmap_start_write() concurrently processes the sa=
me
chunk with BitmapActionStartwrite:

Thread 1 (Sync):
    c =3D llbitmap_read(llbitmap, start);
    // c is BitCleanUnwritten
    state =3D state_machine[c][BitmapActionClearUnwritten];
    // state becomes BitUnwritten

Thread 2 (Write):
    c =3D llbitmap_read(llbitmap, start);
    // c is BitCleanUnwritten
    state =3D state_machine[c][BitmapActionStartwrite];
    // state becomes BitNeedSync
    llbitmap_write(llbitmap, state, start);

Thread 1 (Sync):
    llbitmap_write(llbitmap, state, start);
    // blindly overwrites the written chunk with BitUnwritten

This would leave the actively written chunk marked as BitUnwritten, causing
llbitmap_skip_sync_blocks() to skip syncing this chunk and leaving stale
parity on the recovering drive.

>

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260801172519.2982=
121-1-yukuai@kernel.org?part=3D18
