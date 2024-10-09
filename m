Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E22311E04BF
	for <linux-raid@vger.kernel.org>; Wed,  9 Oct 2024 20:08:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728504532; cv=none; b=XJDW5d2vi4wcwg0NXdUtsTVSAcCH00XI50Ay4MB/p/MSCSRr0HwwJh6xyO4wqtIZyx2wy72C3PHdVKgkpz5FCl6iL2YNxcpDYEVXG/oxaIljjIs2kaIVccVtD62KzJO60mgS1SD2WqMc9YS5kaPCTJxumr4u6muC6SyIK3b/xzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728504532; c=relaxed/simple;
	bh=CkGSKTe3M1zwDW5zTLqbpjm0fLHxh615nhm2jgNlmKk=;
	h=Message-ID:Date:MIME-Version:From:To:Subject:Content-Type; b=B8Dfl/5vY106IQo6/RVa+KT8W0/IL7UirKtIq5nq8Pwa0fE4HV85tLFSPYYiXgx3KflY/Imdyx/XfVgX4uzZA4lU1UVLPG+F/J0sxt3GFe/6pP35DJU0NE25KBh0IdPUVh8HkuXhrwz/x5E4UPxH9a5nrWZbsaSlwnZFEYrh2uQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b=cUcA/m/I; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=devzero@web.de header.b="cUcA/m/I"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1728504521; x=1729109321; i=devzero@web.de;
	bh=CkGSKTe3M1zwDW5zTLqbpjm0fLHxh615nhm2jgNlmKk=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:From:To:Subject:
	 Content-Type:Content-Transfer-Encoding:cc:
	 content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=cUcA/m/IKz5B3KpVgdRVT68smQ7QO8e0foircVtYwxT7UZXv+DFX2eIRZXSDQN+Z
	 1uAJz+NVtXP4HJ3j/0yw3uQ0qfDvHTNa53C1SxZG0mgHSCmKmrvzJCdMGrCvW5LAi
	 EXal9/XhhmwUqGrHKTGqHga3eT6otAx4/2tdw8LtYOKxYHmPjdj6JJ2LoRXN+Vzmd
	 dNS+ECTuovNKgNGt1qC2fl69LHYFJdSTIj8WU2rj2FqJcfg/SBYpSwOleeNCRxHCV
	 WCEXn4kveL8t0VhVEibWJ3mIulo4Lmk6/nQtFZhvqxCu29j+DPcNFwaPf0SnOWKTK
	 q8PvCxDWqKHtBK33Og==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [172.20.35.191] ([37.24.118.138]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MActo-1t9bLl1cN6-00Fh5d for
 <linux-raid@vger.kernel.org>; Wed, 09 Oct 2024 22:08:41 +0200
Message-ID: <5f25dea4-41f6-4bf2-aeed-deb9d8c76e29@web.de>
Date: Wed, 9 Oct 2024 22:08:41 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Roland <devzero@web.de>
To: linux-raid@vger.kernel.org
Subject: status of bugzilla #99171 - mdraid broken for O_DIRECT
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:+3W2qm/5qjvbkQ2tbvvg/QPa0nlvGgOM4ombFlot39kuf0AXbYQ
 T4EAB2TeBititufkFJ7B1bYZ+OyJDv3xsfTV5/NA+LEyyxabDLeQhLgtXvaRFWxAVm/Eif/
 rfIl+s/5J3IpHziY89z1YuqmLJhXJC979P9Sgta8qnq3WkIQV1k0ydcOZfU1tgpFfgeo+zd
 pKNgYLlhshDGQMVxhG7CQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:W4QOoyDV6s0=;PWQtTicdV1lO3Mz3EhHoUOqP59R
 RX9wyGAv+AgxVc0tCLFv8njYBdhNJ4rDiDs1CzVez8Mf8LN7JgQUFA10Uzn5S3Wb88O3Ok+6F
 cXjaa7HqH5XG4gMBIsfl8bBG4tXVIzZbPNb68UiEmzp+Y8/lgbEVojJ+IsnyAmtkd8JGOXHoS
 iD9mJIHdW3Ma/tyZQnwXfWBUzfjC+tBuK0YwXcyOhQEKieDi9yOwpU2AQOHuweCsJTnMNg3ka
 LAnbDcnh8bQ9lINDSFwwmfQOlh1Qf3k4r7n1bm8OlHNQ+VCkLIEQ8UPHQn7WXOVyomqg5iFMO
 X4JOQDFgX4Wx4l6+cR9HcB64isH6p7AXRd6zDGL171N5OPomT3UVbW2Sy24PDZzGNGB3mqtlX
 AhHcfjORzw8cX0NsU3SdeYGcZXZIUJe08BsCPCyi73ZBlYsRpSpNt0DNr1Ac0RQ2jQB77kEdV
 qmrKfruQR3hb/T8EU7/0+CK+tqpI5k9CtKZf2i0aHUicM8OOfkLunDeUgeEqMHqJbeMJFJLHu
 /bpklh+1eiezG8ousXJnxxWKyli4KLa/bv8J41A4Wk3KYbctfXL1omZNkX2PK2QhzYDhGwK2v
 C8RQOmeB2xxI/kIlci6vmpOpd0zOwhRdy1h26hnK1eKJpvbowf97GFt+ZTSKgbnmI8lRu6TR7
 +XKGoqCexf9l99ZcjEeu5TlOtcpVpti3xqWrkbl/N8VsA5HbcIjEh1CiE/0JMAa3YbALldU1F
 k5hqAoXYBzWbANkaAnMUCvtHPiXP9v3tDTqDJzZnlGOjcOWWgR6hQL8SCQ+ErrZuwAHuvtCJd
 1YXRLUemJAQB6mQPIrzHe40Q==

Hello,

as proxmox hypervisor does not offer mdadm software raid at installation
time because of this bugticket

"MD RAID or DRBD can be broken from userspace when using O_DIRECT"
https://bugzilla.kernel.org/show_bug.cgi?id=3D99171

i tried to find some more references besides the kernel bugzilla entry -
and=C2=A0 - besides some discussion in the proxmox community - i did not s=
ucceed.

why is this apparent fundamental design flaw (should we call it that?)
so damn unknown ?

and what about O_DIRECT with other software raid solutions like btrfs or
zfs ?

how/why do they right but not mdraid ?=C2=A0 the latter exists for much
longer time and afaik is offered as install-time option for RHEL
(enterprise linux) for example, where people use oracle on top - which
IS using O_DIRECT very often/likely.

not accusing anyone - just being curious why totally unknown/unpopular
bugticket #99171 bitrots for nearly a decade now...

regards
Roland

Sysadmin

ps:
also see "qemu cache=3Dnone should not be used with mdadm"
https://bugzilla.proxmox.com/show_bug.cgi?id=3D5235

