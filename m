From: Alexander Lyakas <alex.bolshoy@gmail.com>
Subject: Re: mdadm: ioctl(GET_DISK_INFO) question
Date: Sun, 29 Apr 2012 23:21:26 +0300
Message-ID: <CAGRgLy7cLqE=VMveUh4DiFTvB35FvkyOKm-8eKGWZQGhSoroXg@mail.gmail.com>
References: <CAGRgLy4p0aiZD92dJsV3tdcZyPaJ=8Nc6CKWVcQU20QtMb6MBQ@mail.gmail.com>
	<20120428080911.10fe2f47@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120428080911.10fe2f47@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks for the clarification, Neil. I will really try to provide (at
least a partial) patch, together with the other patch I promised to
test...

On Sat, Apr 28, 2012 at 1:09 AM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 27 Apr 2012 17:14:28 +0300 Alexander Lyakas <alex.bolshoy@gma=
il.com>
> wrote:
>
>> Hello,
>>
>> what is the reason that in some places (like Detail()), the code tes=
ts
>> for all desc_nrs possible (value read from superblock or MaxDisks
>> macro):
>> for (d =3D 0; d < max_disks; d++) {
>> =A0 =A0 disc.number =3D d;
>> =A0 =A0 ioctl(fd, GET_DISK_INFO, &disk)
>>
>> and in other places (like Monitor()), the loop goes only up to :
>> array.raid_disks + array.nr_disks.
>
> Bug.
>
>>
>> After all, disk.number (which is rdev->desc_nr in kernel) is merely =
a
>> position of the disk entry in the dev_roles[] array in the superbloc=
k,
>> and has no relation to the raid slot of the disk. Shouldn't the code
>> always check max_disks possible?
>
> Yes.
>
> Thanks,
> NeilBrown
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
