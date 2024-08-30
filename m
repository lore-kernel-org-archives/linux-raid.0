Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50BFB16BE02
	for <linux-raid@vger.kernel.org>; Fri, 30 Aug 2024 08:51:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725007890; cv=none; b=kG6vvKeWXXEChXVNwZ1WxMTkVc0on7rcnZ+G+oJqr2HtIu3gBi0MVUkvFgEtC/plyDJVgrs9YQFL/upKyExHXo17N97tyg7+swNb0xnqpYXepwK4SN8aRkPyd7xkwTwwUJ2yKbx3gQgSBmV3JXQYocaYIk1MWwqr4D3JXSCIJgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725007890; c=relaxed/simple;
	bh=IF/vIQBvo2OoaFXiFSnZQs86fU6MX+WnD74uCUGxQxw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BfD6bHMIEx0JzFb7VHKoiyvzfI2/z1KPilHV3st7zUGKIc0HPMxJa0zhxus+Mz8ruC+0hXCL8O7ApxIY6SvUWP1Id5axf4EuTfcas0n9cj54kQAh/vceL7LJnBmLD4+XmKcsLSx2j7b4qm3/qE0ClqA9lVY4ucy/MPnWGt5PMCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=cQ4M7vc+; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cQ4M7vc+"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1725007886;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jc41Dt/tczIZwJ4g+3dbds6CVEsMeIM+1YqHZSSah8Y=;
	b=cQ4M7vc+1qX9sBfuGmUEMW6gMT7ZeokeV0c3BSuoTshjrbsane2zITGsK/9cnehEQ6X86i
	6nEn79tQwFdw4ajY50gwblQDi3UqvRiWh0TPWk3lUiyOvL3DIt8Kj8YoFvgeRL30R8/vVu
	R1698CUdXTjIMGHEmBYP97s2phX+w1I=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-142-Ja2xnwDgN4qqN5aILS-ITg-1; Fri, 30 Aug 2024 04:51:24 -0400
X-MC-Unique: Ja2xnwDgN4qqN5aILS-ITg-1
Received: by mail-pg1-f197.google.com with SMTP id 41be03b00d2f7-72c1d0fafb3so1355406a12.2
        for <linux-raid@vger.kernel.org>; Fri, 30 Aug 2024 01:51:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725007883; x=1725612683;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jc41Dt/tczIZwJ4g+3dbds6CVEsMeIM+1YqHZSSah8Y=;
        b=CHAHrykfnct90sgm+xFXWnfNl2jFjCKqxWIZSTNi5spZLDzkduDI2xmmGA+xI2AG5t
         DBHvCXoUmnH/wUEfObzSX37ljicq2A6OdnMPJLuXpjNqqGebHYUJ4Dqn9e8omWdus4pW
         jcm0K+2xa1HnjQHbYUYJ2G48aIYDJIeQVL2tWYiDtSP6gBfriBnGUFUoWovbzZSJT5ZD
         +Fqid0+B0nv8E1lrlalyUdmGmMVgeZVV7owo7s4nsXTGaDD+v+0EuPTa47iT6e6KOqb1
         OOIZikmlxy0EQN4pcQsb6/29K4JReG3pbkBmluXFwkx8V0w9aIDi/xqrywZl0NBi5Haw
         PpcQ==
X-Forwarded-Encrypted: i=1; AJvYcCXxqNR0EEKVtbG6GiAqTvFkifsG6vnTg48VdkKyWObS+h2516dcfHovtKE6pkF1Sv4VXJNqx1vZFwD/@vger.kernel.org
X-Gm-Message-State: AOJu0YzyVfIgfEQm6jTGVBwfcGgN3cFAywiYWLRhIXvRRPwh5cMKCnmP
	QsWrGOPuhyCGv3h+nx13BFP/z7tQNkzjepXKoh/H4KA21M9D0Lg1l8tKDgFXrSpvBI1eJ39rGME
	q6Abj9bwmiwTdnXbDkN+eEYHdBI4cDKzHRK3DsjgYcjb5DQTb6aNVhpVGg/z4rxER2BOaeq5Egv
	vcAD0MmIGvZfm+B1aliiTXkzBhnJuQpzAA8A==
