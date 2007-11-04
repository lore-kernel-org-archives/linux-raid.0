From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Sun, 4 Nov 2007 16:51:46 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
 <18222.16003.92062.970530@notabene.brown>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18222.16003.92062.970530@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Mon, 5 Nov 2007, Neil Brown wrote:

> On Sunday November 4, jpiszcz@lucidpixels.com wrote:
>> # ps auxww | grep D
>> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
>> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [pdflush]
>> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [pdflush]
>>
>> After several days/weeks, this is the second time this has happened, while
>> doing regular file I/O (decompressing a file), everything on the device
>> went into D-state.
>
> At a guess (I haven't looked closely) I'd say it is the bug that was
> meant to be fixed by
>
> commit 4ae3f847e49e3787eca91bced31f8fd328d50496
>
> except that patch applied badly and needed to be fixed with
> the following patch (not in git yet).
> These have been sent to stable@ and should be in the queue for 2.6.23.2
>

Ah, thanks Neil, will be updating as soon as it is released, thanks.

Justin.

