From: maurice <mhilarius@gmail.com>
Subject: Re: Rotating RAID 1
Date: Mon, 15 Aug 2011 22:36:18 -0600
Message-ID: <4E49F3C2.8090009@gmail.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com> <4E497FB5.3030109@ivitera.com> <CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com> <4E49849E.4030604@ivitera.com> <20110816084251.2d8e7831@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110816084251.2d8e7831@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Pavel Hofman <pavel.hofman@ivitera.com>, =?ISO-8859-1?Q?J=E9r=F4me_?= =?ISO-8859-1?Q?Poulin?= <jeromepoulin@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/15/2011 4:42 PM, NeilBrown wrote:
> ..I'm not sure from you description whether the following describes 
> exactly
> what you are doing or not, but this is how I would do it.
> As you say, you need two bitmaps.
> So if there are 3 drives A, X, Y where A is permanent and X and Y are 
> rotated off-site,
> then I create two RAID1s like this:
>   mdadm -C /dev/md0 -l1 -n2 --bitmap=internal /dev/A /dev/X
>   mdadm -C /dev/md1 -l1 -n2 --bitmap=internal /dev/md0 /dev/Y
>
>   mkfs /dev/md1; mount /dev/md1 ...
>
> Then you can remove either or both of X and Y and which each is 
> re-added it will
> recover just the blocks that it needs.
> X from the bitmap of md0, Y from the bitmap of md1.
>
> NeilBrown


How elegantly described.

After so many instances of being told "You should not use RAID as a 
backup device like that!"
it is pleasant to hear you detail the "right way" to do this.

Thank you very much for that Neil.


-- 
Cheers,
Maurice Hilarius
eMail: /mhilarius@gmail.com/
