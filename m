From: Johannes Langauf <johannes@langauf.de>
Subject: raid autodetect problems
Date: Mon, 12 Aug 2002 16:54:58 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20020812165458.C3835@hurricane>
Reply-To: johannes@langauf.de
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I've got a 4-ide-disk-raid5 array. I had all disks on two ide-buses. To
improve speed I bought an ide-controller, so that every disk has its own
bus now. But the autdetect function doesn't recognise the array anymore.
This seems to be because the persistent superblocks still point to the old
position of the devices. I already started the array with an updated
/etc/raidtab, but that didn't help.
I need autodetection because normally the array is my root fs. So what can
I do to make things work again besides from rebuilding the array?


