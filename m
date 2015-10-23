From: Marek <mlf.conv@gmail.com>
Subject: Fwd: manually destriping a 4 drive raid5 with one missing drive
Date: Fri, 23 Oct 2015 11:26:12 +0200
Message-ID: <CA+sqOsZfjz0wTei+6qiv+zxXt7TA_GMO8EQ=v0EeDGFpqLrWRg@mail.gmail.com>
References: <CA+sqOsbjE4MLa7NXG6hxpzE1m-ZNbcJVNjK51WKCQMhwNgimhg@mail.gmail.com>
	<87fv19m7he.fsf@notabene.neil.brown.name>
	<CA+sqOsZJbvyAW6=CSG5EikhmDPt+Onjpm+VvBNPMKFmVi-ZQ8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sqOsZJbvyAW6=CSG5EikhmDPt+Onjpm+VvBNPMKFmVi-ZQ8g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I have a 4 2TB disk  raid5 512k 1.2.
one of the drives was accidentally wiped by ubuntu installation
(/dev/sda, first drive). The system has been rebooted forcefully
several times before this happened. Raid wouldn't come up after that.
The first drive has been -add ed back and a resync has been enforced.
What i'd like to do is to manually destrip the raid.

On Sun, Oct 18, 2015 at 12:54 AM, Neil Brown <nfbrown@novell.com> wrote:
> Marek <mlf.conv@gmail.com> writes:
>
>> hi,
>>
>> i'd like to ask whether manual  destriping of a 4 drive raid5 is
>> possible even though the parity information is lost due to forced
>> resync of all four drives.
>>
>
> I'm sorry but I have no idea what you are asking.
> Maybe if you provided more details about your current circumstances, how
> you got into that situation, and what outcome you are hoping for, then I
> might be able to help.
>
> NeilBrown
