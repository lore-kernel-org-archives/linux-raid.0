From: Mike Snitzer <snitzer@gmail.com>
Subject: Re: [md PATCH 8/8] md: Use revalidate_disk to effect changes in size
	of device.
Date: Wed, 5 Aug 2009 21:03:44 -0400
Message-ID: <170fa0d20908051803ud6ef819xdad3cafe44cc1fb8@mail.gmail.com>
References: <20090802215444.4198.83094.stgit@notabene.brown>
	 <20090802215818.4198.77041.stgit@notabene.brown>
	 <4A7A0287.5010505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A7A0287.5010505@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Aug 5, 2009 at 6:07 PM, H. Peter Anvin<hpa@zytor.com> wrote:
> On 08/02/2009 02:58 PM, NeilBrown wrote:
>> As revalidate_disk calls check_disk_size_change, it will cause
>> any capacity change of a gendisk to be propagated to the blockdev
>> inode. =A0So use that instead of mucking about with locks and
>> i_size_write.
>>
>> Also add a call to revalidate_disk in do_md_run and a few other plac=
es
>> where the gendisk capacity is changed.
>>
>
> This patch causes my Fedora 11 system with all filesystems on RAID-1 =
to
> not boot (it hangs in early userspace, Ctrl-Alt-Del reboots the syste=
m.)

I reported similar findings, with some more detail, relative to
=46edora's rawhide here:
http://lkml.org/lkml/2009/8/5/275
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
