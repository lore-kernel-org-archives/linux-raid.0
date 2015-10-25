From: Phil Turmel <philip@turmel.org>
Subject: Re: Fwd: manually destriping a 4 drive raid5 with one missing drive
Date: Sun, 25 Oct 2015 18:47:35 -0400
Message-ID: <562D5C07.40501@turmel.org>
References: <CA+sqOsbjE4MLa7NXG6hxpzE1m-ZNbcJVNjK51WKCQMhwNgimhg@mail.gmail.com>
 <87fv19m7he.fsf@notabene.neil.brown.name>
 <CA+sqOsZJbvyAW6=CSG5EikhmDPt+Onjpm+VvBNPMKFmVi-ZQ8g@mail.gmail.com>
 <CA+sqOsZfjz0wTei+6qiv+zxXt7TA_GMO8EQ=v0EeDGFpqLrWRg@mail.gmail.com>
 <20151023155324.GA2555@lazy.lzy>
 <CA+sqOsYBbOwn5tJfygAR0MDCQPpd4w61XPGBLv8Mme8cT_HL8A@mail.gmail.com>
 <CA+sqOsY1Q4e3vNy4rmqjndsOStSGOg4JpqWBm4TTEvRdOmTkbQ@mail.gmail.com>
 <562A7333.9010702@turmel.org>
 <CA+sqOsYVGyCVKoRYAvgsL57tHhZn6+RaLK_7bzrUHvVK2XUNPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sqOsYVGyCVKoRYAvgsL57tHhZn6+RaLK_7bzrUHvVK2XUNPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Marek <mlf.conv@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Marek,

On 10/23/2015 04:46 PM, Marek wrote:
> On Fri, Oct 23, 2015 at 7:49 PM, Phil Turmel <philip@turmel.org> wrote:
>> On 10/23/2015 12:20 PM, Marek wrote:
>>> Not sure if it's destrip or destripe but it's basically like puzzle
>>> you take a block from each drive according to the layout you are using
>>> e.g. Left symmetric and then write it down in that order computing
>>> missing blocks from parity blocks - this way you would write an image
>>> which you can mount without using mdadm. Data restoration companies
>>> are using this technique.
>>
>> No special tool required.  Obtain a new drive big enough to hold your
>> entire array and 'dd' from /dev/mdX to your new drive.

> dd from mdX doesn't work i tried it even with testdisk, what you get
> is mixed up data, incomplete files.

Well, that suggests you've done more than just a forced resync.  Pretty
much the only way to get this is to screw up the device order with
"mdadm --create --assume-clean"

You'll need to provide a great deal of data about your array and
precisely what you've done to it.

> { Google mail on iPad doesn't support plain text, who knew :/ }

{Top-posting fixed. Gmail screws this up by default, too.}

Phil