X-Received: by 2002:a05:6a21:1394:b0:1cc:de9b:1ca with SMTP id adf61e73a8af0-1cce101d280mr4260166637.30.1725007883421;
        Fri, 30 Aug 2024 01:51:23 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IH3wsV6cwvNUOZ0SG2Nqvu8+yYtAOVSbznWGtiFS750Q3aLm7UqPQvDVoEVA+4ix/qk8mVsb+LccuayN6/oiJg=
X-Received: by 2002:a05:6a21:1394:b0:1cc:de9b:1ca with SMTP id
 adf61e73a8af0-1cce101d280mr4260151637.30.1725007882798; Fri, 30 Aug 2024
 01:51:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240829100133.74242-1-xni@redhat.com> <cafa231e-8ad8-05d2-80c0-f90c1b509bd1@huaweicloud.com>
 <CALTww2-dV0WTHfZANoXJro-Vx19WeA2m-NLFm1F0bCzd=jC3oQ@mail.gmail.com>
 <193d4bb3-3738-710e-7763-7bdc812a910f@huaweicloud.com> <CALTww2_D3A9r0ZRXfMYBQnHMyuYua_ynaHg=CTyVbEtRCZ84Ow@mail.gmail.com>
 <4e4a2d04-a986-ef45-1452-59090580a1f8@huaweicloud.com>
In-Reply-To: <4e4a2d04-a986-ef45-1452-59090580a1f8@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Fri, 30 Aug 2024 16:51:11 +0800
Message-ID: <CALTww282hmf02LE+f9bh3KcODqzBzDfzuuaU71JXjAcJprkbVQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] [PATCH V2 md-6.12 1/1] md: add new_level sysfs interface
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, pmenzel@molgen.mpg.de, 
	"yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 30, 2024 at 3:37=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/08/29 21:48, Xiao Ni =E5=86=99=E9=81=93:
