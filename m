Received: from sg-1-21.ptr.blmpb.com (sg-1-21.ptr.blmpb.com [118.26.132.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA473147C9B
	for <linux-raid@vger.kernel.org>; Sun, 23 Nov 2025 02:55:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763866515; cv=none; b=nDd7fPtp6A4af6CCV9oZbt9fViakCxCrxpprfQrMC6gxnwtVH3Yc2NMiT2Zstlo0YXbT7VtCsrQ2zZSCKDUujxV6jNdJ+p5hNwSftnn53XGuVUTkhXmYWVv+APGkb3eSYejP8gx6gfDHDAfl8x/V5YYU0n2qlOG7A4jPVW3VZZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763866515; c=relaxed/simple;
	bh=h092QZgIy+TqS5ul19fdCS2wc20/oseIClXpNN1PCPY=;
	h=To:Date:Mime-Version:References:Content-Type:Cc:From:Message-Id:
	 Subject:In-Reply-To; b=d9dPdgdEl40jieS178gyGKWQMvbUvpYMS1TjEYX2dWor8PNh/XhVGldDtJ8SDXCz3iVLrOKCH8ZIVLDtDOvr0EDxMQDH8xz7BBPvXw4vnM8UyKgROgxx693HohSh9SRXkBv8v7xROxaZBzJrNEl5QNb4N89KK2GGBgfnaYmiiew=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=cuLirK9Z; arc=none smtp.client-ip=118.26.132.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="cuLirK9Z"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1763866499;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=fyD3qCLSbx524wRyXzjHf+bu0WJyW55/ZzPn7Kd5kVc=;
 b=cuLirK9ZR7I1E9okbKsXdTMsxQlXEGA+1AflaffOguBeMKvIBg1lW3XKhIGwLBzSUSFBcA
 7vsZXjR+otSRsKaVJhTe+H174De52bPEyQiW++hAc1qPM4gQhni4TsEy8h7HQqu+SZBRqM
 BTTs5FYvvyLQtVd7y2GkUhAILDvqdXJORgEm6slXyTuVXVvolKLw+RvJJrX19brTlQXYJk
 UKn/myfyeA08pFWbSDS00n3LqvcnA/jCNp9qhse+ORnz0PF+7jnVQKldyyo9wJZCu7IFrQ
 1pdkKa4uJGdPEjxusFENAHDgIpg3Mc2LLTj4gt0Bd1dvMPaCBa1vO1Y2Ag8ueA==
To: "Filippo Giunchedi" <filippo@debian.org>, <linux-raid@vger.kernel.org>, 
	"Yu Kuai" <yukuai@fnnas.com>
Date: Sun, 23 Nov 2025 10:54:55 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <aR3KLd0kR43NeuwT@esaurito.net> <aR33hJMYzJOXUhgp@eldamar.lan> <aR8pDIXtWf+kPfO9@esaurito.net> <aSBGfk4C0gQPca0P@esaurito.net>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Organization: fnnas
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Reply-To: yukuai@fnnas.com
Cc: <1121006@bugs.debian.org>, "Salvatore Bonaccorso" <carnil@debian.org>
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Sun, 23 Nov 2025 10:54:56 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Message-Id: <a89ad1f4-f961-4913-910e-39f2cc6ee925@fnnas.com>
X-Lms-Return-Path: <lba+269227781+a05a43+vger.kernel.org+yukuai@fnnas.com>
Subject: Re: raid10 and component devices optimal_io_size 0xFFF000 results in array optimal_io_size 0xFFF00000
In-Reply-To: <aSBGfk4C0gQPca0P@esaurito.net>
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2025/11/21 19:01, Filippo Giunchedi =E5=86=99=E9=81=93:
> Hello linux-raid,
> I'm seeking assistance with the following bug: recent versions of mpt3sas
> started announcing drive's optimal_io_size of 0xFFF000 and when said driv=
es are
> part of a mdraid raid10 the array's optimal_io_size results in 0xFFF000.
>
> When an LVM PV is created on the array its metadata area by default is al=
igned
> with its optimal_io_size, resulting in an abnormally-large size of ~4GB. =
During
> GRUB's LVM detection an allocation is made based on the metadata area siz=
e
> which results in an unbootable system. This problem shows up only for
> newly-created PVs and thus systems with existing PVs are not affected in =
my
> testing.
>
> I was able to reproduce the problem on qemu using scsi-hd devices as show=
n
> below and on https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1121006.=
 The bug
> is present both on Debian' stable kernel and Linux 6.18, though I haven't=
 yet
> determined when the change was introduced in mpt3sas.
>
> I'm wondering where the problem is in this case and what could be done to=
 fix
> it?

You can take a look at the following thread.

Re: [PATCH 1/2] block: ignore underlying non-stack devices io_opt - Yu Kuai=
 <https://lore.kernel.org/all/a3a98a81-16e9-2f3c-b6e5-c83a0055c784@huaweicl=
oud.com/>

> thank you,
> Filippo
>
> On Thu, Nov 20, 2025 at 02:43:24PM +0000, Filippo Giunchedi wrote:
>> Hello Salvatore,
>> Thank you for the quick reply.
>>
>> On Wed, Nov 19, 2025 at 05:59:48PM +0100, Salvatore Bonaccorso wrote:
>> [...]
>>>>          Capabilities: [348] Vendor Specific Information: ID=3D0001 Re=
v=3D1 Len=3D038 <?>
>>>>          Capabilities: [380] Data Link Feature <?>
>>>>          Kernel driver in use: mpt3sas
>>> This sounds like quite an intersting finding but probably hard to
>>> reproduce without the hardware if it comes to be specific to the
>>> controller type and driver.
>> That's a great point re: reproducibility, and it got me curious on somet=
hing I
>> hadn't thought of testing. Namely if there's another angle to this: does=
 any
>> block device with the same block I/O hints exhibit the same problem? The=
 answer is
>> actually "yes".
>>
>> I used qemu 'scsi-hd' device to set the same values to be able to test l=
ocally.
>> On an already-installed VM I added the following to present four new dev=
ices:
>>
>> -device virtio-scsi-pci,id=3Dscsi0
>>
>> -drive file=3D./workdir/disks/disk3.qcow2,format=3Dqcow2,if=3Dnone,id=3D=
drive3
>> -device scsi-hd,bus=3Dscsi0.0,drive=3Ddrive3,physical_block_size=3D4096,=
logical_block_size=3D512,min_io_size=3D4096,opt_io_size=3D16773120
>>
>> -drive file=3D./workdir/disks/disk4.qcow2,format=3Dqcow2,if=3Dnone,id=3D=
drive4
>> -device scsi-hd,bus=3Dscsi0.0,drive=3Ddrive4,physical_block_size=3D4096,=
logical_block_size=3D512,min_io_size=3D4096,opt_io_size=3D16773120
>>
>> -drive file=3D./workdir/disks/disk5.qcow2,format=3Dqcow2,if=3Dnone,id=3D=
drive5
>> -device scsi-hd,bus=3Dscsi0.0,drive=3Ddrive5,physical_block_size=3D4096,=
logical_block_size=3D512,min_io_size=3D4096,opt_io_size=3D16773120
>>
>> -drive file=3D./workdir/disks/disk6.qcow2,format=3Dqcow2,if=3Dnone,id=3D=
drive6
>> -device scsi-hd,bus=3Dscsi0.0,drive=3Ddrive6,physical_block_size=3D4096,=
logical_block_size=3D512,min_io_size=3D4096,opt_io_size=3D16773120
>>
>> I used 10G files with 'qemu-img create -f qcow2 <file> 10G' though size =
doesn't
>> affect anything in my testing.
>>
>> Then in the VM:
>>
>> # cat /sys/block/sd[cdef]/queue/optimal_io_size
>> 16773120
>> 16773120
>> 16773120
>> 16773120
>> # mdadm --create /dev/md1 --level 10 --bitmap none --raid-devices 4 /dev=
/sdc /dev/sdd /dev/sde /dev/sdf
>> mdadm: Defaulting to version 1.2 metadata
>> mdadm: array /dev/md1 started.
>> # cat /sys/block/md1/queue/optimal_io_size
>> 4293918720
>>
>> I was able to reproduce the problem with src:linux 6.18~rc6-1~exp1 as we=
ll as 6.12.57-1.
>>
>> Since it is easy to test this way I tried with a few different opt_io_si=
ze values and
>> was able to reproduce only with 16773120 (i.e. 0xFFF000).
>>
>>> I would like to ask: Do you have the possibility to make an OS
>>> instalaltion such that you can freely experiment with various kernels
>>> and then under them assemble the arrays? If so that would be great
>>> that you could start bisecting the changes to find where find changes.
>>>
>>> I.e. install the OS independtly on the controller, find by bisecting
>>> Debian versions manually the kernels between bookworm and trixie
>>> (6.1.y -> 6.12.y to narrow down the upsream range).
>> Yes I'm able to perform testing on this host, in fact I worked around th=
e
>> problem for now by disabling LVM's md alignment auto detection and thus =
we have
>> an installed system.
>> For reference that's "devices { data_alignment_detection =3D 0 }" in lvm=
's
>> config.
>>
>>> Then bisect the ustream changes to find the offending commits. Let me
>>> know if you need more specific instructions on the idea.
>> Having pointers on how the recommended way to build Debian kernels would=
 be of
>> great help, thank you!
>>
>>> Additionally it would be interesting to know if the issue persist in
>>> 6.17.8 or even 6.18~rc6-1~exp1 to be able to clearly indicate upstream
>>> that the issue persist in upper kernels.
>>>
>>> Idealy actually this goes asap to upstream once we are more confident
>>> ont the subsystem to where to report the issue. If we are reasonably
>>> confident it it mpt3sas specific already then I would say to go
>>> already to:
>> Given the qemu-based reproducer above, maybe this issue is actually two =
bugs:
>> raid10 as per above, and mpt3sas presenting 0xFFF000 as optimal_io_size.=
 While
>> the latter might be suspicious maybe it is not wrong per-se though?
>>
>> best,
>> Filippo

--=20
Thanks,
Kuai
