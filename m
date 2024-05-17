Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8ECC4C69
	for <linux-raid@vger.kernel.org>; Fri, 17 May 2024 02:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715912766; cv=none; b=ZYkmKsxjXHKzQ9jyhe9iX8yVxWB9A3Uvhad6uI0rwJTFtp44b+TA8bEcizNpu6XyKCH8Rq3zgKfi2pJgCSlTtspqj7LfUb08Rvf8gDq4MqSQOzWdJJlC/rNscJgBjujaKtKf27MVG2kG5+zBQXWEJVMmjQk43oW/uM/wdLSB9jQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715912766; c=relaxed/simple;
	bh=SCHoOAADiHLC+b/u+Klk7TcG4w70MzCj6ICzJpgVe6Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QZqZivV77yIEsMnF4KvpdSKOyQRdtEbgVoxBGfaRKHqo6xv4/CiK8WUHyoQUYkTXMr8mN/bHLb3F9j7KvS6MaUTgWAq8VOqiodcDOnXiEucpFDt9ze4iEAo/gHNB13EDgz4IQeNDv9FYza7aOWUPIPOfPysEOvGK5ladQV+HqKg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=a0Dy30+/; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="a0Dy30+/"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715912763;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=eAomeIPeuDmEUuguTPEhXeZw4EXUWZ+KhouJqo4n3OY=;
	b=a0Dy30+/+RVUxsV2Jw/b4zQd73udt3ecxCYBnl3tYjuG3XTgk5aBVVWIJ8xreHNXIIhF8/
	YUYI0zmQ2kVGv5UVM5JZ8JaR5mAOHz1Sfkcz49OhpthYju0QO+K7FcmvKhf8XCHPkAK5x0
	mb8lQTPP4vYOY9OYPO+lAHXOUady6fE=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-183-SzHKs7JEPOqkr6PRpgyqXQ-1; Thu, 16 May 2024 22:25:59 -0400
X-MC-Unique: SzHKs7JEPOqkr6PRpgyqXQ-1
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-2b8700329e6so5792632a91.1
        for <linux-raid@vger.kernel.org>; Thu, 16 May 2024 19:25:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715912758; x=1716517558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eAomeIPeuDmEUuguTPEhXeZw4EXUWZ+KhouJqo4n3OY=;
        b=jIwXuQWXfbPynJOXh/+mNnU7OZDFS9dwHlHkq2N5ndE8oKKjxjha+aKihG5LsOSSmT
         uIyaLkuzcA9qNGX+7V1UubXX7S+wGoFh3Gm8vCSEztq8zSINZOWNMFu+enio0Nt5S+M8
         5Os/84USUS9xH0YoM/GTRfAb3p3TtjDyjjpGy0OSXBapAZptkUuGDs9PrH78xeNPmnK0
         F+JGHvEaLyOCgYvOS+bOHhr3FG3TllUPxk0jlM+jMmLb5YoUbE+SMnbC6xt/xgl2Y0Ic
         FVgcwXrLCIBoTIveP2WxWPlmDHcMji5LcAgKaA6c/aTvbGyDgnRRcIBMLHRqv4n7YdSe
         F/Xw==
X-Forwarded-Encrypted: i=1; AJvYcCUU0SKw4acDHgkhp3d7PnrMbqV9kVXdvSLdQBBfBkRLkoEbMP2hTQB9CYA1vAiYx3LvSXvMif3eKPQJcCKvm64u8AfmEfbum20nEw==
X-Gm-Message-State: AOJu0YwaUcT2C7aIwuwVtQ0eQbL/u2MuXpSJZegDykcOTzAt8bJPQDf/
	LNuaQXVO+cZE9BbcsQpvlByTRKWIJ6AD1hSQsMfzUVRSN668CCpMZnTtrWjeWDTobk1bfLBRAK4
	TiK/Iqzd6y8IaQoK2XJkQWA2TUOSRwDK6E0khjOIHaCJmBOjnNmkpzGgu/FWzpd6glr9kFIgpwH
	nlbYcLBmq+w2cjF/bq7eq9JI58OToccpaALA==
X-Received: by 2002:a17:90a:a395:b0:2b4:a767:193e with SMTP id 98e67ed59e1d1-2b6ccd6b9c0mr18225157a91.38.1715912758435;
        Thu, 16 May 2024 19:25:58 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFjDQZWm7LZIDtw7JxDTA11mJu6souYWqq3WFTuntSmR5T9ZV9uVN1PQP/pTaAzrVN2SvwQeZNp2rc5ByilPXw=
X-Received: by 2002:a17:90a:a395:b0:2b4:a767:193e with SMTP id
 98e67ed59e1d1-2b6ccd6b9c0mr18225136a91.38.1715912757960; Thu, 16 May 2024
 19:25:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAGVVp+Xsmzy2G9YuEatfMT6qv1M--YdOCQ0g7z7OVmcTbBxQAg@mail.gmail.com>
 <ZkXsOKV5d4T0Hyqu@fedora> <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
