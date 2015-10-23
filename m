From: Marek <mlf.conv@gmail.com>
Subject: Fwd: manually destriping a 4 drive raid5 with one missing drive
Date: Fri, 23 Oct 2015 18:20:17 +0200
Message-ID: <CA+sqOsY1Q4e3vNy4rmqjndsOStSGOg4JpqWBm4TTEvRdOmTkbQ@mail.gmail.com>
References: <CA+sqOsbjE4MLa7NXG6hxpzE1m-ZNbcJVNjK51WKCQMhwNgimhg@mail.gmail.com>
	<87fv19m7he.fsf@notabene.neil.brown.name>
	<CA+sqOsZJbvyAW6=CSG5EikhmDPt+Onjpm+VvBNPMKFmVi-ZQ8g@mail.gmail.com>
	<CA+sqOsZfjz0wTei+6qiv+zxXt7TA_GMO8EQ=v0EeDGFpqLrWRg@mail.gmail.com>
	<20151023155324.GA2555@lazy.lzy>
	<CA+sqOsYBbOwn5tJfygAR0MDCQPpd4w61XPGBLv8Mme8cT_HL8A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sqOsYBbOwn5tJfygAR0MDCQPpd4w61XPGBLv8Mme8cT_HL8A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Not sure if it's destrip or destripe but it's basically like puzzle
you take a block from each drive according to the layout you are using
e.g. Left symmetric and then write it down in that order computing
missing blocks from parity blocks - this way you would write an image
which you can mount without using mdadm. Data restoration companies
are using this technique.


On Friday, October 23, 2015, Piergiorgio Sartor
<piergiorgio.sartor@nexgo.de> wrote:
>
> On Fri, Oct 23, 2015 at 11:26:12AM +0200, Marek wrote:
> > I have a 4 2TB disk  raid5 512k 1.2.
> > one of the drives was accidentally wiped by ubuntu installation
> > (/dev/sda, first drive). The system has been rebooted forcefully
> > several times before this happened. Raid wouldn't come up after that.
> > The first drive has been -add ed back and a resync has been enforced.
> > What i'd like to do is to manually destrip the raid.
>
> Hi Marek,
>
> excuse my ignorance, but what does it mean "destrip" a RAID?
>
> Could you please point to some technical reference or, maybe,
> spend few more words to clarify the concept?
>
> Thanks,
>
> bye,
>
> --
>
> piergiorgio
