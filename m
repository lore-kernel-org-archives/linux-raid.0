Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C15372192FD
	for <linux-raid@vger.kernel.org>; Fri,  7 Mar 2025 12:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741350324; cv=none; b=tJGtVmcy+9uvY57wsvkhohZrjW92zh8yldVSUSPGCZF0SrGJIOhyTthLsK6M79y3iTStzj/yIl+AUpav+6yQARDhsixgpAFR0Zza06G3X+tPengptmF9pupzKLsfsYAaAQvBDz8o/LK3QKSECKOH0P+1X5Jn5W1CZuZlhKNRCSw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741350324; c=relaxed/simple;
	bh=2smICwQ8i5kzYYhFsm+2CRAsdpDesAvSED9CGEWUbJI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mH7/VAuH9sqLqjPj1ClOWbDVHtyhOpbI05LXcnKObI1WwdfjSxSLJXKghU0I+B/nfnZMxRfLqtqbwQ6mVlRM/wgLxGvp17BplBqNM39d8De/YHkLz/h9FN9cdPWp33Ll1A5NsqgU/T3h57wG+omiO8op0/9bA44Anq7bleY0v5k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Gun3XGVo; arc=none smtp.client-ip=209.85.166.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Gun3XGVo"
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-85add719f7aso52838439f.3
        for <linux-raid@vger.kernel.org>; Fri, 07 Mar 2025 04:25:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1741350322; x=1741955122; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xQ3RinYsKQSlzNW5oKU5E/usVI56H58bIOB1POCZsi4=;
        b=Gun3XGVowNV13nAU1U6KcfgiKbpvM8MyFbItgOQP0odpheUFmKLD91k5cT0Q/SmKPW
         60s7jGR0ieLLNN5/xKvsEVLMTKttlVkHaX5C3WOr2/2SQEFGbo7lYfe6i2fB2Hx7hjKE
         8LfSzii1xP8gUk2T/5gEEuZHYjbu1MXM7FZ4ZU531oBnMkqQ3v7lIU+QzB6qxGHQ+skZ
         owSLJTko5yGcvEz3j3+z4T1ahPtaG01M6mTRfdqmi95BzAsZniIJUmgj9mxo2YNj5Fgi
         7RaVO4LKIuDKewcbDDPjgPNkCMDm6Z59KD1lmPcocQM6XGfrL80J3JWV+KXhlqwWTAlr
         TT3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741350322; x=1741955122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xQ3RinYsKQSlzNW5oKU5E/usVI56H58bIOB1POCZsi4=;
        b=JY1tG06jxqr3mlKfvreQt294QbuKfh5Lohy731Kqn0mBrXgWyyG4GH0VTqjeZXjOW3
         bewW9vugatkN/I32EAUGhJmpdzM7B16ivWu6Mu8+eKTdhcDa5Q/Dyg5/u8Rxlus+mHdG
         LZ2g61feOfdpzVbixIv69FAnaOM7bd9vxe9Sn+FitHIWRtYmqkCmd2+QYBj1wJ6lU0I8
         yi4aVOW9iHmYQc6w2IerJyvqoPOsBR8KTrWzYiVCpe1QpdJTjhVANQG43UIBHlNmemiL
         /iwi0AxpYBJbwC5kw8ihUeD/VCzQ3I502u3EiYlaJmuP7pVp/+bN17/0HzHPQlbmC7p2
         aplw==
X-Gm-Message-State: AOJu0Yw9XqnjQjwUYlZ/jZZNddH5nnD3+JV/TkwGFukLfH4f2QsDKMS+
	ooA9JiU3weRUxhNNvWqAwefPoToVd1DG1Q3KZLgz7Vb0im+qqwkaTrqNJ03rIvGIpstfPS8eOxR
	K4/xuhFvG/JiUVfdOtLRBIvzSZ3mdDa+L
X-Gm-Gg: ASbGnctE87vdrUW3LRMXomyTmfTSyh8oXJNVpM+7WL4p1fOpDHdzUIe8rPSDDXPLDwB
	A4fDKQ6vEvVxs9iR88RB1Ep+EwUKdF/KkcHj78YuggSiqXMdCIHrBSLOS7ozmq3PbQCtjcuEoVx
	b5AJLOCN97+gxPVTFp4SbATJ1k
X-Google-Smtp-Source: AGHT+IHm6gE5hWulbaln/nyAMQZGUGwTotGbPPVZsYU0R5GqV+iNgpIpOq7fGF2u3YHveIZJwhCiyDZEIci/po9As+0=
X-Received: by 2002:a05:6602:3714:b0:85a:dea5:2c5a with SMTP id
 ca18e2360f4ac-85b1d06ac6bmr469987639f.6.1741350321611; Fri, 07 Mar 2025
 04:25:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <0e2898c2-7d4a-47de-8d23-010cf2d8836b@eyal.emu.id.au>
 <CAAMCDefYhzMxbn8D2CAQ-XtsmykPPLsL8sjt-e0tF2QDMy=Y1A@mail.gmail.com>
 <adedae1f-dfdb-4770-aa1d-af2292851629@eyal.emu.id.au> <cc4e3021-d2c4-4aca-8923-5f143c156ffd@suse.de>
 <e619f4f9-ca95-4259-a0a5-669abc3813a4@eyal.emu.id.au>
