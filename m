From: Chris Murphy <lists@colorremedies.com>
Subject: Re: GPT Table broken on a Raid1
Date: Fri, 21 Sep 2012 15:30:03 -0600
Message-ID: <CA4BB74E-FBDC-4C8D-A369-BB3CAD859793@colorremedies.com>
References: <4961154.0TR9MeFlIq@techz> <2627519.Y2VdWh5VBI@techz> <1BDFB79A-E375-47F2-8EDF-8F51D8774651@colorremedies.com> <1361158.MkTZ6QR6cp@techz>
Mime-Version: 1.0 (Apple Message framework v1278)
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1361158.MkTZ6QR6cp@techz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

And more, since you mentioned mdadm and dmraid:
http://forums.gentoo.org/viewtopic-t-888520-start-0.html

It sounds like you need to pick one, and the one to pick is mdraid, and expressly disable dmraid.

I personally would consider that you go into BIOS and blow away this RAID. Recreate it from scratch, and partition with gdisk from a LiveCD (e.g. gdisk is on the Fedora 17 livecd). Then install Windows. Then go back to the LiveCD and confirm that the GPT is still OK. Then install linux.


Chris Murphy