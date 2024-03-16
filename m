Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F33E61BC31
	for <linux-raid@vger.kernel.org>; Sat, 16 Mar 2024 18:26:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710613590; cv=none; b=Egxc0ROlahpHFwhkLxEJ0NJBh6O5SmfLgQ3Jq/8xzyiZfhnYXuK0Ug3y05nOKqupYsKP6YLvoAOobFSQupWu9NVQKzo7uH2tubgCB/+eUv88mbcRv6AKBJVoALkpxeBYMBzzVlYHfycU1XSpTgiHxHS8ZiILtb1oJVuhUGEFt6A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710613590; c=relaxed/simple;
	bh=1WTi1ZgQuKA0dWy9eWpe/41d7lUJkXw6gUL8PrXtANI=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=SqeCYUtYtMrOOIaFvJxdOuZL7pSfN2BgLcxSyrEGrYjw8xbKpK8Qu6VBKAaFDILtILOVwyEY4lMqV5LuRnV5kIGLrcKkRujPSYQ5pGGjTOdnMzqq4pUN4OTqbdiTQSVJ2WzytrqsFDYAisVguCiqnf3alINny5mFvx2GS8rMyTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=a2YVwAWx; arc=none smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="a2YVwAWx"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-568a42133d8so3156591a12.1
        for <linux-raid@vger.kernel.org>; Sat, 16 Mar 2024 11:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710613587; x=1711218387; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=or8uieS26G/ESlrGned3+g3CrJ2Qms+80gVSzUSHLI8=;
        b=a2YVwAWxQt5AWjiX158Igv4GGasHA99bS+xh0KIHc8EcwzqDtf4cLLE9wHiYyeLCIH
         vnfnvjOjpcZGU+3l95snr78ZXcXIIsF2BIUcnH11YE5Jg1I7tPDF4O7aXPDluBq01uzt
         5bNqN8Q+QkdRaAx0sRaoQy+GvlJwdbeuALP6w753BokQ6Ntgn1CprNYfsLV0HyPLKArG
         akHTN5TS0anvn649N1baUVEExSdMV3JZaoHnIuk7nltDaf35RlMHu/NAHGrDIHrupOx+
         3lznd0d2y10r7qcVVa/+6VIwIl5Kxc2GyCkJ+TjW47zTL5cY0cpkgFiyGecCrazoXOav
         DMgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710613587; x=1711218387;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=or8uieS26G/ESlrGned3+g3CrJ2Qms+80gVSzUSHLI8=;
        b=hlSR0zAlBek3ZBKf8KYokmf5OQmEjZqIEgPSHfENZlKT5YbLO/VOSL3G3N0vcM2nW6
         chR+k8OYdGn8i+x6Zt9LnrESXHmM+cY1cA/T2bsh/3pkVNW2qGfuzCsIVXW+5Jm1Tvx6
         Oc397n0F34bC8VKGvAJ6hAfAzW2jG9wMBt8bQnokT9Hwfn8XRjDQfy9mkQ1YLMqAzbym
         3zUAlynlc9kz0QCOVjR93ehlYOrqs+86vLSTXeBTU2TwTRy0SPfTvHuL0k7iXVGhirrG
         MQyYE0MhYly634hiFAl0hG3O6QNFLY+GArbTYqzXvOGOJGX5yCSoVAXI6haSQOLud6t+
         w/rg==
X-Gm-Message-State: AOJu0YxJTfGaLkzMnoJpWIaeLUiWJdqjj4WR79SUaYlN6yVs683rBL0W
	UAKOZXN0UBhm81ZXVTh+X3l4SteqFQXCQ7EAkBn1HTjHQMPuD8Y1RKybhU4YybCzmRP+F2saDly
	7DXCzudJT2RvcG4fI47dM51UTCtjNYS/4zJ4=
X-Google-Smtp-Source: AGHT+IFs0oIfhmYE/gUzuqC6Ap2wnC2aHIkZUuu3mTM9GALuvf0oRDfRQ2oTQfHyrd7MULQBh4RL80fuF/giy1PWPtc=
X-Received: by 2002:a17:906:8406:b0:a46:7384:3233 with SMTP id
 n6-20020a170906840600b00a4673843233mr4674577ejx.57.1710613586716; Sat, 16 Mar
 2024 11:26:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Shaya Potter <spotter@gmail.com>
Date: Sat, 16 Mar 2024 20:26:15 +0200
Message-ID: <CALHdMH30LuxR4tz9jP2ykDaDJtZ3P7L3LrZ+9e4Fq=Q6NwSM=Q@mail.gmail.com>
Subject: Issue with moving LSI/Dell Raid to MD
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

note: not subscribed, so please cc me on responses.

I recently had a Dell R710 die where I was using the Perc6 to provide
storage to the box.  As the box wasn't usable, I decided to image the
individual disks to a newer machine with significantly more storage.

I sort of messed up the progress, but that might have discovered a bug in mdadm.

Background, the Dell R710 supported 6 drives, which I had as a 1TB
SATA SSD and 5x8TB SATA disks in a RAID5 array.

In the process of imaging it, I I was setting up devices on /dev/loop
to be prepared to assemble the raid, but I think I accidentally
assembled the raid while imaging the last disk (which in effect caused
the last disk to get out of sync with the other disks.  This was
initially ok, until the VM I was doing it on, crashed with a KVM/QEMU
failure (unsure what occurred).

I was hoping, it was going to be easy to bring up the raid array
again, but now mdadm was segfault on a null pointer exception whenever
I tried to assemble the array (was just trying the RAID5 portion).

I was thinking perhaps my VM got corrupted, but I couldn't figure that
out, so I decided to try and reimage the disks (more carefully this
time), but yes, the 5th disk was marked as in quick init, while the
others were more consistent.

Howvever, same segfault was occuring, so I built mdadm from source
(with -g and no -O, as an aside, this would be a good Makefile target
to have, to make issues easier to debug)

After understanding the issue, the segfault seems to be due to
Assemble.c wanting to call update_super() with a ddf super.  Except
super-ddf.c doesn't provide that.

i.e. in Assemble.c it was crashing at

if (st->ss->update_super(st, &devices[j].i, UOPT_SPEC_ASSEMBLE, NULL,
c->verbose, 0, NULL)) {...}

which now explained the seg fault on null pointer exception.  I was
able to progress past the segfault (perhaps badly, but it "seems" to
work for me), by putting in a null check before the update_super()
call, i.e.

if (st->ss->update_super && st->ss->update_super(....)) { ... }

thoughts about my "fix" (perhaps super-ddf.c needs an empty
update_super function?) , if this is a bug? (perhaps its unexpected
for me to have gotten into this state in the first place?)
