Received: from smtp.hosts.co.uk (smtp.hosts.co.uk [85.233.160.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BDC114E2F2
	for <linux-raid@vger.kernel.org>; Fri,  5 Sep 2025 02:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=85.233.160.19
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757039111; cv=none; b=sM8ESdFtdpCRr1pGTjynTANUIca2+nk2yW8BbrEJSpxyi6f83cC2x3+87HWzrQ/epq/gTBdktjZDRnZ69EBq1tYgmNqpUACnPtiMKn6R3TN15xi8EOGRSqpgBiF8JeRO7uK+8r4jmKBpo4sKQo1rSLyHCT3zwJ90oQorV+VJY3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757039111; c=relaxed/simple;
	bh=h7cqn6QgBM8XevWmHTjr6gdlac2YNtbQ0Lj/5gOIJAI=;
	h=Message-ID:Date:MIME-Version:Subject:References:To:From:
	 In-Reply-To:Content-Type; b=MZsG4EMSs5g+C8PLmT4vggf8Ne2goc+8IA8+FxEQVHGx0esN7hG8Eab0Nzz6vhENVN42t5ruZGlUCi1U0l2HPAgE71KWDvpAlsYZ3GyWVsiwqh3r/s3oPa9Wf6lKZ9PmioMRfb4DzHvqZkFuTotsKeMCjPa6E5P5dfr5Z59zFx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk; spf=fail smtp.mailfrom=youngman.org.uk; arc=none smtp.client-ip=85.233.160.19
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=youngman.org.uk
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=youngman.org.uk
Received: from host51-14-94-149.range51-14.btcentralplus.com ([51.14.94.149] helo=[192.168.1.65])
	by smtp.hosts.co.uk with esmtpa (Exim)
	(envelope-from <antlists@youngman.org.uk>)
	id 1uuIrG-00000000462-61LA;
	Thu, 04 Sep 2025 23:55:11 +0100
Message-ID: <d8fdc2a3-ef96-4e18-a0de-f962f6dfca57@youngman.org.uk>
Date: Thu, 4 Sep 2025 23:55:10 +0100
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: What is the best way to set up RAID-1 on new Ubuntu install
References: <109aahg$34jlp$1@dymaxion.cjsa2.com>
 <37f99719-4bb1-489c-8246-e6dffc8b0bf9@youngman.org.uk>
 <109b62i$e2l$1@dymaxion.cjsa2.com>
Content-Language: en-GB
To: Jeffery Small <jeff@cjsa.com>, Linux RAID <linux-raid@vger.kernel.org>
From: Wol <antlists@youngman.org.uk>
In-Reply-To: <109b62i$e2l$1@dymaxion.cjsa2.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 04/09/2025 05:54, Jeffery Small wrote:
> Wol, thanks for the reply.  What is a 0.9 layout?  I've never heard of
> that before. 

0.9 is an old layout. You'll notice that when raid details are posted it 
normally says "raid 1.2 format", which is the layout. All the raid 1.x 
formats have identical superblock format, the difference between the 
1.0, 1.1 and 1.2 formats is simply the location of the superblock. And 
it's always somewhere at the start of the partition.

0.9 is the old-style format. And it's placed at the end of the 
partition. So if the raid gets trashed somehow, because the filesystem 
starts at the start of the partition you can mount it directly if you 
have to.

> I'm confused about why to not mirror the boot partition.
> Other articles I've read on the subject suggest doing this.  What is the
> problem?
> 
I'm just thinking that if you do have boot trouble, this makes it easier 
to access your boot partition (which should be effectively read only 
almost all time), and might make recovering your system easier.

> Now maybe we are having a communication problem mixing up the initial
> UEFI partition (mounted at /boot/efi) which does get set up on each SSD
> independently and is definitely NOT mirrored, and the actual boot partition
> (mounted as /boot) which is where GRUB and kernel are installed.  If I
> made one big mirrored / partition, /boot could just be included along with
> everything else.
> 
Possibly. I've not got to grips with UEFI - I learnt most of my boot-fu 
back in the days of lilo :-)

> As I say, I'm just trying to avoid future problem from something that I
> didn't anticipate from the start.
> 
Cheers,
Wol
