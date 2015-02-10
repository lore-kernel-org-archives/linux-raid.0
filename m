From: Phil Turmel <philip@turmel.org>
Subject: Re: mdsadm -A won't assemble my array
Date: Mon, 09 Feb 2015 19:13:48 -0500
Message-ID: <54D94D3C.3060808@turmel.org>
References: <CANjusZesi-8zxpZ9rCOEToSXwFoiApeN-ivO51qY=80R6_xb_g@mail.gmail.com> <CANjusZcnX=BArJJLMiBN4hfzRRLdUtD6mSq-mDZ6OhPB=KMX3w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANjusZcnX=BArJJLMiBN4hfzRRLdUtD6mSq-mDZ6OhPB=KMX3w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "G. Michael Carter" <mikey@carterfamily.ca>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Michael,

[Convention on kernel.org is reply-to-all, to trim replies and to
bottom-post, or interleave your reply]

On 02/09/2015 06:05 PM, G. Michael Carter wrote:
> On Mon, Feb 9, 2015 at 3:21 PM, G. Michael Carter <mikey@carterfamily.ca> wrote:
>> Some time last night my machine had a kernel panic.  Two of the arrays
>> didn't start up.
>>
>> One I managed to fix as a mdadm -E clued me in that three of the
>> drives were ok.  So I just reassembled the three and added the fourth.
>> Then it just started no problem.
>>
>> My big array however I'm not so lucky.
>>
>> I've got a state of
>>
>>
>> Raid level: 5
>> /dev/sdb: AA..   (state: clean)
>> /dev/sdk: AAAA   (state: active)
>> /dev/sdo: A.AA   (state: clean)
>> /dev/sdp: A.AA   (state: clean)

Please show us *all* of your mdadm -E output for this array.  Pasted
inline is preferred.  Also show a map of your device names versus drive
serial numbers.  An excerpt from "ls -l /dev/disk/by-id/" will do.  You
have many drives, and the kernel doesn't guarantee consistent naming.

>> Thus can only get two drives to match in any config.  How do I get out
>> of this mess?

> After doing a lot more reading... I think I'm getting down to running
> something like this.  assemble force isn't doing much.

This throwaway line is critical.  --assemble --force is the right answer
to this situation, and if its not working, something else should be
investigated.  Do *not* use --create.

Show your kernel and mdadm versions.  Show the content of /proc/mdstat.
 Show the output of:

mdadm --assemble --force --verbose /dev/mdX /dev/sd[bkop]

and the tail of "dmesg" that corresponds to the above.

> mdadm --create --assume-clean --level=5 --verbose --chunk 512K
> --raid-devices=4 /dev/md3 /dev/sdb /dev/sdk /dev/sdo /dev/sdp
>
> But as per the big warning... says to check with you guys first, also
> need help writing the command (since it seems to be a one shot type
> thing)
>
> Here's the key information I think I need from the examine:
>
> Raid level: 5
> Chunk Size: 512K
> Used Dev Size: 7813774336
> /dev/sdb: AA..   (state: clean - active device 0)
> /dev/sdk: AAAA   (state: active - active device 1)
> /dev/sdo: A.AA   (state: clean  - active device 2)
> /dev/sdp: A.AA   (state: clean - active device 3)

Oh, and this isn't nearly enough information to advise on --create, in
the remote chance it turns out to be the right answer.

Phil

