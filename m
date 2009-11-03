From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Unbelievably _good_ write performance: RHEL5.4 mirror
Date: Tue, 3 Nov 2009 08:31:10 -0800
Message-ID: <4877c76c0911030831q2ca99007lf3b9068de6be48b@mail.gmail.com>
References: <f3177b9e0911021028t1fea4ad2lb4cf87059d300a0c@mail.gmail.com>
	 <921ca19c0911030437s4ba6b2d9l24fe4d2c83029e9b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <921ca19c0911030437s4ba6b2d9l24fe4d2c83029e9b@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sujit K M <sjt.kar@gmail.com>
Cc: Chris Worley <worleys@gmail.com>, linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Is it possible the data-set you are testing with is too small?  Modern
drives have caches of around 32MB, your test might only be executing
within the drive's caches.

On Tue, Nov 3, 2009 at 4:37 AM, Sujit K M <sjt.kar@gmail.com> wrote:
> This I think is an reported bug.
>
> On Mon, Nov 2, 2009 at 11:58 PM, Chris Worley <worleys@gmail.com> wro=
te:
>> I expect RAID1 write performance to be, at best, the performance of
>> the slowest drive.
>>
>> I'm seeing twice the performance, as if it were a RAID0. =A0The read
>> performance is 2x also, which is what I would expect.
>>
>> I'm using the incantation:
>>
>> mdadm --create /dev/md0 --chunk=3D256 --level=3D1 --assume-clean
>> --raid-devices=3D2 /dev/sd[bc]
>>
>> I use "assume clean" on the fresh create, as there is no reason to
>> sync the new drives.
>>
>> My "fio" test uses O_DIRECT with 64 threads, each with a queue depth
>> of 64, running for 10 minutes. =A0All caching is disabled, and the N=
OOP
>> scheduler is being used. =A0I run this test all the time, and can't
>> imagine why it's getting such repeatably good write performance.
>>
>> Any ideas?
>>
>> Thanks,
>>
>> Chris
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> -- Sujit K M
>
> blog(http://kmsujit.blogspot.com/)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
