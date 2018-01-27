From: mostafa kishani <mostafa.kishani@gmail.com>
Subject: Implementing Global Parity Codes
Date: Sat, 27 Jan 2018 09:17:04 +0330
Message-ID: <CACm9mdUJLczo8zSB5UfU9Fd_6VK3+sGCYJYdaEaX0qW1cMLtYA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Dear All,

I am going to make some modifications to RAID protocol to make it more
reliable for my case (for a scientific, and maybe later, industrial
purpose). For example, I'm going to hold a Global Parity (a parity
taken across the whole data stripe rather than a row) alongside normal
row-wise parities, to cope with an extra sector/page failure per
stripe. Do you have any suggestion how can I implement this with a
moderate effort (I mean what functions should be modified)? have any
of you had any similar effort?
I also appreciate if you guide me how can I enable DEBUG mode in mdadm.

Bests,
Mostafa