In-Reply-To: <9b340157-dc0c-6e6a-3d92-f2c65b515461@huaweicloud.com>
From: Changhui Zhong <czhong@redhat.com>
Date: Fri, 17 May 2024 10:25:46 +0800
Message-ID: <CAGVVp+XtThX7=bZm441VxyVd-wv_ycdqMU=19a2pa4wUkbkJ3g@mail.gmail.com>
Subject: Re: [bug report] INFO: task mdX_resync:42168 blocked for more than
 122 seconds
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Ming Lei <ming.lei@redhat.com>, Linux Block Devices <linux-block@vger.kernel.org>, 
	dm-devel@lists.linux.dev, Mike Snitzer <snitzer@kernel.org>, 
	Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>, linux-raid@vger.kernel.org, 
	Xiao Ni <xni@redhat.com>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, May 16, 2024 at 7:42=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/05/16 19:21, Ming Lei =E5=86=99=E9=81=93:
> > Cc raid and dm list.
> >
> > On Thu, May 16, 2024 at 06:24:18PM +0800, Changhui Zhong wrote:
> >> Hello,
> >>
> >> when create lvm raid1, the command hang on for a long time.
> >> please help check it and let me know if you need any info/testing for
> >> it, thanks.
>
> Is this a new test, or a new problem?

it is a new problem, I am not hit this issue on 6.9.0-rc4+

> >>
> >> repo:https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block=
.git
> >> branch:for-next
> >> commit: 59ef8180748269837975c9656b586daa16bb9def
> >>
> >> reproducer:
> >> dd if=3D/dev/zero bs=3D1M count=3D2000 of=3Dfile0.img
> >> dd if=3D/dev/zero bs=3D1M count=3D2000 of=3Dfile1.img
> >> dd if=3D/dev/zero bs=3D1M count=3D2000 of=3Dfile2.img
> >> dd if=3D/dev/zero bs=3D1M count=3D2000 of=3Dfile4.img
> >> losetup -fP --show file0.img
> >> losetup -fP --show file1.img
> >> losetup -fP --show file2.img
> >> losetup -fP --show file3.img
>
> above dd creat file4, here is file3.

yeah=EF=BC=8Cthis is my spelling mistake, I created 4 files, file0/1/2/3

>
> >> pvcreate -y  /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
> >> vgcreate  black_bird  /dev/loop0 /dev/loop1 /dev/loop2 /dev/loop3
> >> lvcreate --type raid1 -m 3 -n non_synced_primary_raid_3legs_1   -L 1G
> >> black_bird        /dev/loop0:0-300     /dev/loop1:0-300
> >> /dev/loop2:0-300  /dev/loop3:0-300
>
> I don't understand what /dev/loopx:0-300 means, and I remove them, fix
> the above file4 typo, test on a xfs filesystem, and I can't reporduce
> the problem.
>

I want to specify the space from disk blocks 0 to 300 of the loop
device to create raid1=EF=BC=8Cnot all space of loop device=EF=BC=8C
follow reproducer setps I can reproduced it 100%

> >>
> >>
> >> console log:
> >> May 21 21:57:41 dell-per640-04 journal: Create raid1
> >> May 21 21:57:41 dell-per640-04 kernel: device-mapper: raid:
> >> Superblocks created for new raid set
> >> May 21 21:57:42 dell-per640-04 kernel: md/raid1:mdX: not clean --
> >> starting background reconstruction
> >> May 21 21:57:42 dell-per640-04 kernel: md/raid1:mdX: active with 4 out
> >> of 4 mirrors
> >> May 21 21:57:42 dell-per640-04 kernel: mdX: bitmap file is out of
> >> date, doing full recovery
> >> May 21 21:57:42 dell-per640-04 kernel: md: resync of RAID array mdX
> >> May 21 21:57:42 dell-per640-04 systemd[1]: Started Device-mapper event=
 daemon.
> >> May 21 21:57:42 dell-per640-04 dmeventd[42170]: dmeventd ready for pro=
cessing.
> >> May 21 21:57:42 dell-per640-04 dmeventd[42170]: Monitoring RAID device
> >> black_bird-non_synced_primary_raid_3legs_1 for events.
> >> May 21 21:57:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
> >> May 21 21:57:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
> >> May 21 21:58:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
> >> May 21 21:58:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
> >> May 21 21:59:45 dell-per640-04 restraintd[1446]: *** Current Time: Tue
> >> May 21 21:59:45 2024  Localwatchdog at: Tue May 21 22:56:45 2024
> >> May 21 21:59:53 dell-per640-04 kernel: INFO: task mdX_resync:42168
> >> blocked for more than 122 seconds.
> >> May 21 21:59:53 dell-per640-04 kernel:      Not tainted 6.9.0+ #1
> >> May 21 21:59:53 dell-per640-04 kernel: "echo 0 >
> >> /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> >> May 21 21:59:53 dell-per640-04 kernel: task:mdX_resync      state:D
> >> stack:0     pid:42168 tgid:42168 ppid:2      flags:0x00004000
> >> May 21 21:59:53 dell-per640-04 kernel: Call Trace:
> >> May 21 21:59:53 dell-per640-04 kernel: <TASK>
> >> May 21 21:59:53 dell-per640-04 kernel: __schedule+0x222/0x670
> >> May 21 21:59:53 dell-per640-04 kernel: ? blk_mq_flush_plug_list+0x5/0x=
20
> >> May 21 21:59:53 dell-per640-04 kernel: schedule+0x2c/0xb0
> >> May 21 21:59:53 dell-per640-04 kernel: raise_barrier+0x107/0x200 [raid=
1]
>
> Unless this is a deadlock, raise_barrier() should be waiting for normal
> IO that is issued to underlying disk to return. If you can reporduce the
> problem, can you check IO from underlying loop disks?
>
> cat /sys/block/loopx/inflight

