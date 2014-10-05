From: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Subject: Re: Hot replacing device in RAID 6
Date: Sun, 05 Oct 2014 11:30:08 -0700
Message-ID: <gaf8gbxi4k.ln2@goaway.wombat.san-francisco.ca.us>
References: <CAAOsTSmn3MDn-a6usUTpmBObwYngvFNNRUXXF6zhmDKyUTHU_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2014-10-05, Patrik Horn=EDk <patrik@dsl.sk> wrote:
>
> - We discussed couple of years ago hot replacing the drive. I see it
> is now supported in mdadm. Is it rock stable and can be used on
> production data?

I have used replace a handful of times with great success and no
problems.  I have not had to shut down the array during the rebuild
operation, however.  I suspect (but have no direct evidence) that a
clean shutdown should be fine.  I used kernel 3.9 from ELRepo for
the replace.

--keith


--=20
kkeller@wombat.san-francisco.ca.us


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
