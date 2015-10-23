From: Alexander Afonyashin <a.afonyashin@madnet-team.ru>
Subject: Re: manually destriping a 4 drive raid5 with one missing drive
Date: Fri, 23 Oct 2015 14:50:33 +0300
Message-ID: <CAETWcfsdhGqbbp7sAKDK_rMzji_hUupQYcTs6kF+1q5KBxoZKA@mail.gmail.com>
References: <CA+sqOsbjE4MLa7NXG6hxpzE1m-ZNbcJVNjK51WKCQMhwNgimhg@mail.gmail.com>
 <87fv19m7he.fsf@notabene.neil.brown.name> <CA+sqOsZJbvyAW6=CSG5EikhmDPt+Onjpm+VvBNPMKFmVi-ZQ8g@mail.gmail.com>
 <CA+sqOsZfjz0wTei+6qiv+zxXt7TA_GMO8EQ=v0EeDGFpqLrWRg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sqOsZfjz0wTei+6qiv+zxXt7TA_GMO8EQ=v0EeDGFpqLrWRg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marek <mlf.conv@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Marek,

First, check status of disk you would like to remove via:
- cat /proc/mdstat
- mdadm -D /dev/md0 (replace md0 with you md-raid identifier)

Regards,
Alexader

On Fri, Oct 23, 2015 at 12:26 PM, Marek <mlf.conv@gmail.com> wrote:
> I have a 4 2TB disk  raid5 512k 1.2.
> one of the drives was accidentally wiped by ubuntu installation
> (/dev/sda, first drive). The system has been rebooted forcefully
> several times before this happened. Raid wouldn't come up after that.
> The first drive has been -add ed back and a resync has been enforced.
> What i'd like to do is to manually destrip the raid.
>
> On Sun, Oct 18, 2015 at 12:54 AM, Neil Brown <nfbrown@novell.com> wrote:
>> Marek <mlf.conv@gmail.com> writes:
>>
>>> hi,
>>>
>>> i'd like to ask whether manual  destriping of a 4 drive raid5 is
>>> possible even though the parity information is lost due to forced
>>> resync of all four drives.
>>>
>>
>> I'm sorry but I have no idea what you are asking.
>> Maybe if you provided more details about your current circumstances, how
>> you got into that situation, and what outcome you are hoping for, then I
>> might be able to help.
>>
>> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
