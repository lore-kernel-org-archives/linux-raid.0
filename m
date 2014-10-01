From: Brassow Jonathan <jbrassow@redhat.com>
Subject: Re: raid1 - ssd, doubts
Date: Tue, 30 Sep 2014 19:36:09 -0500
Message-ID: <FA95F377-79D3-4DF7-8B41-D7BB1B706660@redhat.com>
References: <CAH3kUhHkot3doqVZQ0TAot0A3e8i8RFWqsiLL35p1OYsvz5Xkw@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v1085)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHkot3doqVZQ0TAot0A3e8i8RFWqsiLL35p1OYsvz5Xkw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Sep 30, 2014, at 9:50 AM, Roberto Spadim wrote:
> the point are: madm raid1 trim is supported? or should i use lvm?
> should i partition it with 400gb and leave 100gb untouched? or should
> i use a hdd+ssd and dmcache?

LVM does not yet support trim on RAID.  (Funny you should ask!  We've just been talking about enabling this in LVM recently and it should go upstream very soon - following into the various distros a little later.)

 brassow