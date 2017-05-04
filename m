From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: DM_INTEGRITY Kconfig help (was: Re: dm: add integrity target)
Date: Thu, 4 May 2017 08:03:19 +0200
Message-ID: <CAMuHMdWafrUq0tbHsOS2Gm579Amv0LpYAqk=Kqg4t8fqgbWDgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mikulas Patocka <mpatocka@redhat.com>, Milan Broz <gmazyland@gmail.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, May 3, 2017 at 7:43 PM, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Web:        https://git.kernel.org/torvalds/c/7eada909bfd7ac90a4522e56aa3179d1fd68cd14
> Commit:     7eada909bfd7ac90a4522e56aa3179d1fd68cd14
> Parent:     400a0befc96240f7bb2a53b9622deffd55d385fe
> Refname:    refs/heads/master
> Author:     Mikulas Patocka <mpatocka@redhat.com>
> AuthorDate: Wed Jan 4 20:23:53 2017 +0100
> Committer:  Mike Snitzer <snitzer@redhat.com>
> CommitDate: Fri Mar 24 15:49:07 2017 -0400
>
>     dm: add integrity target
>
>     The dm-integrity target emulates a block device that has additional
>     per-sector tags that can be used for storing integrity information.
>
>     A general problem with storing integrity tags with every sector is that
>     writing the sector and the integrity tag must be atomic - i.e. in case of
>     crash, either both sector and integrity tag or none of them is written.
>
>     To guarantee write atomicity the dm-integrity target uses a journal. It
>     writes sector data and integrity tags into a journal, commits the journal
>     and then copies the data and integrity tags to their respective location.
>
>     The dm-integrity target can be used with the dm-crypt target - in this
>     situation the dm-crypt target creates the integrity data and passes them
>     to the dm-integrity target via bio_integrity_payload attached to the bio.
>     In this mode, the dm-crypt and dm-integrity targets provide authenticated
>     disk encryption - if the attacker modifies the encrypted device, an I/O
>     error is returned instead of random data.
>
>     The dm-integrity target can also be used as a standalone target, in this
>     mode it calculates and verifies the integrity tag internally. In this
>     mode, the dm-integrity target can be used to detect silent data
>     corruption on the disk or in the I/O path.
>
>     Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
>     Signed-off-by: Milan Broz <gmazyland@gmail.com>
>     Signed-off-by: Mike Snitzer <snitzer@redhat.com>

> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
> @@ -500,4 +500,14 @@ config DM_LOG_WRITES
>
>           If unsure, say N.
>
> +config DM_INTEGRITY
> +       tristate "Integrity target"
> +       depends on BLK_DEV_DM
> +       select BLK_DEV_INTEGRITY
> +       select DM_BUFIO
> +       select CRYPTO
> +       select ASYNC_XOR
> +       ---help---
> +          This is the integrity target.

Which is...?

Can you please extend the help message for the uneducated?
Thanks!

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
