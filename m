From: Phil Turmel <philip@turmel.org>
Subject: Re: Mdadm server eating drives
Date: Wed, 12 Jun 2013 10:44:59 -0400
Message-ID: <51B8896B.5000105@turmel.org>
References: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPSPcXizHpTnqfAGz7LDc3z+DSJUnOb7ukUdhbuFG6mJgs4=Bg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Barrett Lewis <barrett.lewis.mitsi@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 06/12/2013 09:47 AM, Barrett Lewis wrote:
> I started about 1 year ago with a 5x2tb raid 5.  At the beginning of
> feburary, I came home from work and my drives were all making these
> crazy beeping noises.  At that point I was on kernel version .34

[trim /]

What you are experiencing is typical of a hobby-level user who bought
non-raid-rated drives and is now experiencing timeout mismatch array
failures due to a lack of error recovery control.

I suggest you search the archives for various combinations of "scterc",
"URE", "timeout", and "error recovery".  In the end, you almost
certainly will need to either use "smartctl -l scterc,70,70" to turn on
ERC in your drives, or use "echo 180 >/sys/block/sdX/device/timeout" to
lengthen linux's standard driver command timeout.

Anyways, when you check in again, please report the output of the following:

1) "mdadm -E /dev/sdX" for each member device or partition
2) "mdadm -D /dev/mdX" for your array
3) "smartctl -x /dev/sdX" for each member device
4) "cat /proc/mdstat"
5) "for x in /sys/block/sd*/device/timeout ; do echo $x $(< $x) ; done"
6) "dmesg" (trimmed to relevant md and sd* messages)
7) "cat /etc/mdadm.conf"

Phil