> > On Thu, Aug 29, 2024 at 9:34=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.co=
m> wrote:
> >>
> >> Hi,
> >>
> >> =E5=9C=A8 2024/08/29 21:13, Xiao Ni =E5=86=99=E9=81=93:
> >>> On Thu, Aug 29, 2024 at 8:24=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.=
com> wrote:
> >>>>
> >>>> Hi,
> >>>>
> >>>> =E5=9C=A8 2024/08/29 18:01, Xiao Ni =E5=86=99=E9=81=93:
> >>>>> This interface is used to update new level during reshape progress.
> >>>>> Now it doesn't update new level during reshape. So it can't know th=
e
> >>>>> new level when systemd service mdadm-grow-continue runs. And it can=
't
> >>>>> finally change to new level.
> >>>>
> >>> Hi Kuai
> >>>
> >>>> I'm not sure why updaing new level during reshape. Will this corrupt
> >>>> data in the array completely?
> >>>
> >>> There is no data corruption.
> >>>
> >>>
> >>>>>
> >>>>> mdadm -CR /dev/md0 -l6 -n4 /dev/loop[0-3]
> >>>>> mdadm --wait /dev/md0
> >>>>> mdadm /dev/md0 --grow -l5 --backup=3Dbackup
> >>>>> cat /proc/mdstat
> >>>>> Personalities : [raid6] [raid5] [raid4] [raid0] [raid1] [raid10]
> >>>>> md0 : active raid6 loop3[3] loop2[2] loop1[1] loop0[0]
> >>>>
> >>>> The problem is that level is still 6 after mddev --grow -l5? I don't
> >>>> understand yet why this is related to update new level during reshap=
e.
> >>>> :)
> >>>
> >>> mdadm --grow command returns once reshape starts when specifying
> >>> backup file. And it needs mdadm-grow-continue service to monitor the
> >>> reshape progress. It doesn't record the new level when running `mdadm
> >>> --grow`. So mdadm-grow-continue doesn't know the new level and it
> >>> can't change to new level after reshape finishes. This needs userspac=
e
> >>> patch to work together.
> >>> https://www.spinics.net/lists/raid/msg78081.html
> >>
> >> Hi,
> >>
> >> Got it. Then I just wonder, what kind of content are stored in the
> >> backup file, why don't store the 'new level' in it as well, after
> >> reshape finishes, can mdadm use the level api to do this?
> >
> > The backup file has a superblock too and the content is the data from
> > the raid. The service monitors reshape progress and controls it. It
> > copies the data from raid to backup file, and then it reshapes. Now we
> > usually don't care about it because the data offset can change and it
> > has free space. For situations where the data offset can't be changed,
> > it needs to write the data to the region where it is read from. If
> > there is a power down or something else, the backup file can avoid
> > data corruption.
> >
> > It should be right to update the new level in md during reshape. If
> > not, the new level is wrong.
>
> Thanks for the explanation, I still need to investigate more about
> detals, I won't object to the new sysfs api, however, I'll suggest
> consider this as the final choice.

Hi Kuai

The userspace reshape_array is the key function. Feel free to ask any
questions. I didn't know much about it before fixing mdadm regression
test cases. For now, I think it's the easiest way to fix this. It
needs to update the superblock with the right information.

By the way, the --backup design doesn't work as expected. There is a
data corruption risk when reshaping with a backup file. I didn't fix
it because focus on fixing regression cases this time.

Best Regards
Xiao
>
> Thanks,
> Kuai
> >
> > Best Regards
> > Xiao
> >>
> >> Thanks,
> >> Kuai
> >>
> >>>
> >>> Best Regards
> >>>
> >>> Xiao
> >>>>
> >>>> Thanks,
> >>>> Kuai
> >>>>
> >>>>>
> >>>>> The case 07changelevels in mdadm can trigger this problem. Now it c=
an't
> >>>>> run successfully. This patch is used to fix this. There is also a
> >>>>> userspace patch set that work together with this patch to fix this =
problem.
> >>>>>
> >>>>> Signed-off-by: Xiao Ni <xni@redhat.com>
> >>>>> ---
> >>>>> V2: add detail about test information
> >>>>>     drivers/md/md.c | 29 +++++++++++++++++++++++++++++
> >>>>>     1 file changed, 29 insertions(+)
> >>>>>
> >>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >>>>> index d3a837506a36..3c354e7a7825 100644
> >>>>> --- a/drivers/md/md.c
> >>>>> +++ b/drivers/md/md.c
> >>>>> @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char =
*buf, size_t len)
> >>>>>     static struct md_sysfs_entry md_level =3D
> >>>>>     __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
> >>>>>
> >>>>> +static ssize_t
> >>>>> +new_level_show(struct mddev *mddev, char *page)
> >>>>> +{
> >>>>> +     return sprintf(page, "%d\n", mddev->new_level);
> >>>>> +}
> >>>>> +
> >>>>> +static ssize_t
> >>>>> +new_level_store(struct mddev *mddev, const char *buf, size_t len)
> >>>>> +{
> >>>>> +     unsigned int n;
> >>>>> +     int err;
> >>>>> +
> >>>>> +     err =3D kstrtouint(buf, 10, &n);
> >>>>> +     if (err < 0)
> >>>>> +             return err;
> >>>>> +     err =3D mddev_lock(mddev);
> >>>>> +     if (err)
> >>>>> +             return err;
> >>>>> +
> >>>>> +     mddev->new_level =3D n;
> >>>>> +     md_update_sb(mddev, 1);
> >>>>> +
> >>>>> +     mddev_unlock(mddev);
> >>>>> +     return len;
> >>>>> +}
> >>>>> +static struct md_sysfs_entry md_new_level =3D
> >>>>> +__ATTR(new_level, 0664, new_level_show, new_level_store);
> >>>>> +
> >>>>>     static ssize_t
> >>>>>     layout_show(struct mddev *mddev, char *page)
> >>>>>     {
> >>>>> @@ -5666,6 +5694,7 @@ __ATTR(serialize_policy, S_IRUGO | S_IWUSR, s=
erialize_policy_show,
> >>>>>
> >>>>>     static struct attribute *md_default_attrs[] =3D {
> >>>>>         &md_level.attr,
> >>>>> +     &md_new_level.attr,
> >>>>>         &md_layout.attr,
> >>>>>         &md_raid_disks.attr,
> >>>>>         &md_uuid.attr,
> >>>>>
> >>>>
> >>>
> >>>
> >>>
> >>> .
> >>>
> >>
> >
> >
> > .
> >
>

