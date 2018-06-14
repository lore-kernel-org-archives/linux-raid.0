From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: bitmap namespace conflict
Date: Thu, 14 Jun 2018 17:46:36 +0300
Message-ID: <ad0415db268750c033499e2b3bd079ca2c9f099d.camel@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Dmitry Torokhov <dmitry.torokhov@gmail.com>, arnd@arndb.de, Andrew Morton <akpm@linux-foundation.org>
Cc: linux-raid <linux-raid@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

Hi!

There is a potential name space collision with bitmap API vs. MD bitmaps
(whatever it is).

Since I'm about to submit some extension to bitmap API, I would like as
a preparatory patch to rename all bitmap_* in drivers/md to md_bitmap_*
to avoid real conflict with my patch series [1], i.e. bitmap_free().

Opinions?
Better proposals?

[1]: https://patchwork.kernel.org/patch/10442771/
Almost RFC version

-- 
Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Intel Finland Oy
