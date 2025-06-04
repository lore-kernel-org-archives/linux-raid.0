Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C1B028EA73;
	Wed,  4 Jun 2025 12:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749040478; cv=none; b=nJESt7x8U/NHDt75K2znyM7yC3rC1EQqPdPRz4lIDCeL1K8VNIVrXbHB15dVO5ZBa5QqDpW2/gk8Aad/YAWSLXuQDwvdyJLSI7+RXmoLF/33HTGUav+o9u09yr4Q8qNPwqelafooKfR6AsAk+gb+OkWQNYjjSxKNp/GYfp86kXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749040478; c=relaxed/simple;
	bh=3rt8h5n8yYtwwyAoB+3rT9wHFljX3vMTDPW/1JK5jIc=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=SV+qHyZL+ywSRZ6DqNFv9bKllwZd2NLPEW26x4B1iESBGSaaZTZoGwDaPdtE7uaZIHyvRxK6Qtl7tB7Po2y5kwyAoe5CtUmhmgsimOulzmFhGqhJIFkrwO3wq59fUXVEqXJkl2wArZjo56vveeH+lbvn3LxRlP0YJN3SHcgvdf0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 6CB071E38B;
	Wed,  4 Jun 2025 08:34:35 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 1EC26A1041; Wed,  4 Jun 2025 08:34:35 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26688.15707.98922.15948@quad.stoffel.home>
Date: Wed, 4 Jun 2025 08:34:35 -0400
From: "John Stoffel" <john@stoffel.org>
To: David Niklas <simd@vfemail.net>
Cc: Linux RAID <linux-raid@vger.kernel.org>,
    linux-kernel@vger.kernel.org
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: Need help increasing raid scan efficiency.
In-Reply-To: <20250602210514.7acd5325@Zen-II-x12.niklas.com>
References: <20250602210514.7acd5325@Zen-II-x12.niklas.com>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "David" == David Niklas <simd@vfemail.net> writes:

> My PC suffered a rather nasty case of HW failure recently where the
> MB would break the CPU and RAM. I ended up with different data on
> different members of my RAID6 array.

Ouch, this is not good.  But you have RAID6, so it should be ok...

> I wanted to scan through the drives and take some checksums of
> various files in an attempt to ascertain which drives took the most
> data corruption damage, to try and find the date that the damage
> started occurring (as it was unclear when exactly this began), and
> to try and rescue some of the data off of the good pairs.

What are you comparing the checksums too?  Just because you assemble
drives 1 and 2 and read the filesystem, then assemble drives 3 and 4
into another array, how do you know which checksum is correct if they
differ?  

> So I setup the array into read-only mode and started the array with
> only two of the drives. Drives 0 and 1. Then I proceeded to try and
> start a second pair, drives 2 and 3, so that I could scan them
> simultaneously.  With the intent of then switching it over to 0 and
> 2 and 1 and 3, then 0 and 3 and 1 and 2.

I'm not sure this is really going to work how you think.... 

> This failed with the error message:
> # mdadm --assemble -o --run /dev/md128 /dev/sdc /dev/sdd
> mdadm: Found some drive for array that is already active: /dev/md127

This is not un-expected.  You already have md127 setup using the same
UUID, and mdadm is doing the right thing to refuse to assemble a
different array name with the same underlying UUID.  

But if you have four drives, you've got four sets of checksums to
calculate for each file, which is going to take time.  And I think
just doing it one pair of disks at a time is the safest way.  Your
data is important to you, obviously, but how much is it worth?  

Can you afford to get some replacement disks, or even just a single
large disk and them dump all your files onto a new single disk to try
and save what you have, even if it's corrupted?  

> Any ideas as to how I can get mdadm to run the array as I requested
> above? I did try --force, but mdadm refused to listen.

And for good reason.  You might be able to do an overlayfs on each
pair, then go in and change the UUID of the second pair to something
different, and then start the array with a new name and disk member
UUIDs.  

But it's alot of hacking for probably not much payout.

Have you found a file with corruption?  If so, have you done a quick
test where you do the four pairs of the array assembled and checked
just that one single file to see if the checksum differs?  

And again, if it does differ, how do you decide what is the correct
data?  

I would strongly suspect that the data is corrupted no matter what.  

In any case, good luck!  Maybe the raid6check tool will help, but I'd
rather try to at least use your most recent backup as a check.  

John
