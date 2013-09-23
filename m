From: Phil Turmel <philip@turmel.org>
Subject: Re: raid10 recovery assistance requested
Date: Sun, 22 Sep 2013 23:27:13 -0400
Message-ID: <523FB511.5070001@turmel.org>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com> <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com> <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com> <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com> <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com> <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com> <523FAD81.9070005@turmel.org> <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Gomboc <dave_gomboc@acm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/22/2013 11:19 PM, Dave Gomboc wrote:
> [snipped]
>> However, based on the data you've reported, sda1 and sdc1 are identical,
>> down to the superblock bytes.  And sdb1 and sdd1 are also identical,
>> down to the superblock bytes.
>>
>> Are you sure there were no misdirected "dd" operations?
>>
>> Phil
> 
> I did not start using ddrescue until after I was no longer able to
> boot the raid array.  When I did the ddrescuing, I specifically used
> the /dev/disk/by-id symlinks, not the sdX names, precisely in order to
> avoid accidents.  I was extremely alarmed by the inability to boot the
> raid10, and took extra care to make sure I was doing it properly.

Ok.

If you'll generate the following for each member, we'll see what we can do:

dd if=/dev/sdX1 bs=512 skip=2048 count=16 2>/dev/null |hexdump -C
dd if=/dev/sdX1 bs=512 skip=3072 count=16 2>/dev/null |hexdump -C

(These will be smaller than the other report...  which didn't make it to
the list.)

Phil
