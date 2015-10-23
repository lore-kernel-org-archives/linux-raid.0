From: Marek <mlf.conv@gmail.com>
Subject: Re: Fwd: manually destriping a 4 drive raid5 with one missing drive
Date: Fri, 23 Oct 2015 22:46:48 +0200
Message-ID: <CA+sqOsYVGyCVKoRYAvgsL57tHhZn6+RaLK_7bzrUHvVK2XUNPA@mail.gmail.com>
References: <CA+sqOsbjE4MLa7NXG6hxpzE1m-ZNbcJVNjK51WKCQMhwNgimhg@mail.gmail.com>
	<87fv19m7he.fsf@notabene.neil.brown.name>
	<CA+sqOsZJbvyAW6=CSG5EikhmDPt+Onjpm+VvBNPMKFmVi-ZQ8g@mail.gmail.com>
	<CA+sqOsZfjz0wTei+6qiv+zxXt7TA_GMO8EQ=v0EeDGFpqLrWRg@mail.gmail.com>
	<20151023155324.GA2555@lazy.lzy>
	<CA+sqOsYBbOwn5tJfygAR0MDCQPpd4w61XPGBLv8Mme8cT_HL8A@mail.gmail.com>
	<CA+sqOsY1Q4e3vNy4rmqjndsOStSGOg4JpqWBm4TTEvRdOmTkbQ@mail.gmail.com>
	<562A7333.9010702@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <562A7333.9010702@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

dd from mdX doesn't work i tried it even with testdisk, what you get
is mixed up data, incomplete files.

{ Google mail on iPad doesn't support plain text, who knew :/ }

On Fri, Oct 23, 2015 at 7:49 PM, Phil Turmel <philip@turmel.org> wrote:
> On 10/23/2015 12:20 PM, Marek wrote:
>> Not sure if it's destrip or destripe but it's basically like puzzle
>> you take a block from each drive according to the layout you are using
>> e.g. Left symmetric and then write it down in that order computing
>> missing blocks from parity blocks - this way you would write an image
>> which you can mount without using mdadm. Data restoration companies
>> are using this technique.
>
> No special tool required.  Obtain a new drive big enough to hold your
> entire array and 'dd' from /dev/mdX to your new drive.
>
> { BTW: convention on kernel.org is to reply-to-all, trim unnecessary
> context, and either bottom post or interleave your reply. }
>
> Phil
