From: Martin Wilck <mwilck@arcor.de>
Subject: Re: How does md(adm) work with fake-raid ?
Date: Fri, 19 Jul 2013 20:58:47 +0200
Message-ID: <51E98C67.9060605@arcor.de>
References: <CAC9WiBjU_A0jsB4KoX4B9ohT4TD3cYuDdioM6hSWfK13Otjs-Q@mail.gmail.com>	<51E86646.8020107@arcor.de> <CANBHLUi9+hJo8w4V6Bi_3kHDoph4yB7C=sCb5ZSGOB0K1WKGow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANBHLUi9+hJo8w4V6Bi_3kHDoph4yB7C=sCb5ZSGOB0K1WKGow@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dmitrijs Ledkovs <xnox@debian.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/19/2013 01:35 AM, Dmitrijs Ledkovs wrote:

> My experience with these fakeraid arrays is very limitted, and I'd
> want to enquire of proper migration strategies from dmraid to mdadm.
> Whilst looking at the udev rules, at the moment, i have disable
> IMSM/DDF from assembly in mdadm udev rules, because dmraid has a nice
> property of "activating anything it finds".
> I suppose having both mdadm & dmraid racing to activate those drives
> wouldn't be nice.

It can be done in udev. Have a look at the udev rules in CentOS6, for
example; they do it for IMSM and it should be possible for DDF as well.
You can use kernel command line parameters ("nodmraid") to define what
RAID solution you prefer.

Martin
