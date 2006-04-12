From: johnny@navtek.no
Subject: Re: failed to RUN_ARRAY, input/output error
Date: Wed, 12 Apr 2006 10:42:01 +0200 (CEST)
Message-ID: <45665.84.236.149.243.1144831321.squirrel@www.navtek.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>> State: active
>
>> Number Major Minor RaidDevice State
>> 0 3  2 0 active sync /dev/hda2
>> 1 22 2 1 active sync /dev/hdc2
>> 2 0  0 2 faulty removed
>> 3 34 1 3 active sync /dev/hdg1
>
> active and degraded is a bad combination.  There is a small
> possibility of undetectable data corruption.
> I wonder why the system froze - that would contribute to the 'active'.

I'm not quite sure, but I noticed a looong list of smbd processes running
so I tried to do a smb restart command, but that led to the freeze. I
could ping it but not log in.

> Add a '--force' to the '--assemble' and it will start the array for you.

I've tried that but it gives a Input/output error as well.
No luck trying to mount it either, but I guess that doesn't come as a
surprise.

Johnny





