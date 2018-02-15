From: Sean Caron <scaron@umich.edu>
Subject: Automatically start two-level mdadm RAID arrays (i.e. RAID 60) on boot?
Date: Thu, 15 Feb 2018 15:41:37 -0500
Message-ID: <CAA43vkUG8LrMUjazeYFtGVKVuTvrYRPe-UcPb21r=xeYpctpmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org, Sean Caron <scaron@umich.edu>
List-Id: linux-raid.ids

Hi all,

My site is very happily using MD RAID arrays constructed in two
levels. That is to say, we do RAID 60 by constructing an mdadm RAID 0
out of a number of mdadm RAID 6 strings.

These work great but one thing we have found and been living with is
that, when the system boots, mdadm will automatically start all the
RAID 6 strings, but it will not automatically start the top level RAID
0 container. The machine pauses on boot ("Hit S to skip, M to manually
resolve") trying to mount the RAID because the device is not
available, and a sys admin needs to manually go to the console and
start the top level RAID 0 to continue the boot.

In an attempt to reduce a little bit of toil and make it easier for
staff to reboot machines for service, I wanted to ask the list if
there was some way to get mdadm to automatically start the top-level
RAID 0 containers without operator intervention in this type of
scenario? I'm not sure if it's just an issue of inserting a little
delay somewhere between starting all the RAID 6 strings and attempting
to start the RAID 0, or if there is some configuration parameter I
have missed.

Thanks!

Sean
