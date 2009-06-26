From: koti <koti.here.4u@gmail.com>
Subject: Request on MD Driver
Date: Fri, 26 Jun 2009 18:46:15 +0000 (UTC)
Message-ID: <loom.20090626T183850-511@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi All,

    I am very much interested to analyze the kernel code for MD driver, and 
need to work in RAID5/6 levels, so can body suggest good articles to analyze 
the code flow in linux kernel for MD driver.

    While analyzing the md/raid5.c file I have some confusions like:

1) Where we use all bitmap_list, handle_list, inactive_list, hold_list, 
delayed_list.
2) What exactly the stripe_head contains, where it is allocated and how the 
request submitted in asynchronous case.
3) Where the stripe_head freed.

   Any good books to follow (available in India is better for me).

   Any reply for this is very much helpful for my further work.


Thanks inadvance,
Koti


