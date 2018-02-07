From: Liwei <xieliwei@gmail.com>
Subject: Re: Buffer I/O error... async page read
Date: Wed, 7 Feb 2018 15:02:37 +0800
Message-ID: <CAPE0SYzi53vnV-rPtRcfqphpO-KTNwEuP+3yYcsk+Cmu9p-hGg@mail.gmail.com>
References: <CAPE0SYxDgs6NY_ZALVY5kB5a-vrpK1GQvqqtf60gjCCmn2eP8g@mail.gmail.com>
 <CAPE0SYxdUMivzCv++RaHWt90QkMBBV-oCAiGjMUxVsWdezS0mg@mail.gmail.com> <0a503f71-72ff-7744-f513-ecccccd30782@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <0a503f71-72ff-7744-f513-ecccccd30782@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Weedy <weedy2887@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 7 February 2018 at 14:27, Weedy <weedy2887@gmail.com> wrote:
> On 2018-02-06 08:55 AM, Liwei wrote:
>> Just answering my question. Turns out the I/O errors are caused by the
>> MD bad blocks log. There wasn't an easy way to clear the log unless I
>> wrote over the supposedly bad blocks.
>>
>
> All you needed to do was "--assemble --update=no-bbl".
>
> Neil just posted to the list a couple days ago about this for someone else.

*Facepalms* Clearly my google-fu isn't good enough. Maybe someone with
access to the wiki can add a page on the bad blocks list?

I was referring to the metadata formats
"https://raid.wiki.kernel.org/index.php/RAID_superblock_formats" page
while trying to figure things out and noticed that it too is outdated.
I'm willing to help update the wiki in whatever ways I can if someone
can approve my account.
