From: Andrei Borzenkov <arvidjaar@gmail.com>
Subject: What happens with array when external write-intent bitmap fails?
Date: Tue, 16 Sep 2014 17:42:13 +0400
Message-ID: <CAA91j0X2WSyF_QuZdoWWNgDCZV7TKJbhQmq_vOrygqzkg3yK8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Theoretically write-intent is optional, so if it fails it would be
possible to simply discard it and continue. But I have seen statement
that if external write-intent bitmap file is not available at time of
assembly, starting of array fails.

Thank you for clarification.

-andrei
