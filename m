From: "Jonathan Harker (Jesusaurus)" <jesusaurus@gentlydownthe.net>
Subject: Re: Help recovering an interrupted raid0 reshape
Date: Mon, 6 Apr 2015 22:14:56 -0700
Message-ID: <CAC_83AFo47Zfe7rMqro7_k8dR-xpMcfiwQA7a9DTKpKPuHr=fA@mail.gmail.com>
References: <CAC_83AFDEijn-7gNmnWNNabzcuPRMabNwr8xfRFt0xacsvZfog@mail.gmail.com>
	<20150407094608.4a9dd142@notabene.brown>
	<20150407115033.1d63b65c@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150407115033.1d63b65c@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 6, 2015 at 6:50 PM, NeilBrown <neilb@suse.de> wrote:
> On Tue, 7 Apr 2015 09:46:08 +1000 NeilBrown <neilb@suse.de> wrote:
>
>> On Fri, 3 Apr 2015 19:22:15 -0700 "Jonathan Harker (Jesusaurus)"
>> <jesusaurus@gentlydownthe.net> wrote:
>>
>> >
>> > Third, is it possible to resume the reshape? If not, can it be reverted?
>> >
>>
>> I'll have to get back to you on that.  Hopefully you can be patient a little
>> longer.
>>
>> NeilBrown
>>

Thanks for taking the time to look into this. I've managed to be
patient with the problem for about a week now (I was cautiously poking
and prodding the array for a few days before reaching out to this
list) so I think I can manage a little more patience.

>>
>
> Hi again Jonathan,
>  please report what version of mdadm and of Linux that you are running.

My mdadm version is "mdadm - v3.3.1 - 5th June 2014" and my linux
version (according to `uname -r`) is 3.16.2-3.

>
> Also is there any chance that you tried
>    mdadm --assemble .... --update=revert-reshape
> ??
> And if you did, why didn't you say so :-)

During those first couple days I tried a couple assemble and
incremental commands to try to get the reshape to restart, though I
don't remember exactly what they were. It's possible I tried something
as scary and irreversible as --update=revert-reshape in some desperate
haze, so let's assume I did, but I was trying hard to avoid any advice
that included --force in the command.

>
> NeilBrown

Thanks again for looking into this, and let me know if there is any
other useful information I can provide.

-- 
Jonathan
