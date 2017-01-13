From: Wols Lists <antlists@youngman.org.uk>
Subject: linux raid wiki - kernel autoassembly
Date: Fri, 13 Jan 2017 21:09:13 +0000
Message-ID: <587941F9.6060708@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

When was this deleted from the kernel? Somebody on the suse list thinks
it is still there, and I can't find any references to the kernel where
it was deleted. I'd like to put a bit more info on the wiki.

I've looked at md.c, and found functions autorun_array and
autorun_devices, but I'm guessing these are looking for an array that's
already been assembled by udev/mdadm.

Cheers,
Wol