In-Reply-To: <e619f4f9-ca95-4259-a0a5-669abc3813a4@eyal.emu.id.au>
From: Roger Heflin <rogerheflin@gmail.com>
Date: Fri, 7 Mar 2025 06:25:10 -0600
X-Gm-Features: AQ5f1JpDX4mTH3RkFRbyUdTfVMpPuXl2RAZ0UXVJvdFMRmoTBJ5r8I2x8-N7GrA
Message-ID: <CAAMCDefURh+GARN6K24RqBp9LzQj3ZZ=h3zT+FjqANYt6mmQnw@mail.gmail.com>
Subject: Re: Need to understand error messages
To: eyal@eyal.emu.id.au
Cc: Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

I do this to reduce the queue depth, you need to find the path to the
card to limit it to just the one card.  I have before reduced it even
lower.  The only advantage to letting the disk queue a few commands is
the disk MIGHT be able to merge 2 requests, though unless the requests
contain re-writes to the same sectors I would be surprised if any
merging ever gets done.

find /sys/devices/pci0000:00/0000:00:01.1/0000:10:00.0/ -name
"queue_depth" -exec /usr/local/bin/set_queue_depth 8 {} \;
find /sys/devices/pci0000:00/0000:00:01.1/0000:10:00.0/ -name
"nr_requests" -exec /usr/local/bin/set_queue_depth 16 {} \;

[root@bm-server .homeassistant]# cat /usr/local/bin/set_queue_depth
echo $1 > $2

On Fri, Mar 7, 2025 at 2:46=E2=80=AFAM Eyal Lebedinsky <eyal@eyal.emu.id.au=
> wrote:
>
> On 7/3/25 18:16, Hannes Reinecke wrote:
> > On 3/7/25 05:20, Eyal Lebedinsky wrote:
> >> On 7/3/25 12:27, Roger Heflin wrote:
> >>> That is the report uncorrectable error coming back to the OS.   ie
> >>> sense key: medium error.
> >>>
> >>> It looks like you had a few commands lined up (the tags) and one io
> >>> hung (2888) and eventually failed (bad sector) but it took long enoug=
h
> >>> that  is timed out on all of the other IO behind it (the SOFT_ERROR).
> >>>
> >>> The scsi layer should have retried the SOFT ones I would think.
> >>>
> >>> You might want to check to see what smartctl -l scterc says the disks
> >>> timeout is and what the OS level scsi timeout is.  I set the disk
> >>> timeouts as low as the disk will allow and leave my OS timeouts
> >>> default (30 sec typically).
> >>
> >> SCT Error Recovery Control:
> >>             Read:     70 (7.0 seconds)
> >>            Write:     70 (7.0 seconds)
> >>
> >>> I would have thought there would be a md rewrite.
> >>
> >> I also thought so. The fact that I now see 48 Reallocated_Sector_Ct su=
ggests that there were
> >> writes to the failed sectors, since a failed read adds a Pending then =
the write leads to Reallocation.
> >> Now Current_Pending_Sector is zero.
> >>
> >> Also, 48 reallocated is more than the one failed sector the disk sense=
d,
> >> and the following timed out tags is something the OS saw (and the disk=
 should not reallocate?).
> >>
> > The MPT hardware has a very poor queueing implementation. It exposes a =
SCSI host with literally thousands of commands, but the component drives
> > only have a queue depth of 31. So there is a mismatch, and there are
> > issues when a long-running command (eg a command triggering error handl=
ing) will block the pending commands already queued within the
> > firmware.
> > In these cases the offending command will cause the _pending_ commands
> > to timeout, even though the would probably be perfectly fine if they
> > hadn't been blocked. And returning 'QUEUE_FULL' status would be too
> > easy...
>
> Are you saying that the blocked commands which end up timing out are trea=
ted as bad sectors by the drive?
> I expect them to then be marked pending, then only when written to they w=
ill be reallocated.
> Who is re-writing these sectors?
>
> Why does md/raid say nothing? Are these sectors outside the raid area, so=
 not monitored by md/raid?
>
> TIA,
>         Eyal
>
> > Anyway.
> > Fact is, your drive developed read errors. And experience shows that
> > a read error is the beginning of the end for a drive.
> > So I would recommend to not investigate further but rather get a new
> > drive.
>
> Yep, I already have one ready for when the situation deteriorates further=
.
>
> > Cheers,
> >
> > Hannes
>
>
> --
> Eyal at Home (eyal@eyal.emu.id.au)
>
