From: =?UTF-8?Q?Dragan_Milivojevi=C4=87?= <galileo@pkm-inc.com>
Subject: Re: Fwd: manually destriping a 4 drive raid5 with one missing drive
Date: Fri, 23 Oct 2015 23:30:57 +0200
Message-ID: <CALtW_ahbUsxQ5MnqQcmROEVY2W=jW9XUWK5SnAEqzAbc4ByBQA@mail.gmail.com>
References: <CA+sqOsbjE4MLa7NXG6hxpzE1m-ZNbcJVNjK51WKCQMhwNgimhg@mail.gmail.com>
 <87fv19m7he.fsf@notabene.neil.brown.name> <CA+sqOsZJbvyAW6=CSG5EikhmDPt+Onjpm+VvBNPMKFmVi-ZQ8g@mail.gmail.com>
 <CA+sqOsZfjz0wTei+6qiv+zxXt7TA_GMO8EQ=v0EeDGFpqLrWRg@mail.gmail.com>
 <20151023155324.GA2555@lazy.lzy> <CA+sqOsYBbOwn5tJfygAR0MDCQPpd4w61XPGBLv8Mme8cT_HL8A@mail.gmail.com>
 <CA+sqOsY1Q4e3vNy4rmqjndsOStSGOg4JpqWBm4TTEvRdOmTkbQ@mail.gmail.com>
 <562A7333.9010702@turmel.org> <CA+sqOsYVGyCVKoRYAvgsL57tHhZn6+RaLK_7bzrUHvVK2XUNPA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sqOsYVGyCVKoRYAvgsL57tHhZn6+RaLK_7bzrUHvVK2XUNPA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 23, 2015 at 10:46 PM, Marek <mlf.conv@gmail.com> wrote:
> dd from mdX doesn't work i tried it even with testdisk, what you get
> is mixed up data, incomplete files.

As far as dd is concerned /dev/mdX is just another block device so it works
as expected.
