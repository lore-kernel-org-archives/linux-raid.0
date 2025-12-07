Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B485C1A5B8A
	for <linux-raid@vger.kernel.org>; Sun,  7 Dec 2025 20:49:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765140573; cv=none; b=ivMYZPFOOY2nc8/0/9Zha42eIWpUwUrRyKoc/jvOOYKGyRt/Ks8I3a2ATqn7aQGZOgoT0OHMrzOhyTPOtQujjWhTQKyychK1UFcP24mfLjlSdJCasu65PhgCEJ43psL5JyIqCyy8rQLkdkFq1Q+9GBst5G6XlkVay19fy+tnCGM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765140573; c=relaxed/simple;
	bh=tznXi0UjENx8rJx8fdj2yBLo4uq6FhMUzOX7EdgoPWY=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=Y/aUjBtwi1MSML7i7mYiuxgCsayxYlFkXKmbKEN5dORUED2Tc5iAIjl4zBumdruRhnyBiYhuPSZ9ZMMtJqiRKvNhOM/fV38rbTl3YrZ3cCxHwcJqsK7uq1WFM6AcenrpJ0L/mGJnNpJ+qDFOwJBUYDzD5ebo7NwKXVWo/zWsklc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b=IKaORuNP; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b="IKaORuNP"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stoffel.org;
 i=@stoffel.org; q=dns/txt; s=20250308; t=1765140084; h=mime-version :
 content-type : content-transfer-encoding : message-id : date : from :
 to : cc : subject : in-reply-to : references : from;
 bh=tznXi0UjENx8rJx8fdj2yBLo4uq6FhMUzOX7EdgoPWY=;
 b=IKaORuNPAloEYyPofNq7XWpSFRlTVOwoYe5K3oxtqcuGGBtshWeoiL9DG5Dl0OSMD4C0z
 Dr+FrzkiOm99orpWReyHxkhNSIhe5yw5P9ogjLvlozcGLS6M4o0J2qQgipFLnFsdY8RnFyM
 epNxary5D+cR40tADHrUZKyz6c/Wi+CXWXt8Efn4/PXOcl+kT0qgDrgN4zO1JhePqul1+LL
 1EpZfDoS6NVrHAJrAfXhtFwDq+L2FnK7qbSap9hb6fA1DOWBZOgGfLYaOMO/QvVR8oZK8VG
 xf5qaP6WfZHEZ21bIRIW+xf5KGh3S2wwv+1ZkLMaGKfPCGgYtcaJ8kN0ugzw==
Received: from quad.stoffel.org (unknown [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id E8B561E602;
	Sun,  7 Dec 2025 15:41:23 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id CE7D1A251E; Sun,  7 Dec 2025 15:41:22 -0500 (EST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26933.58994.820569.229198@quad.stoffel.home>
Date: Sun, 7 Dec 2025 15:41:22 -0500
From: "John Stoffel" <john@stoffel.org>
To: Christian Focke-Kiss <christian.focke-kiss@mail.fernfh.ac.at>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
    "yukuai3@huawei.com" <yukuai3@huawei.com>,
    "song@kernel.org" <song@kernel.org>
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: Possible issue with software RAID 1 in case of disks with different
 speed
In-Reply-To: <ac13d188ba7e2d5b0e2a8943d720f1903003d548.camel@mail.fernfh.ac.at>
References: <ac13d188ba7e2d5b0e2a8943d720f1903003d548.camel@mail.fernfh.ac.at>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Christian" == Christian Focke-Kiss <christian.focke-kiss@mail.fernfh.ac.at> writes:

> I am using Debian stable for years (currently, release 13; before, 12,
> 11, 10, etc. starting with 3.0, if my long-time backups are complete).

Same here, though with different backup tools

> For some years now, I am using software RAID with two RAID 1 sets with
> three 8TB disks each, one for my production data (/home, /var/lib,
> /var/www, etc.) and the second one for a nightly backup of my
> production data (three disks each because HDDs failed quite frequently
> then, and recovery was slow).

I like this, three way mirrors are cheap insurance. 

> Initially, I used external disks connected mainly via USB 3.x, and also
> via USB 2.0, when I ran out of USB ports. Reason for USB was that I
> couldn't/wouldn't afford a server with slots for accomodating six 3.5"
> HDDs.

There's the problem, USB connections are notoriously crappy.  It would
be better to go with eSATA or some other more reliable transport.  

> After migrating the failed 3.5" HDDs to 2.5" SSDs one-by-one over
> the years, I finally migrated five disks into a rack-mount server
> and connected the sixth disk via USB 3.x (I couldn't migrate all six
> disks because one slot was still occupied by the boot disk).

> I run nightly rsync jobs ('managed' by Back In Time) to backup
> everything from /dev/md0 (boot) to /dev/md1 (production) and then to
> /dev/md2 (backup).

> Now, as long as the sixth disk was still connected via USB 3.x, the
> rsync job and a kworker job were 'blocked' after some hours of
> rsync- ing, and the console displayed some 'sync' errors, and I had
> to press Ctrl+Alt+Del to reboot the system because login didn't work
> anymore.

What did you see in the logs?  I.e. did you kick off the logs and then
maybe send the logs to another system (if possible) or to the console
which you could then switch the display to, so you might have a chance
of looking at things?  

> I flagged the USB 3.x disk 'write-mostly' and 'nofailfast' but this
> didn't resolve the issue.

I suspect your external USB enclosure is crap.  I've never found a
good one in my experience.  It's too prone to losing connectivity, or
having a crappy controller chip which just doesn't handle long term
writes well, etc. 

> Only after I added two NVMe SSDs as boot disks and migrated the
> sixth SSD into the sixth slot, everything runs fine.

It's the USB connection, not the disk or RAID.  

> Conclusion:
> I suspect software RAID 1 has issues if one disk of a three disk RAID 1
> set is significantly slower than the other two disks.

Logs?  Warnings?  

Glad to hear it's up, but in the future, just use eSATA or regular
SATA in your case.  I've got some old big cases with 8 drive bays for
3.5" disks and it works great.  I've thought about server case with
2.5" disks that could be hot-swapped, but in reality for a home
system, I don't need it up five 9s, I can handle downtime.  

But thanks for the anecdote!
John
