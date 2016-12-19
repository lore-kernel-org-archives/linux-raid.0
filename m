From: =?UTF-8?Q?Jure_Erzno=C5=BEnik?= <jure.erznoznik@gmail.com>
Subject: Re: Fwd: (user) Help needed: mdadm seems to constantly touch my disks
Date: Mon, 19 Dec 2016 08:12:18 +0100
Message-ID: <CAJ=9zidt_25tCF8QBy0To9oY+QNVD1ufF+CQ-pSjD97zVaLoGg@mail.gmail.com>
References: <CAJ=9zicFM+wOUhpdX1XEVm+y2gYoW3r2aTRj6gAcEkypxJULmA@mail.gmail.com>
 <871sxbz4yz.fsf@notabene.neil.brown.name> <CAJ=9zieRuTNiEGuB_RouqbdLGoxNkn09yiogR6rND84LtMdbxA@mail.gmail.com>
 <CAJ=9zifGPd+3YnP1aLwLPXjtpygRc9DsDP37CNz-VHBHn1vDOg@mail.gmail.com>
 <87inqgvpyj.fsf@notabene.neil.brown.name> <CAJ=9zidNV4sPj7KC7_mJEo8+=-YTKyWD5RiLsGG9p33CV12Qdg@mail.gmail.com>
 <87twa0tvma.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87twa0tvma.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have made two blktraces at the same time: one for md0 and one for a
member of the array. I hope they will show something sensible.

I dropped them here:
http://expirebox.com/download/ee081fa4f85ffbd0bfad68e4ee257e11.html

The file will be available for 48 hours or so they say.

LP,
Jure

On Mon, Dec 19, 2016 at 5:01 AM, NeilBrown <neilb@suse.com> wrote:
> [please remember to keep linux-raid cc:ed]
>
> On Mon, Dec 19 2016, Jure Erzno=C5=BEnik wrote:
>
>> I wrote this in OP: iosnoop shows COMM=3D[idle, md0_raid5, kworker] as
>> processes working on the disk. Blocks reported are 8, 16 (data size a
>> few KB) and 18446744073709500000 (data size 0). That last one must be
>> some virtual thingie as the disks are nowhere near that large.
>>
>> Does this answer the question or did you mean something else?
>
> Maybe if you just make the blktrace logs available somewhere and I will
> look at them myself.
>
> NeilBrown
