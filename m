From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [RFC 1/2] MD: raid5 trim support
Date: Tue, 17 Apr 2012 11:16:12 -0700
Message-ID: <CABE8wwvu239b2CqmpKccvzDc3_LayVj4qHTEAYxcrpsx9RR5kQ@mail.gmail.com>
References: <20120417083552.483324288@kernel.org>
	<20120417084632.306032602@kernel.org>
	<CABE8wwswKWQ=LDbx0ysTaZf2Hz0jD_q45FNF0jw96ZwZdJiHPw@mail.gmail.com>
	<4F8D871E.2050403@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F8D871E.2050403@kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, axboe@kernel.dk, Shaohua Li <shli@fusionio.com>
List-Id: linux-raid.ids

On Tue, Apr 17, 2012 at 8:07 AM, Shaohua Li <shli@kernel.org> wrote:
> Hi Dan,
>
> On 4/17/12 10:46 PM, Dan Williams wrote:
>>
>> On Tue, Apr 17, 2012 at 1:35 AM, Shaohua Li<shli@kernel.org> =A0wrot=
e:
>>>
>>> Discard for raid4/5/6 has limitation. If discard request size is sm=
all,
>>> we do
>>> discard for one disk, but we need calculate parity and write parity=
 disk.
>>> =A0To
>>> correctly calculate parity, zero_after_discard must be guaranteed.
>>
>>
>> I'm wondering if we could use the new bad blocks facility to mark
>> discarded ranges so we don't necessarily need determinate data after
>> discard.
>
>
> It would be great the limitation can be avoided and the code can be
> simplified. I didn't follow linux-raid maillist, can you point me the=
 url
> of the new bad blocks facility please?

It came in at 3.1 starting with:

commit 2230dfe4ccc3add340dc6d437965b2de1d269fde
Author: NeilBrown <neilb@suse.de>
Date:   Thu Jul 28 11:31:46 2011 +1000

    md: beginnings of bad block management.

    This the first step in allowing md to track bad-blocks per-device s=
o
    that we can fail individual blocks rather than the whole device.

    This patch just adds a data structure for recording bad blocks, wit=
h
    routines to add, remove, search the list.

    Signed-off-by: NeilBrown <neilb@suse.de>
    Reviewed-by: Namhyung Kim <namhyung@gmail.com>

Here is a link to the patch set:
http://marc.info/?l=3Dlinux-raid&m=3D131121721902900&w=3D2

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
