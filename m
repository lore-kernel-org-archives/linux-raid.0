From: Phil Turmel <philip@turmel.org>
Subject: Re: raid10 recovery assistance requested
Date: Sun, 22 Sep 2013 23:51:14 -0400
Message-ID: <523FBAB2.7070506@turmel.org>
References: <CA+dwz-3hWizOmbzBDBV3K4DPM1D3WUPRn_d63-FhS+5RZ-ffvQ@mail.gmail.com> <CA+dwz-2DUsx6JK=TYfKc8eGbAiHo2orhnBQv5HfOTNXAi9hv7g@mail.gmail.com> <523A7DB9.9070600@hardwarefreak.com> <CA+dwz-1=VQE1pgCctrdbvw99Qq2c_me1aYUJGU0E2sJ2Y-JdpA@mail.gmail.com> <CA+dwz-27furxUt=vQAhN8Va_gk3v545in3=kQVMG4eO5SqdCrQ@mail.gmail.com> <523F6692.9090407@turmel.org> <CA+dwz-36m6KDKbh9Gwxne8o-UyZuR2e5Z5-dKtOPS1XkA518yA@mail.gmail.com> <523F7C62.4040305@turmel.org> <CA+dwz-0eskPSQ44v0vgwfjwRpTbQaokQ3Q258Em1W2eRi1SO4w@mail.gmail.com> <523FAD81.9070005@turmel.org> <CA+dwz-2Me3g3udQh90k6EjCMjr+uqyoujCdMM9=tsKEnsmkzdA@mail.gmail.com> <523FB511.5070001@turmel.org> <CA+dwz-31yG3Y4xzmUoiMNtLw=q1pE_GTyNqSk5WBAsGDCGT9iw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+dwz-31yG3Y4xzmUoiMNtLw=q1pE_GTyNqSk5WBAsGDCGT9iw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Gomboc <dave_gomboc@acm.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 09/22/2013 11:34 PM, Dave Gomboc wrote:
>> If you'll generate the following for each member, we'll see what we can do:
>>
>> dd if=/dev/sdX1 bs=512 skip=2048 count=16 2>/dev/null |hexdump -C
>> dd if=/dev/sdX1 bs=512 skip=3072 count=16 2>/dev/null |hexdump -C

Ok.  I can't determine how the superblocks ended up the way they did,
but the first two chunks appear to follow the proper patterns.

I think you're best bet is to disconnect two of the drives, leaving one
that identifies as "0" and one that identifies as "3".

Then use "mdadm -Af /dev/mdX /dev/sdY1 /dev/sdZ1"

The "-f" will force the assembly without regard to the event counts.
Then you can take a backup.  Finally you can add devices as "new" ones
to rebuild back to full redundancy.  (Fix your timeouts before
attempting the latter.)

Phil