when this issue was triggered, the log I collected=EF=BC=9A

[root@storageqe-103 ~]# cat /sys/block/loop0/inflight
       0        0
[root@storageqe-103 ~]# cat /sys/block/loop1/inflight
       0        0
[root@storageqe-103 ~]# cat /sys/block/loop2/inflight
       0        0
[root@storageqe-103 ~]# cat /sys/block/loop3/inflight
       0        0
[root@storageqe-103 ~]#


and the command "lvs" hang on also=EF=BC=8C

[root@storageqe-103 ~]# lvs
^C  Interrupted...
  Giving up waiting for lock.
  Can't get lock for black_bird.
  Cannot process volume group black_bird
  LV   VG                 Attr       LSize    Pool Origin Data%  Meta%
 Move Log Cpy%Sync Convert
  home rhel_storageqe-103 -wi-ao---- <368.43g
  root rhel_storageqe-103 -wi-ao----   70.00g
  swap rhel_storageqe-103 -wi-ao----    7.70g
[root@storageqe-103 ~]#

[ 1352.761630] INFO: task mdX_resync:1547 blocked for more than 1105 second=
s.
[ 1352.769336]       Not tainted 6.9.0+ #1
[ 1352.773629] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs"
disables this message.
[ 1352.782372] task:mdX_resync      state:D stack:0     pid:1547
tgid:1547  ppid:2      flags:0x00004000
[ 1352.782380] Call Trace:
[ 1352.782382]  <TASK>
[ 1352.782386]  __schedule+0x222/0x670
[ 1352.782396]  schedule+0x2c/0xb0
[ 1352.782402]  raise_barrier+0x107/0x200 [raid1]
[ 1352.782415]  ? __pfx_autoremove_wake_function+0x10/0x10
[ 1352.782423]  raid1_sync_request+0x12d/0xa50 [raid1]
[ 1352.782435]  ? prepare_to_wait_event+0x5f/0x190
[ 1352.782442]  md_do_sync+0x660/0x1040
[ 1352.782449]  ? __pfx_autoremove_wake_function+0x10/0x10
[ 1352.782457]  md_thread+0xad/0x160
[ 1352.782462]  ? __pfx_md_thread+0x10/0x10
[ 1352.782465]  kthread+0xdc/0x110
[ 1352.782470]  ? __pfx_kthread+0x10/0x10
[ 1352.782474]  ret_from_fork+0x2d/0x50
[ 1352.782481]  ? __pfx_kthread+0x10/0x10
[ 1352.782485]  ret_from_fork_asm+0x1a/0x30
[ 1352.782491]  </TASK>

Thanks=EF=BC=8C
Changhui

>
> Thanks,
> Kuai
>
> >> May 21 21:59:53 dell-per640-04 kernel: ?
> >> __pfx_autoremove_wake_function+0x10/0x10
> >> May 21 21:59:53 dell-per640-04 kernel: raid1_sync_request+0x12d/0xa50 =
[raid1]
> >> May 21 21:59:53 dell-per640-04 kernel: ?
> >> __pfx_raid1_sync_request+0x10/0x10 [raid1]
> >> May 21 21:59:53 dell-per640-04 kernel: md_do_sync+0x660/0x1040
> >> May 21 21:59:53 dell-per640-04 kernel: ?
> >> __pfx_autoremove_wake_function+0x10/0x10
> >> May 21 21:59:53 dell-per640-04 kernel: md_thread+0xad/0x160
> >> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_md_thread+0x10/0x10
> >> May 21 21:59:53 dell-per640-04 kernel: kthread+0xdc/0x110
> >> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_kthread+0x10/0x10
> >> May 21 21:59:53 dell-per640-04 kernel: ret_from_fork+0x2d/0x50
> >> May 21 21:59:53 dell-per640-04 kernel: ? __pfx_kthread+0x10/0x10
> >> May 21 21:59:53 dell-per640-04 kernel: ret_from_fork_asm+0x1a/0x30
> >> May 21 21:59:53 dell-per640-04 kernel: </TASK>
> >>
> >>
> >> --
> >> Best Regards,
> >>       Changhui
> >>
> >
>
>

