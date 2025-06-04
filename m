Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B7E1547C9
	for <linux-raid@vger.kernel.org>; Wed,  4 Jun 2025 15:46:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749051973; cv=none; b=U1EDIt1v6nFi7o9z4wJtX5RUxnfnE/QZhqyjAzBu/6DOD04gdtwNrM3faflRuz9q0dNHOjRq25sAfa3l/p1NirzB6Kte8h/CK0e/AXsi03NJuzKFt2L2BPq5Xv0W3bhW7Y3o2TFOHg84QUD3CmpdqsM3IKNxKFXfbEkwABfrEqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749051973; c=relaxed/simple;
	bh=sVv9tfQSi/F3EG4Cu3S8TUx3854kAJcKUGCB7EOgU2Y=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nKsbmx1O3ihHvbA9jKgzrkfSRej9oTToDcwODIDBV45SfWmxuc24TuAT3c2Je408jWmU4c3oOMfv5J02mT4lqPquWvWpwlHKk/fkT4nVycShwrBsh+hy55vtBWZ98TO4SV8g8qYGKIj2a9CYk9fgFFHnfDWZTNlC1jI+CmL7tLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=YQTIedBv; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="YQTIedBv"
Received: (qmail 3607 invoked from network); 4 Jun 2025 15:44:46 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 4 Jun 2025 15:44:46 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:cc:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; s=2018; bh=sVv9tfQSi/F3
	EG4Cu3S8TUx3854kAJcKUGCB7EOgU2Y=; b=YQTIedBvvVd3v4PqdxVwfYexscjs
	TNLX0TEi3+v7YNa42xUXx4PZTy32dD9Grc9ly3rUtmOjAS6KYmD9yRWTdC5iJH9T
	nXRAfZnnAHj3RelylC/s8NjdF7JmlxF5bQz/t2uadJ0jwdpR43/mQ5Ib+echeTrO
	WFllUPe5Zw/PlEQ=
Received: (qmail 52508 invoked from network); 4 Jun 2025 10:46:03 -0500
Received: by simscan 1.4.0 ppid: 52486, pid: 52504, t: 0.6537s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 4 Jun 2025 15:46:02 -0000
Date: Wed, 4 Jun 2025 11:45:58 -0400
From: David Niklas <simd@vfemail.net>
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Need help increasing raid scan efficiency.
Message-ID: <20250604114558.4d27abce@Zen-II-x12.niklas.com>
In-Reply-To: <26688.15707.98922.15948@quad.stoffel.home>
References: <20250602210514.7acd5325@Zen-II-x12.niklas.com>
	<26688.15707.98922.15948@quad.stoffel.home>
X-Mailer: Claws Mail 4.3.0git38 (GTK 3.24.24; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

I'm replying to everyone in the same email.

On Wed, 4 Jun 2025 08:34:35 -0400
"John Stoffel" <john@stoffel.org> wrote:
> >>>>> "David" == David Niklas <simd@vfemail.net> writes:  
> 
> > My PC suffered a rather nasty case of HW failure recently where the
> > MB would break the CPU and RAM. I ended up with different data on
> > different members of my RAID6 array.  
> 
> Ouch, this is not good.  But you have RAID6, so it should be ok...
> 
> > I wanted to scan through the drives and take some checksums of
> > various files in an attempt to ascertain which drives took the most
> > data corruption damage, to try and find the date that the damage
> > started occurring (as it was unclear when exactly this began), and
> > to try and rescue some of the data off of the good pairs.  
> 
> What are you comparing the checksums too?  Just because you assemble
> drives 1 and 2 and read the filesystem, then assemble drives 3 and 4
> into another array, how do you know which checksum is correct if they
> differ?  

Once I find some files whose checksums differ, I can perform some
automated data tests to find which file is the intact one.

> > So I setup the array into read-only mode and started the array with
> > only two of the drives. Drives 0 and 1. Then I proceeded to try and
> > start a second pair, drives 2 and 3, so that I could scan them
> > simultaneously.  With the intent of then switching it over to 0 and
> > 2 and 1 and 3, then 0 and 3 and 1 and 2.  
> 
> I'm not sure this is really going to work how you think.... 
<snip>

I just think that I'll be able to read from all 4 drives but doing it in
2 arrays of 2 drives. Basically, I'll get a 2x speed increase over doing
it as 2 drives at a time.


On Wed, 4 Jun 2025 07:22:15 +0300
Jani Partanen <jiipee@sotapeli.fi> wrote:
> On 03/06/2025 23.04, David Niklas wrote:
> > I think you misunderstood my original question, how do I assemble the
> > RAID6 pairs (RO mode) into two different arrays such that I can read
> > from them simultaneously?  
> 
> I dont think there is any other way to do what you want to do than use
> overlayfs. You may find some ideas from here:
> 
> https://archive.kernel.org/oldwiki/raid.wiki.kernel.org/index.php/Irreversible_mdadm_failure_recovery.html

Thanks for the idea. I'm not following why we setup the overlay but then
use mapper devices (which came from where?), with the mdadm commands.


On Tue, 3 Jun 2025 21:27:35 +0100
anthony <antmbox@youngman.org.uk> wrote:
> On 03/06/2025 21:04, David Niklas wrote:
> > Searching online turned up raid6check.
> > https://unix.stackexchange.com/questions/137384/raid6-scrubbing- 
> > mismatch-repair
> > 
> > But the people there also pointed out that Linux's raid repair
> > operation only recalculates the parity. I would have thought that it
> > did a best of 3 option. I mean, that's a big part of why we have
> > RAID6 instead of RAID5, right?  
> 
>  From what I remember of raid6check, it actually does a proper raid 6
> calculation to recover the damaged data.
> 
<snip>
> I've done it slightly differently, I've got raid-5 sat on top of
> dm-integrity, so if a disk gets corrupted dm-integrity will simply
> return a read failure, and the raid doesn't have to work out what's
> been corrupted. I've got a different problem at the moment - my array
> has assembled itself as three spares, so I've got to fix that ... :-(
> 
> Cheers,
> Wol

Good to know. Thanks Wol. I hope you're able to get your drives up and
running again.


On Wed, 4 Jun 2025 10:59:21 +0200
Reindl Harald <h.reindl@thelounge.net> wrote:
<snip>
> > as I don't have enough room otherwise  
> 
> seriously?
> 
> an external 10 TB disk costs around 200 EUR
> an external 20 TB disk costs around 400 EUR
<snip>

Every time I upgraded the size of my array, I'd take the old disks and
use them as backup disks. Over time, it became a matter of not having
enough SATA ports, not a matter of costing too much. I was trying to
reuse disks instead of the disks being tossed out or collecting dust. I've
learned better now.


Thanks,
David

