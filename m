From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: Why are reads not balanced across my RAID-1?
Date: Fri, 24 Jan 2014 16:50:52 +0000
Message-ID: <CADNH=7E4M_GwKibA4ytU6WoBb7iho5wdxz5_JxVdqU7xSDcaqQ@mail.gmail.com>
References: <20140124104757.8256.qmail@science.horizon.com>
	<20140124120448.GA19163@www5.open-std.org>
	<CAJvUf-BfK-CeLFZ3WmRFbSpjr_x8x1FO7pDX5gmAJyw2RpekxA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-BfK-CeLFZ3WmRFbSpjr_x8x1FO7pDX5gmAJyw2RpekxA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>
Cc: =?UTF-8?Q?Keld_J=C3=B8rn_Simonsen?= <keld@keldix.com>, George Spelvin <linux@horizon.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 24 January 2014 14:56, Matt Garman <matthew.garman@gmail.com> wrote:
> On Fri, Jan 24, 2014 at 6:04 AM,  <keld@keldix.com> wrote:
>> The reading is not balanced because it does not make sense to do balanced
>> reads for sequential reading. In RAID-1 the disk sectors are consequitive.
>> So if you would read one sector from one disk, and the following sector from the other disk,
>> then the next read from disk 1 would need to skip a full resolvation of the disk,
>> which may cost something like 8 ms.  So better read contigously from the same disk, and hope
>> for some other IO request that can use disk 2.
>
>
> Does that rationale hold for SSDs?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


Note: MD can do RAID10 with 2 devices, right?

Mathias
