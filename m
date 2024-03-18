Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A35A35F0C
	for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 11:42:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710762154; cv=none; b=OYevr7LszYqn9ZusQbHOFZ5LW/1dHzod0sEWJ/9DkGsA7dFtTh3ng2YvIBLbaSZppdU/m0bxy9TwUjWasDQGBwZZTWPb0qi+Sk9bRjf4ZrszEUAmAgm8HlT9jaIEPGvNLxt3rzDmRVofisY4p/5Uji5YYHaDS0akBXauWLUBiLc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710762154; c=relaxed/simple;
	bh=DmQ4rcZuhir1fCppr2C0oYgvhcx1Igi4cP7wO0eL72M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rte5LXswbQvFP2B2U7/PMTUoVogYdJ1pbhonE9cJa5tF5m97sb1yFnQbv8anE6ytMrCDCFTdCxjyG9Lo3XWpqlEZMPPubLVsy1Ea3P6qeXC79/cZmlxBLhU62/WBuh4JtjssAJOzPZBxpMWX+mCix3k50a9wwROsA7o7kmaIWzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=MmfrkqL0; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="MmfrkqL0"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-a44ad785a44so487972266b.3
        for <linux-raid@vger.kernel.org>; Mon, 18 Mar 2024 04:42:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1710762151; x=1711366951; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zt6OcdnGq6vPgXcUzxznik8eYowd8qifeSqVKnppgdM=;
        b=MmfrkqL0XUTtwHPISI+3GOteavmOGQd5VUpQ90oAE80cBPyzrSvPmYtM9ZNkmKDOO0
         8126PfsxQ3IBvYY7c5bi5ffwfDOA8qE49wKI8LfruNGAHSltRZIFabKhpgd7MLeDtq89
         DknY7Jgwb4Wd9b/RzoM05pZtjpS12KAoxmtUgCAZXvSIN7iShU5ITeB8dRk8VcfYnQst
         VvFAEbQBA1UxXng7I3CXfjABul7WHedE0pd21NDGU8jeHG/oh+yJhKvv72D6VNVsFzpT
         zcpxqhTMVuMzu3+VTvNUqfiFkAdnuvQpGbxzoIpJYMYzl9xp+GRdkT4rjaIdobYe0K6u
         PP4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710762151; x=1711366951;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zt6OcdnGq6vPgXcUzxznik8eYowd8qifeSqVKnppgdM=;
        b=O6ZCuC0y8hUb4yLbIDA/OPEoL6H80HR2z6g9Q23p0K55GQTue0zkZWyZBkmtiPWjgg
         Pn4AYEpBIv7xjCWeb2mRykLkhJ6MOF01BpPcXhUNBNLzsA+hMVPLxnoUMRAF/Wn+4jI7
         k5uVAQ55yMQv3DbpeF6ZwNOJaTfGGyFcZu1uAaJCFp9WJQASPYXD+Se8Wba5F/WLp2OG
         iNU28HRey1bY83GViS/BzwqvZKjRBGZc/NoFwfg1xgIj3ORGfIn1M8JNxXUMinK6sW9a
         TS0nYy5UvqfAFi+0TEpAUh76ZlurQEX/eFyCXArICMKQH/I85gICfwQQ3k3JRb70vZzJ
         nU7Q==
X-Gm-Message-State: AOJu0YxqanHWUf9JsHfQuwTQdhCzZnoqsECinRwpCYvTQk0yRm4I/TxQ
	QzBC2aj/hBqycKzcwWdA/nd7mzhhTmajbEZtmVHTNZ/ufTOdWjL5lq77IoZPfXKIuYxXgW8QSy2
	gXMWHHECHk3RV3P1wGPR5WGRB+z77VKwQW8sy9A==
X-Google-Smtp-Source: AGHT+IHEbFU+Mh8E97pVKXo/6CZfRYYGtsoFfAOdXpVf9UurxuqKsSQNaWC5jDq/mhIxUbS67lBy1XlsZBNxMojo8S8=
X-Received: by 2002:a17:907:110b:b0:a46:206d:369b with SMTP id
 qu11-20020a170907110b00b00a46206d369bmr7057640ejb.28.1710762150127; Mon, 18
 Mar 2024 04:42:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CALHdMH30LuxR4tz9jP2ykDaDJtZ3P7L3LrZ+9e4Fq=Q6NwSM=Q@mail.gmail.com>
 <20240318121806.00001147@linux.intel.com>
