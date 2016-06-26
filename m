From: Paul Roland <paulrolandw@gmail.com>
Subject: RAID 10 / 2 Devices Layout question
Date: Sun, 26 Jun 2016 18:20:31 +0100
Message-ID: <CA+3OdkMoF7jZNwsNR282Hvq4qwsKUuPtXaXrKXNUPq_4YD6BDw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello, quick one I guess sorry if I am messing this email with such a
newbie question.
I have two SSDs, and I would like to use md/raid10 (2devices) for
performance reasons.
The question since I was only able to find straight answers on more
than 2 devices:

Is using near instead of N2 somehow less secure than F2?
I know there is a mirrors and then stripe but with N2 I suspect a very
tiny chance of data to be written on same physical disc. In a 4disk
that is easy to understand or anticipate but here I am not sure which
to use.

Thank you
