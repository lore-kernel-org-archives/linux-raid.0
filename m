From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: moving arrays from MBR part table install to GPT? Possible?
Date: Mon, 17 Aug 2015 15:32:26 +0100
Message-ID: <55D1F07A.7090709@youngman.org.uk>
References: <55D02E2E.1080909@suddenlinkmail.com> <55D081C3.4090604@youngman.org.uk> <55D17EF7.8000203@suddenlinkmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <55D17EF7.8000203@suddenlinkmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David C. Rankin" <drankinatty@suddenlinkmail.com>, mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 17/08/15 07:28, David C. Rankin wrote:
> On 08/16/2015 07:27 AM, Wols Lists wrote:
>> If you want to add new drives, you can use GPT on them, as I say, if
>> they're large disks, you'll need to use GPT.
>>
>> Sounds like it's a small system, a home system? If you get new drives,
>> make sure they're proper raid drives, like WD Red. I've got Seagate
>> Barracudas, which was a mistake ...
> 
> Thank you for your response. It is my office server, but it runs on 2 1T
> drives (Carvair Black) Have had good experiences with them. I toss at
> least 1 barracuda in the trash every 3-4 months.

Well, my experience with Barracudas has been good - they were my
preferred choice of drive ...

You saying Black rang alarm bells for me, and I've just looked on my
favourite sales site - it says they are DESKTOP drives!

YOU NEED TO CHECK THEM OUT WITH SMARTCTL!

Check if they support ERC etc. The Barracudas I know don't, the Reds
various people have said they do. If the blacks don't support it, then
they'll let you down when you need it. You really don't want to go raid
5 or 6 with drives that don't support it. I want to go raid 5, which is
why I'm gutted to discover I'll have to replace my Barracudas. imho
they're decent serviceable drives ...
> 
> I'll stick with MBR and see how it goes. In that case I'll just boot the
> install media and assemble the arrays and see what I end up with.
> 
> 
Yup. No real point going gpt until you get to 3 and 4TB drives. Once you
can get linux running, it shouldn't care what sort of drives you have,
but if you read the gentoo wiki pages about installing on raid
(disclaimer, I wrote a decent chunk of it), you'll see what a pig it can
be getting as far as loading linux ...

Cheers,
Wol
