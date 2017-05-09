From: Chris Worley <worleys@gmail.com>
Subject: In Direct I/O, no matter how big the read/write, the bio's are all 4KB
Date: Tue, 9 May 2017 10:03:24 -1000
Message-ID: <CANWz5fgNgnZ6R9md1TwD16nZzhAzX-t8BaOsN5-x-FfEE3_h3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linuxraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

I realize DIO needs to be 4KB aligned, but why do large I/Os get
chopped down into 4KB bio's?

Doing a blocktrace of the md device, even though the app is writing at
512KB, the MD driver is receiving 4KB bio's.

Why?

Thanks,

Chris
