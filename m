From: Wols Lists <antlists@youngman.org.uk>
Subject: Interesting mdadm quirk ...
Date: Sat, 7 Jan 2017 13:21:03 +0000
Message-ID: <5870EB3F.2060206@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Just been doing some raid testing, and this happened ...

linux-lfqf:/dev # mdadm md/parity
md/parity: 31.97GiB raid5 3 devices, 0 spares. Use mdadm --detail for
more detail.
linux-lfqf:/dev # mdadm --stop md/parity
mdadm: Cannot open md/parity
linux-lfqf:/dev # mdadm --stop /dev/md/parity
mdadm: stopped /dev/md/parity

Weird - why can it successfully stop it when passed an absolute path,
but not when passed a relative path? When I did the first variant, I
used tab completion, and then when I edited it I really did edit it, not
retype it, so I can't see any way the two arguments could refer to
different objects.

Oh - and

mdadm --version
mdadm - v3.4 - 28th January 2016

ie stock SuSE leap 42.2

Cheers,
Wol
