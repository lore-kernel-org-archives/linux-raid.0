Received: from smtp161.vfemail.net (smtp161.vfemail.net [146.59.185.161])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0CD14A23
	for <linux-raid@vger.kernel.org>; Tue,  3 Jun 2025 20:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=146.59.185.161
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748981087; cv=none; b=hTf09A1WvjBngToD6xT6TGYTIYYSiXECQjlou6v0hOQgLcKGR2pNLrvUQHHM3W/PTV1GD52ISbOJJoAGHD73Uz35hBx3huZ4gYHp9T9wTgW8mgP4bMu+DO8jn0cFfOyEP/SzSQ0KbjrUf0II535ovHxiZfryV0Ur+TYVktUqZFk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748981087; c=relaxed/simple;
	bh=JYj1vNTn15og/+5O5aPag3/4oCOhC1CSroGuCvxIsKI=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mNsq+nrtiTt2ExV8M5Yvp9GQy2iW4ZDdddzBFs1Yr8mK7H3OJ3f81kwfQ+5qmHQEVt36NkwYWnZCWF6PP34uemsFifaZ38IwJ3ViRyv14HQwHbnQ2u/ZaoGJdTYO+rd2KCdHXQSS8HEskH/ZQfQebTcpa9IpsbTgKOggkCOYx+o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net; spf=pass smtp.mailfrom=vfemail.net; dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b=on3tHABe; arc=none smtp.client-ip=146.59.185.161
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=vfemail.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=vfemail.net
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=vfemail.net header.i=@vfemail.net header.b="on3tHABe"
Received: (qmail 10198 invoked from network); 3 Jun 2025 20:03:26 +0000
Received: from localhost (HELO nl101-3.vfemail.net) ()
  by smtpout.vfemail.net with SMTP; 3 Jun 2025 20:03:26 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=simple; d=vfemail.net; h=date:from
	:to:cc:subject:message-id:in-reply-to:references:mime-version
	:content-type:content-transfer-encoding; s=2018; bh=JYj1vNTn15og
	/+5O5aPag3/4oCOhC1CSroGuCvxIsKI=; b=on3tHABexCSlgcrXYMYanqqtQPib
	Hb9iFFqBFDDNS6e0W47drU4hICW9uq332nXgJYdvKOKyfeXms5Lwf5h9RG5S3tnr
	xP35/kd1Aaxzo/BHPfZD1VzCD10bgTG1BE0YsyCVGizN9c1wEzTmDxPc4t+VN2fh
	5uCAsDse6RRhGZg=
Received: (qmail 31100 invoked from network); 3 Jun 2025 15:04:43 -0500
Received: by simscan 1.4.0 ppid: 30998, pid: 31085, t: 0.3395s
         scanners:none
Received: from unknown (HELO bmwxMDEudmZlbWFpbC5uZXQ=) (aGdudGt3aXNAdmZlbWFpbC5uZXQ=@MTkyLjE2OC4xLjE5Mg==)
  by nl101.vfemail.net with ESMTPA; 3 Jun 2025 20:04:43 -0000
Date: Tue, 3 Jun 2025 16:04:40 -0400
From: David Niklas <simd@vfemail.net>
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Need help increasing raid scan efficiency.
Message-ID: <20250603160415.61c9ca7c@Zen-II-x12.niklas.com>
In-Reply-To: <24815d81-2e4f-4ddf-b194-b03ea3232b91@youngman.org.uk>
References: <20250602210514.7acd5325@Zen-II-x12.niklas.com>
	<24815d81-2e4f-4ddf-b194-b03ea3232b91@youngman.org.uk>
X-Mailer: Claws Mail 4.3.0git38 (GTK 3.24.24; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Message-ID: <20250603200440.H9NzN4tlI-91FzsXaXnLrZ3IJQrIa35hE8Ax3NfI3t4@z>

On Tue, 3 Jun 2025 17:46:01 +0100
Wol <antlists@youngman.org.uk> wrote:
> On 03/06/2025 02:05, David Niklas wrote:
> > So I setup the array into read-only mode and started the array with
> > only two of the drives. Drives 0 and 1. Then I proceeded to try and
> > start a second pair, drives 2 and 3, so that I could scan them
> > simultaneously. With the intent of then switching it over to 0 and 2
> > and 1 and 3, then 0 and 3 and 1 and 2.  
> 
> BACKUP! BACKUP!! BACKUP!!!

It's when I was trying to make my yearly backup that I found out it was
corrupting. I have HDDs I backup to. When I backup, I erase the
previous year (as I don't have enough room otherwise), then backup the new
year. As a system, it worked up until now.

> Is your array that messed up that it won't assemble? If you can just
> get it to assemble normally that's your best bet by far. Trying to
> assemble it as two pairs is throwing away the whole point of a raid 6!

It assembles fine with all the disks, the problem is the data corruption
that has occurred across the members.

> And make sure you know the order of the drives in the array! I hope you
> haven't lost that infof.

Everything is written down on paper.

> If your event counts are all similar, then you'll hopefully recover
> most of your data. Your biggest worry will be the mobo and ram having
> trashing an in-flight write that corrupts the disk.

Yes, that's my problem. I wanted to try and isolate the disk pairs so
that I could try and figure out if there is any pattern or differing
copies that would allow me to restore the corrupted data.

> Then once you've got the array assembled, I can't remember the command,
> but there is a command that will read the entire stripe, check the
> paritIES - both of them, and recreate the data. If that fails, your
> data is probably toast, and nothing you can do will be able to retrieve
> much :-(
> 
> Cheers,
> Wol
> 

Searching online turned up raid6check.
https://unix.stackexchange.com/questions/137384/raid6-scrubbing-mismatch-repair

But the people there also pointed out that Linux's raid repair operation
only recalculates the parity. I would have thought that it did a best of
3 option. I mean, that's a big part of why we have RAID6 instead of RAID5,
right?

I think you misunderstood my original question, how do I assemble the
RAID6 pairs (RO mode) into two different arrays such that I can read from
them simultaneously?

If I have to do some coding with respect to the mdadm utility, I'm
willing. But for all I know, the Linux Kernel might destroy all of my data
if I try something like that.

Thanks,
David
