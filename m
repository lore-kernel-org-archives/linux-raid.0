From: Francesco Tomadin <inamaru94@gmail.com>
Subject: Re: WD nas broke can't accessmy files on RAID 1
Date: Sat, 21 Oct 2017 15:43:53 +0000
Message-ID: <CAKNaYNv0YXqMTN-1PGBpPYgQJ-5VLovhmLgA0WiR6T2Webj2mw@mail.gmail.com>
References: <CAKNaYNuY8gNn+u4uMK8U+AnnYMmH8GNPDJGWTG1SNrQpDG4kjA@mail.gmail.com>
 <bfbf59c2-c750-f87b-5167-37c84086bb75@youngman.org.uk> <CAKNaYNtK+-1JXmLQk0zcX1HrAiczVAoFCKTmJQuG5FexxwRGPg@mail.gmail.com>
 <CAKNaYNusb-iQN3V4an8Hs_s+gD4m_n4yC1o2=VxY081-T+SHNQ@mail.gmail.com>
 <001ecd43-c770-4abe-5ded-57377c843d5d@youngman.org.uk> <CAKNaYNugRX-kRZOLdE57gFnPyuLgDtVMbPp5qk_2CzZdUJqW4g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAKNaYNugRX-kRZOLdE57gFnPyuLgDtVMbPp5qk_2CzZdUJqW4g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anthony Youngman <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks to a guy on IRC after some check he told me to use

mdadm --assemble --scan
and IT worked! I can access again my drive!

Thanks for everythiing!

2017-10-21 14:38 GMT+00:00 Francesco Tomadin <inamaru94@gmail.com>:
>> Okay. Does this mean your NAS had four 4TB drives in it?
>>
>> You said one drive was in JBOD mode. Did you set it up this way, or is this
>> how it ended up after the failure? It looks to me as though this drive
>> failed, was kicked out of the array, and that's why you can access it in
>> JBOD. Any chance of you running "smartctl -x" on it? I strongly suspect that
>> will come back with "SCT/ERC not supported" :-( If it does that's great news
>> for recovering your array, but maybe bad news for your wallet :-)
>
> What you're seeing right now is one of the disk that were in RAID 1,
> with the jbod disk it's a different story, I just had to plug and play
> on linux and I could recover my data easily.
>
>> Okay. I'm puzzled. sdc1, the "linux swap" array, is clearly broken.
>> Hopefully, this is what's causing the whole thing to fall over, because if
>> we lose the contents of that we couldn't care less.
>>
>> sdc2, which I'm guessing is your data, looks healthy. Get the NAS working
>> properly, and that will just come straight back.
>>
>
> I would if I could but trust me I CAN'T! The nas just got a bug who
> made the cpu working like crazy and creating infinite folder, I could
> access that 2 days ago, but not anymore! it's just stuck! That's why I
> hoped I could mount the drive if someway.
>
>> As I say, try and get a "smartctl -x", but at this point I'll bow out and
>> let somebody who knows more than I do take over. But it does look VERY
>> promising.
>>
>
> Thanks a lot for trying! And thanks for your kind words :D
> I'll wait an answer from someone else.
