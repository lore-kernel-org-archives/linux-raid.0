From: Clemens Eisserer <linuxhippy@gmail.com>
Subject: Questions regarding bad block management
Date: Sun, 26 Jan 2014 22:03:45 +0100
Message-ID: <CAFvQSYTXWG7q92nkENw5p4EDEmEPO85qf28-9m3K2eFhAZK9gQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've seen several SD cards used in my raspberry pi develop bad blocks
which can not be read or written anymore.
I thought raid couldn't help here as it would flag the whole device as
"bad" once it can not write a block anymore, however recently I
learned linux-raid is now capable of handling bad blocks.

I've been searching a bit, however didn't find a lot of information,
so I would be greateful if somebody could answer the following
questions:

1. Is the badblock-code contained in the stable 3.12 kernel?

1. Using a raid1 with badblock management, is it possible for
linux-raid to automatially repair errors transparently?
So if a block goes bad, does linux-raid silently replace it without
user intervention.

2. What happens in case a replaced block fails again? Is this supported?

Any pointer to documentation about bad-block handling would be highly
appriciated.

Thanks, Clemens
