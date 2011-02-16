From: Simon Mcnair <simonmcnair@gmail.com>
Subject: Re: Linux software RAID assistance
Date: Wed, 16 Feb 2011 22:44:11 +0000
Message-ID: <1377706586882297883@unknownmsgid>
References: <4D540F6C.6050904@gmail.com> <20110215155315.55d35b8e@notabene.brown>
 <4D5A92F3.1090004@turmel.org> <4D5BD678.2050200@gmail.com>
 <4D5BE119.7000804@turmel.org> <4D5C0E17.3060306@gmail.com>
 <4D5C140F.9010301@turmel.org> <4D5C1508.3040308@gmail.com>
 <4D5C15D3.1070608@turmel.org> <4D5C167C.7000101@turmel.org>
 <4D5C1CF8.1020507@gmail.com> <4D5C1E0B.9060300@turmel.org>
 <4D5C2061.4060106@gmail.com> <4D5C2143.3000907@turmel.org>
 <4D5C2260.3020800@gmail.com> <4D5C273E.7020609@turmel.org>
 <4D5C4176.80604@gmail.com> <4D5C4204.5020106@turmel.org>
Mime-Version: 1.0 (iPhone Mail 8A306)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5C4204.5020106@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I just went to bed and one last question popped in to my mind. Since
there is a fair timezone gap I thought I'd be presumptuous and ask it
in the hope I can turn it around a bit quicker in the morning.

My suspicion is that once I have 5 formatted 2tb drives I may be lucky
to get 10x 1tb dd images on to it. Can I feed the dd process in to
tar, bzip2, zip or something else which will give me enough space to
fit the images on ?

Will I get more usable space from 5x2tb partitions or from 1xspanned
volume ? (the thecus pretty much only allows you to create raid
volumes so a jbod needs to be 5x1tb arrays or 1 spanned volume or
stripe).

TIA
Simon

On 16 Feb 2011, at 21:30, Phil Turmel <philip@turmel.org> wrote:

> On 02/16/2011 04:28 PM, Simon McNair wrote:
>> Phil,
>> Jeez I'm having a bad week (my windows 7x64 machine has just started randomly crashing, my Thecus n5200 is playing up and the weather has been dire so I've not been able to put my new shed up...oh and I have ongoing 'other' issues as you're well aware ;-))  The thecus n5200 has 5x2TB hdd's.  I wiped out the existing raid5 array to create a jbod span of 10tb in order to hold my 9tb of backups.  The Thecus has had a hissy fit and I've had to set the process off again, so you can bet it'll be a day or two before it get's the drives formatted (it's not a very powerful nas), then I'll do the backups, then I'll try as you suggested.
>
> That's fine.
>>
>> Thanks for the ongoing assistance.
>
> No problem.
>
> Phil
