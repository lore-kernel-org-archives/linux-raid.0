From: Alfred Matthews <asm13243546@gmail.com>
Subject: Re: on assembly and recovery of a hardware RAID
Date: Mon, 20 Mar 2017 17:42:05 -0400
Message-ID: <CAAZLhTcNsjzLdEZyzG+kEuDhVye8pnuf6VhWzP=G0NL_aFX-5w@mail.gmail.com>
References: <CAAZLhTdaVM4fagN5=bqWpPx-DjyU6UZ69bJFf51FWMX7oeyJNw@mail.gmail.com>
 <87tw6weubu.fsf@notabene.neil.brown.name> <CAAZLhTcEhn2GezDSDJHOLv2VNSynzT-he0FRrVNbz1xtakLsMQ@mail.gmail.com>
 <87d1djdz8y.fsf@notabene.neil.brown.name> <CAAZLhTdn6xnB6Kuuhf8+VaSd5u6gekUSDSMnK+w5obZNxvNg8A@mail.gmail.com>
 <CAAZLhTcoU232uBs2zcK6TFj67Jru5oeNE_F0T2fQR6Un66OPXA@mail.gmail.com> <87lgs0cy0e.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87lgs0cy0e.fsf@notabene.neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> *** Checking Backup Volume Header:
>> Unexpected Volume signature '  ' expected 'H+'
>
> Here the backup volume header, which is 2 blocks (blocks are 8K) from
> the end of the device, looks wrong.
> This probably means the chunk size is wrong.
> I would suggest trying different chunksizes, starting at 4K and
> doubling, until this message goes away.
> That still might not be the correct chunk size, so I would continue up
> to several megabytes and find all the chunksizes that seem to work.
> Then look at what else hpfsck says on those.

I'm not actually able to generate happy output in hpfsck using any of
the following multiples of 4K

4
[...]
8192
16384
32768
65536
131072
262144
524288
1048576
2097152

Any chance it's not really an HFS system at all?
