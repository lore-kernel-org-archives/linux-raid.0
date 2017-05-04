From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: Re: DM_INTEGRITY Kconfig help (was: Re: dm: add integrity target)
Date: Thu, 4 May 2017 09:39:53 +0200
Message-ID: <CAMuHMdVLrENTe=KnCgjVU3=voohKTe3LLEohLt+=JZnJ5Uuqiw@mail.gmail.com>
References: <CAMuHMdWafrUq0tbHsOS2Gm579Amv0LpYAqk=Kqg4t8fqgbWDgw@mail.gmail.com>
 <6988fc7b-1ab4-4c7a-c7c9-121271ddd970@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <6988fc7b-1ab4-4c7a-c7c9-121271ddd970@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Milan Broz <gmazyland@gmail.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Milan,

On Thu, May 4, 2017 at 9:31 AM, Milan Broz <gmazyland@gmail.com> wrote:
> On 05/04/2017 08:03 AM, Geert Uytterhoeven wrote:
>>> +config DM_INTEGRITY
>>> +       tristate "Integrity target"
>>> +       depends on BLK_DEV_DM
>>> +       select BLK_DEV_INTEGRITY
>>> +       select DM_BUFIO
>>> +       select CRYPTO
>>> +       select ASYNC_XOR
>>> +       ---help---
>>> +          This is the integrity target.
>>
>> Which is...?
>>
>> Can you please extend the help message for the uneducated?
>
> Yes, sorry, this is our oversight.
>
> Mike already promised that this text will be extended in the next patchset.

Thanks, good to know this is planned.

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
