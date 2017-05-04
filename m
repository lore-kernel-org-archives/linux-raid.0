From: Milan Broz <gmazyland@gmail.com>
Subject: Re: DM_INTEGRITY Kconfig help (was: Re: dm: add integrity target)
Date: Thu, 4 May 2017 09:31:00 +0200
Message-ID: <6988fc7b-1ab4-4c7a-c7c9-121271ddd970@gmail.com>
References: <CAMuHMdWafrUq0tbHsOS2Gm579Amv0LpYAqk=Kqg4t8fqgbWDgw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMuHMdWafrUq0tbHsOS2Gm579Amv0LpYAqk=Kqg4t8fqgbWDgw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Geert Uytterhoeven <geert@linux-m68k.org>, Mikulas Patocka <mpatocka@redhat.com>, Mike Snitzer <snitzer@redhat.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 05/04/2017 08:03 AM, Geert Uytterhoeven wrote:
>> +config DM_INTEGRITY
>> +       tristate "Integrity target"
>> +       depends on BLK_DEV_DM
>> +       select BLK_DEV_INTEGRITY
>> +       select DM_BUFIO
>> +       select CRYPTO
>> +       select ASYNC_XOR
>> +       ---help---
>> +          This is the integrity target.
> 
> Which is...?
> 
> Can you please extend the help message for the uneducated?

Yes, sorry, this is our oversight.

Mike already promised that this text will be extended in the next patchset.

For now you can find the description in documentation
Documentation/device-mapper/dm-integrity.txt

"The dm-integrity target emulates a block device that has additional
per-sector tags that can be used for storing integrity information."

(The major designed use case is for providing metadata space for tags
for authenticated encryption in dm-crypt but it can be used also as
a standalone target.)

Thanks,
Milan
