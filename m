Received: from mout.web.de (mout.web.de [212.227.15.4])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56D51ACDE3
	for <linux-raid@vger.kernel.org>; Thu, 10 Oct 2024 07:30:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.4
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728545415; cv=none; b=Wh88JfSg1hLpMyr6idrqdA9vPR3K0IFonHhzcv46DEumzo3n7Qb34XjS8SG8V26ZNiLYRqcxU+rmlDf9AnGLQO70W1SYv0kwO66k0/xHGHyazgSX8z9b+SonzZZ6zaz0P4mzXw0eLyDwxe/C4bivGVvS0m5CilNBD3Wss3CFN3A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728545415; c=relaxed/simple;
	bh=AxeEyKwRJrcUEom1fApwb4mBK/BV7liVjstbxZEmd8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=IBJUbu6NZ48tAB3h8nbfRP31l5xTQp/MPGOkJib7a93a+LM17h95jmb+9/iylrFdG88mW3qvfaJvTNWDBqvH5+ibhw28wQC1fSxlMEvqo32yaShvVMtknIont20ixHNQC1uez5RNetgHMvI8Ay6ZviHVTdESkCXVx5U3EDBSjo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b=Twt6WusP; arc=none smtp.client-ip=212.227.15.4
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b="Twt6WusP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1728545400; x=1729150200; i=devzero@web.de;
	bh=AxeEyKwRJrcUEom1fApwb4mBK/BV7liVjstbxZEmd8E=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=Twt6WusPPtHGU9E2qHJAOSQaISF3sPa/fzUBAgSxzagwf0DPz8/DBc9/LujV7cFS
	 52RnuNLxmOKsQXa4u6ZdA1xvkR+V6W+XVQRWApQdQS2ocQSO63BH65a0CXxi41XBe
	 x0wGlmTz+MScQeVXQP8+gaCHdEQX61Yw57SfOwy+pDSQKZfxzJqQyEeO+jTQ4E41P
	 mTweyIPiZA6B+oRKfOHlyRbHz45cLXIqGDAOtPnuK+57hftmChq2rT++tsyniP/BY
	 PbheqQ2vp6Xrkw//ljRkiks2ajdwuqqivylz4nn1S+IVW74zISAVNDjKv9hcFSJGX
	 PcPUv0diuKcBUtCxbw==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.179.103] ([89.0.246.191]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1Myv70-1ttONW0Ehm-00wTct; Thu, 10
 Oct 2024 09:30:00 +0200
Message-ID: <24498365-34bb-4296-a725-2bd80e226bdd@web.de>
Date: Thu, 10 Oct 2024 09:29:59 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: status of bugzilla #99171 - mdraid broken for O_DIRECT
To: Hannes Reinecke <hare@suse.de>, Reindl Harald <h.reindl@thelounge.net>,
 linux-raid@vger.kernel.org
References: <5f25dea4-41f6-4bf2-aeed-deb9d8c76e29@web.de>
 <14d8314d-7c36-4f4d-bdef-b8ad0be37fa5@thelounge.net>
 <ca607ec6-708c-4340-b8b1-05576b92dd88@suse.de>
From: Roland <devzero@web.de>
In-Reply-To: <ca607ec6-708c-4340-b8b1-05576b92dd88@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:ZeUJPnFZEEyeLgLqdx9w1ogL8WQjI+vuYufcMPIzglM4b+HNzkM
 bG9+WKduXD1w2WHWdhni9TLf2GhhebgsiLSRqNcjFMnYz9UxzivWsv+n7Vh01a5OplniiPA
 2rX88H8DNiT9MCWu83K0YlxY1eGCHYFMeKIZsNT18lLXz4fZq7PTCw33W2L+7ANozFlpfyK
 u6nRp3hP9Ow4M+504LJzQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:Aw6Z4UvZhVg=;N5SD+XrGULJjZQbY0UgTtGaZYc8
 xJ+Iq/+seqEksxv6f0xoOXzdx5RZ/6DnjleHMyVT1RKjAFoOjrHS9Ly3RnoC9hfpoPdD41T8T
 IKAPF6wBKIJ+k1pS7xfbfJwzZ7+tTOAQbuhLC87E1iyQVNYBz9G9xP4rCMmahRaCZZIHoE/xl
 xl6ftQz81Gx7hbBL4hSbFvv3bDg888NVORlA0GNxR1g8O9/+pAucLhGzxptGLFxMX9LhIo3Cy
 t4rpqqGc7ui6nOEpkqN6w/u0lWRPCEFLrhWr7fCIKbFOQ8VF9hYM6SxhXu+ddoAXVQPmAk6kW
 i1tR8NQHOXs+IEN816Qq3DaIRQMViBuwGr/9FZcSQbW/ZkpYczBqItiFkqTQVM9OV5exopsiU
 x1ltf4OhkPiHhTEKupHCV5TDRuSDASTw8nMeMM3PqkoXqJxomYDFCRu+mT36ipQd6nDSITt0y
 BxNdFmlrysWRu6ZHddOjZj85RvQ8DDwqQhFHqaSGf/eciSa/nmXIJKF/rfOXXwDlt/n1Tuag0
 B9YhanWKm4Fn1Nw5kjNNh2PSbrJEzzsZqt3KBfr7TBMWLJcryiDuglWJGn69HlXLlGT/pVtj3
 WmkDkwNL8BOs/TPPEe0/t0IKanZWd1f831RY6pOPU6cXQ0MUs5Mnb48R1hb2Te81Rtjo27xuO
 cK+yn9uUQOEbtvvH6mcrytklsLVADUqLUJjGw7/GyR62CN6maDkNf6xCrhdKBEQhtC1uVXNFG
 Mn+V7tREJCrZcOtXAuVWH35VySdThqUxiV2GCQfIbA4urZXQ6w1ni/+W8b6r+pKTj3NgJHzIT
 bX8zKaZvOeFBnwLfCyUd4FOg==

thank you for clearing things up.

 >Which means that the test case is actually invalid; you either would
need drop O_DIRECT or modify the buffer
 >after write() to arrive with a valid example.

ok, but what about running virtual machines in O_DIRECT mode on top of
mdraid then ?

https://forum.proxmox.com/threads/zfs-on-debian-or-mdadm-softraid-stabilit=
y-and-reliability-of-zfs.116871/post-505697

i have not seen any report of broken/inconsistent mdraid caused by
virtual machines, so is this just a "theoretical" issue ?

i'm curious why we can use zfs software raid with virtual machines but
not md software raid. =C2=A0=C2=A0=C2=A0 shouldn't that have the same prob=
lem=C2=A0 (
https://www.phoronix.com/news/OpenZFS-Direct-IO ) , at least from now on ?

regards
Roland


Am 10.10.24 um 08:53 schrieb Hannes Reinecke:
> On 10/9/24 23:38, Reindl Harald wrote:
>>
>> Am 09.10.24 um 22:08 schrieb Roland:
>>> as proxmox hypervisor does not offer mdadm software raid at
>>> installation
>>> time because of this bugticket
>>>
>>> "MD RAID or DRBD can be broken from userspace when using O_DIRECT"
>>> https://bugzilla.kernel.org/show_bug.cgi?id=3D99171
>>>
>>> ps:
>>> also see "qemu cache=3Dnone should not be used with mdadm"
>>> https://bugzilla.proxmox.com/show_bug.cgi?id=3D5235
>> that all sounds like terrible nosense
>>
>> if "Yes. O_DIRECT is really fundamentally broken. There's just no way
>> to fix it sanely. Except by teaching people not to use it, and making
>> the normal paths fast enough" it has to go away
>>
>> it's not acceptable that userspace can break the integrity of the
>> underlying RAID - period
>>
> Take deep breath everyone.
> Nothing has happened, nothing has been broken.
> All systems continue to operate as normal.
>
> If you look closely at the mentioned bug, you'll find that it does
> modify the buffer at random times, in particular while it's being
> written to disk.
> Now, the boilerplate text for O_DIRECT says: the application is in
> control of the data, and the data will be written without any caching.
> Applying that to our testcase it means that the application _can_ modify
> the data, even if it's in the process of being written to disk (zero
> copy and all that).
> We do guarantee that data is consistent once I/O is completed (here:
> once 'write' returns), but we do not (and, in fact, cannot) guarantee
> that data is consistent while write() is running.
>
> Which means that the test case is actually invalid; you either would
> need drop O_DIRECT or modify the buffer after write() to arrive with
> a valid example.
>
> That doesn't mean that I don't agree with the comments about O_DIRECT.
>
> Cheers,
>
> Hannes