In-Reply-To: <20240318121806.00001147@linux.intel.com>
From: Shaya Potter <spotter@gmail.com>
Date: Mon, 18 Mar 2024 13:42:18 +0200
Message-ID: <CALHdMH1yQJd8ktueRVdHjwTmQbth0amCRQhvFjuqHLW2a-dfkQ@mail.gmail.com>
Subject: Re: Issue with moving LSI/Dell Raid to MD
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, Mar 18, 2024 at 1:18=E2=80=AFPM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Sat, 16 Mar 2024 20:26:15 +0200
> Shaya Potter <spotter@gmail.com> wrote:
>
> > note: not subscribed, so please cc me on responses.
> >
> > I recently had a Dell R710 die where I was using the Perc6 to provide
> > storage to the box.  As the box wasn't usable, I decided to image the
> > individual disks to a newer machine with significantly more storage.
> >
> > I sort of messed up the progress, but that might have discovered a bug =
in
> > mdadm.
> >
> > Background, the Dell R710 supported 6 drives, which I had as a 1TB
> > SATA SSD and 5x8TB SATA disks in a RAID5 array.
> >
> > In the process of imaging it, I I was setting up devices on /dev/loop
> > to be prepared to assemble the raid, but I think I accidentally
> > assembled the raid while imaging the last disk (which in effect caused
> > the last disk to get out of sync with the other disks.  This was
> > initially ok, until the VM I was doing it on, crashed with a KVM/QEMU
> > failure (unsure what occurred).
> >
> > I was hoping, it was going to be easy to bring up the raid array
> > again, but now mdadm was segfault on a null pointer exception whenever
> > I tried to assemble the array (was just trying the RAID5 portion).
> >
> > I was thinking perhaps my VM got corrupted, but I couldn't figure that
> > out, so I decided to try and reimage the disks (more carefully this
> > time), but yes, the 5th disk was marked as in quick init, while the
> > others were more consistent.
> >
> > Howvever, same segfault was occuring, so I built mdadm from source
> > (with -g and no -O, as an aside, this would be a good Makefile target
> > to have, to make issues easier to debug)
> >
> > After understanding the issue, the segfault seems to be due to
> > Assemble.c wanting to call update_super() with a ddf super.  Except
> > super-ddf.c doesn't provide that.
> >
> > i.e. in Assemble.c it was crashing at
> >
> > if (st->ss->update_super(st, &devices[j].i, UOPT_SPEC_ASSEMBLE, NULL,
> > c->verbose, 0, NULL)) {...}
> >
> > which now explained the seg fault on null pointer exception.  I was
> > able to progress past the segfault (perhaps badly, but it "seems" to
> > work for me), by putting in a null check before the update_super()
> > call, i.e.
> >
> > if (st->ss->update_super && st->ss->update_super(....)) { ... }
> >
> > thoughts about my "fix" (perhaps super-ddf.c needs an empty
> > update_super function?) , if this is a bug? (perhaps its unexpected
> > for me to have gotten into this state in the first place?)
> >
>
> Hello Shaya,
> DDF is not actively developed. I'm considering dropping
> it.
> If you are interested in bringing it too life then you are
> more than welcome to send patches!
>
> If DDF doesn't implement update_super() then fix proposed by you seems to=
 be
> valid. Please send proper patch for that then we will review it.
>
> Thanks,
> Mariusz

I'll make a proper patch in the coming days.

just to note: it is very useful for recovering from RAID arrays that
do provide that metadata.  It would be a shame (IMO) to lose support
for it, as it would have made my recovery/migration efforts much more
difficult.  At worst, I'd suggest marking it unmaintained, needing a
specific flag to be used which notes, since it's unmaintained, it
might go down code paths that are untested and could break in future
(i.e. what happened to me).

As a total other aside: md seems to work much better (performance
wise) when using loop devices when the loop devices are created with
direct-io support.
