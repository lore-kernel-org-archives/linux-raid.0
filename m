From: "G. Michael Carter" <mikey@carterfamily.ca>
Subject: Re: mdsadm -A won't assemble my array
Date: Mon, 9 Feb 2015 18:05:19 -0500
Message-ID: <CANjusZcnX=BArJJLMiBN4hfzRRLdUtD6mSq-mDZ6OhPB=KMX3w@mail.gmail.com>
References: <CANjusZesi-8zxpZ9rCOEToSXwFoiApeN-ivO51qY=80R6_xb_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANjusZesi-8zxpZ9rCOEToSXwFoiApeN-ivO51qY=80R6_xb_g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

After doing a lot more reading... I think I'm getting down to running
something like this.  assemble force isn't doing much.

mdadm --create --assume-clean --level=5 --verbose --chunk 512K
--raid-devices=4 /dev/md3 /dev/sdb /dev/sdk /dev/sdo /dev/sdp

But as per the big warning... says to check with you guys first, also
need help writing the command (since it seems to be a one shot type
thing)

Here's the key information I think I need from the examine:

Raid level: 5
Chunk Size: 512K
Used Dev Size: 7813774336
/dev/sdb: AA..   (state: clean - active device 0)
/dev/sdk: AAAA   (state: active - active device 1)
/dev/sdo: A.AA   (state: clean  - active device 2)
/dev/sdp: A.AA   (state: clean - active device 3)

thanks

On Mon, Feb 9, 2015 at 3:21 PM, G. Michael Carter <mikey@carterfamily.ca> wrote:
> Some time last night my machine had a kernel panic.  Two of the arrays
> didn't start up.
>
> One I managed to fix as a mdadm -E clued me in that three of the
> drives were ok.  So I just reassembled the three and added the fourth.
> Then it just started no problem.
>
> My big array however I'm not so lucky.
>
> I've got a state of
>
>
> Raid level: 5
> /dev/sdb: AA..   (state: clean)
> /dev/sdk: AAAA   (state: active)
> /dev/sdo: A.AA   (state: clean)
> /dev/sdp: A.AA   (state: clean)
>
> Thus can only get two drives to match in any config.  How do I get out
> of this mess?



-- 

G. Michael Carter
Contact: H: 1-519-940-8935 | W: 1-905-267-8494 | M: 1-519-215-1869 |
F: 1-519-941-0009
Google Talk: xmpp:mikeycarter1974@gmail.com
