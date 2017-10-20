From: sfunk1x <sfunk1x@gmail.com>
Subject: Re: MDADM RAID 6 Bad Superblock after reboot
Date: Thu, 19 Oct 2017 17:43:03 -0700
Message-ID: <e257fcc8-9773-a8a2-42bd-6030aef6329e@gmail.com>
References: <6a0f0e0b-6b03-8ec1-b02f-b17b0447aff8@gmail.com>
 <AA5FDF15-8966-4793-9215-2814C1A6848D@gmail.com>
 <59E7AE4B.5000903@youngman.org.uk>
 <63c30fde-d2df-bb92-d6c9-d231a955b5ce@gmail.com>
 <87zi8mg7mi.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87zi8mg7mi.fsf@notabene.neil.brown.name>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>, Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 10/19/2017 02:17 PM, NeilBrown wrote:

> Anything is better than nothing..  Can we get a photo of "mdadm
> --examine" output on one of the devices (e.g. /dev/sda1) ??
> 
> Also, what mdadm version (mdadm -V) and kernel version (uname -r)?

https://imgur.com/x2rZEl5

I included an --examine of sda1 and sdf.

> mdadm never tries to edit mdadm.conf.
> It does modify files in /run/mdadm (or maybe /var/run/mdadm).
> Can we get a photo of that audit log?

I was mistaken, I think. It looks like mdadm tried to read (??) the file
and the context for the file was not set properly:

https://imgur.com/5UvFExp

In order to "fix" the issue, I ran sealert against the audit.log and
followed it's instructions, producing a rules file.

> 
> I'm very suspicious of these new drives appearing to have not metadata.
> Can you
>    od -x /dev/sdf | head
>    od -x /dev/sdf | grep a92b
> and provide a photo of the output?

grep'ing a92b scrolled off the screen, so I grabbed a portion of it,
ctrl-c' and included head:

https://imgur.com/WDcAYBc

Thanks for the help so far.
