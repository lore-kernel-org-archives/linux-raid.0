Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A88F275B03
	for <linux-raid@vger.kernel.org>; Wed, 15 Jul 2026 16:34:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784133254; cv=none; b=Fhf0Yu6S0smNUtkCRVKPv0kZsvKXSgeWSBYxoexqTPDog+QwJfXsjVeU8bMLn//F/vrl8w50Lm8G+w/58Y6nXuOH8xacnERiI+8cjr44INVVI3s6nwnVCC/Y/P67LoeZp+jQzUYHljaPOjmsIT8YpcrLF88i/CIjJ+LpXtT8eic=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784133254; c=relaxed/simple;
	bh=FLIHkPu4js4uyzzAfkOqS3dr19NxiAonjfDC/btzdvo=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=tv/SxRF5/wBBt09BmZDlYhQO16X+4/JK6PQXCbvUfU4miS3gCEEt2bUkZqWLlzT5HTvSKwJ8Oyd2QXUzzVJHLwW1CFtCGX+LKgaHavfy840NHJrRwOtiQzAf0HDloLcsjLv5uoPU0ki6iHc0Sx7bp+DI41CMb2969U2l4ohfuk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b=RLpzeOkO; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b="RLpzeOkO"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stoffel.org;
 i=@stoffel.org; q=dns/txt; s=20250308; t=1784132871; h=mime-version :
 content-type : content-transfer-encoding : message-id : date : from :
 to : cc : subject : in-reply-to : references : from;
 bh=FLIHkPu4js4uyzzAfkOqS3dr19NxiAonjfDC/btzdvo=;
 b=RLpzeOkO2dv/0SdRX17n730Otp8iGUg9TWgGDRYmUrixhDc3LCeybhPNZOKFJFi+e6+af
 W5ezVIcT5172W4ErwxvsDdbAxB8j5ON2RrQn+5zQ3bUID0czvAasJp7U/iOg2Fxf+gm3kS3
 mjF5kCERIHNkHQT//zLn3Le0NNwJg6TPzDKOqPJtyDF6uebTbRP0kLna6i+IEQGnkcESS3O
 +hjkxOWqBV5s3f0U5xPu/BfUod4DV2PPocdTgThk2ZNktCSay7dqc0J0z6ARSPQUSHdhlaB
 HHW4jHkLpAel25vOGdI+xZZ99+Ly4G7zE+cAdHLIhIfkCQhP9hkJMlCnJpIg==
Received: from quad.stoffel.org (unknown [24.177.6.168])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 09D821E2FB;
	Wed, 15 Jul 2026 12:27:51 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 8BC8AA30E9; Wed, 15 Jul 2026 12:27:50 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Message-ID: <27223.46342.543928.404779@quad.stoffel.home>
Date: Wed, 15 Jul 2026 12:27:50 -0400
From: "John Stoffel" <john@stoffel.org>
To: "G.W. Kant - Hunenet B.V." <g.w.kant@hunenet.nl>
Cc: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>,
    "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
    "yukuai@fygo.io" <yukuai@fygo.io>
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: Subject: RFC: Read repair for md RAID1 after mirror read failures
In-Reply-To: <cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl>
References: <8dcbfa43-c687-49bb-81b5-e6b8e8848c77@hunenet.nl>
	<m2y0fcesbe.fsf@gmail.com>
	<cff97a09-ee38-4785-9a45-1fd562fbaf5e@hunenet.nl>
X-Mailer: VM 8.3.2 under 28.2 (x86_64-pc-linux-gnu)

>>>>> "G" =3D=3D "G W Kant <- Hunenet B.V." <g.w.kant@hunenet.nl>> writes:

> Hi Abd,
> On 7/15/26 7:27 AM, Abd-Alrhman Masalkhi wrote:
>>> With today's 18=E2=80=9324 TB HDDs and backup/archive workloads, where data may
>>> remain unchanged for years, latent media degradation seems increasingly
>>> relevant. A successful read from the alternate mirror may be one of the
>>> last opportunities to refresh such a sector before it becomes
>>> permanently unreadable.
>>>=20
>> And Check/Repair is the right defense for cold archival data on large
>> drives.


> I have been looking into your suggestion that periodic check/repair is=20
> the appropriate defense for cold archival data on large drives.

> Before I start reading the resync code, I would like to make sure I=20
> understand what repair actually does.

> Suppose all mirrors read successfully and contain identical data. In=20
> other words, there are no read errors and no mismatches.

> Does repair simply verify the data and move on, or does it also rewrite=20
> each successfully read block to the corresponding LBA on every mirror?

> The distinction is important for what I have in mind.

So you have to also think of other situations.  You have a RAID1
array, and one block gets corrupted, but is still readable.  How do
you tell which block is the proper one?  You need checksums or parity
or more copies to check against for consistency.=20=20

It's not a simple problem.   For long term archiving, I would try to
use something with RAID6 or more, and ideally have a filesystem which
also checksums data.  This is what ZFS does, and which bcachefs does
as well, but since they're both out of kernel, I don't use either with
my current home linux setup.=20=20

But for long term storage, that could be the way to go.  but then you
need to periodically scrub your data, which means reading it all,
checking the checksums and re-writing and fixing corruption.=20=20

> My concern is not recovery from an existing read error=E2=80=94that is already=20
> handled by fix_read_error()=E2=80=94but rather the long-term aging of cold=20
> magnetic recordings.

You really need three or more disks with multiple parity and checksums
for long term storage.=20=20


> If a sector is still readable today but is approaching the point where=20
> the drive's ECC will eventually no longer be able to reconstruct it,=20
> then a successful rewrite would effectively establish a new "write time"=20
> for that sector. If the drive can no longer reliably store the data at=20
> that location, the rewrite would also give the firmware an opportunity=20
> to remap the sector.

> So my question is essentially:

> Does repair perform such a rewrite of successfully read blocks, or does=20
> it only rewrite blocks when a read error or mismatch has already been=20
> detected?

> Regards,

> Dion
