From: hpa@zytor.com
Subject: Re: [PATCH 18/23] init: open code setting up stdin/stdout/stderr
Date: Sun, 26 Jul 2020 23:36:15 -0700
Message-ID: <366377E2-6F19-45E1-9285-CFA5E660C6B5@zytor.com>
References: <20200714190427.4332-1-hch@lst.de> <20200714190427.4332-19-hch@lst.de> <20200727030534.GD795125@ZenIV.linux.org.uk> <F3DAF5DA-82C2-4833-805D-4F54F7C4326E@zytor.com> <20200727062425.GA2005@lst.de>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20200727062425.GA2005@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Al Viro <viro@zeniv.linux.org.uk>, linux-kernel@vger.kernel.org, Song Liu <song@kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-raid@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: linux-raid.ids

On July 26, 2020 11:24:25 PM PDT, Christoph Hellwig <hch@lst=2Ede> wrote:
>On Sun, Jul 26, 2020 at 11:20:41PM -0700, hpa@zytor=2Ecom wrote:
>> On July 26, 2020 8:05:34 PM PDT, Al Viro <viro@zeniv=2Elinux=2Eorg=2Euk=
>
>wrote:
>> >On Tue, Jul 14, 2020 at 09:04:22PM +0200, Christoph Hellwig wrote:
>> >> Don't rely on the implicit set_fs(KERNEL_DS) for ksys_open to
>work,
>> >but
>> >> instead open a struct file for /dev/console and then install it as
>FD
>> >> 0/1/2 manually=2E
>> >
>> >I really hate that one=2E  Every time we exposed the internal details
>to
>> >the fucking early init code, we paid for that afterwards=2E  And this
>> >goes over the top wrt the level of details being exposed=2E
>> >
>> >_IF_ you want to keep that thing, move it to fs/file=2Ec, with dire
>> >comment
>> >re that being very special shite for init and likely cause of
>> >subsequent
>> >trouble whenever anything gets changed, a gnat farts somewhere, etc=2E
>> >
>> >	Do not leave that kind of crap sitting around init/*=2Ec; KERNEL_DS
>> >may be a source of occasional PITA, but here you are trading it for
>a
>> >lot
>> >worse one in the future=2E
>>=20
>> Okay=2E=2E=2E here is a perhaps idiotic idea=2E=2E=2E even if we don't =
want to
>run stuff in actual user space, could we map initramfs into user space
>memory before running init (execing init will tear down those mappings
>anyway) so that we don't need KERNEL_DS at least?
>
>Err, why?  The changes have been pretty simple, and I'd rather not come
>up with new crazy ways just to make things complicated=2E

Why? To avoid this neverending avalanche of special interfaces and layerin=
g violations=2E Neatly deals with non-contiguous contents and initramfs in =
device memory, etc=2E etc=2E etc=2E


--=20
Sent from my Android device with K-9 Mail=2E Please excuse my brevity=2E
