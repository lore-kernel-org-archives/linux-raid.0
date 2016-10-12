From: Song Liu <songliubraving@fb.com>
Subject: Re: [PATCH v4 6/8] md/r5cache: sysfs entry r5c_state
Date: Wed, 12 Oct 2016 21:23:03 +0000
Message-ID: <C830059D-2187-4CCA-9596-CFF2E7FC883D@fb.com>
References: <20161011002446.2002428-1-songliubraving@fb.com>
 <20161011002446.2002428-7-songliubraving@fb.com>
 <20161012165647.GB15323@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20161012165647.GB15323@kernel.org>
Content-Language: en-US
Content-ID: <5F6FA894F8AEA54589C40271493504B3@namprd15.prod.outlook.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.com" <neilb@suse.com>, Shaohua Li <shli@fb.com>, Kernel Team <Kernel-team@fb.com>, "dan.j.williams@intel.com" <dan.j.williams@intel.com>, "hch@infradead.org" <hch@infradead.org>, "liuzhengyuang521@gmail.com" <liuzhengyuang521@gmail.com>, "liuzhengyuan@kylinos.cn" <liuzhengyuan@kylinos.cn>
List-Id: linux-raid.ids


> On Oct 12, 2016, at 9:56 AM, Shaohua Li <shli@kernel.org> wrote:
>=20
>>=20
>=20
> This isn't how sysfs entry is supposed to output. You can either show the=
 value
> or the string, not both with format. I'd prefer the string though, and ma=
ke
> store accept string.

I implemented something like the following:

root@virt-test:~/md# cat /sys/block/md0/md/r5c_state
[write-through] write-back
root@virt-test:~/md# echo write-back > /sys/block/md0/md/r5c_state
root@virt-test:~/md# cat /sys/block/md0/md/r5c_state
write-through [write-back]

root@virt-test:~/md# ./mdadm --fail /dev/md0 /dev/loop4
mdadm: set /dev/loop4 faulty in /dev/md0
root@virt-test:~/md# cat /sys/block/md0/md/r5c_state
no-cache [cache-broken]
root@virt-test:~/md# echo no-cache > /sys/block/md0/md/r5c_state
root@virt-test:~/md# cat /sys/block/md0/md/r5c_state
no-cache

It will be part of next version.=20

Thanks,
Song=
