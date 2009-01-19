From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Raid6 write performance
Date: Mon, 19 Jan 2009 08:40:36 +0100
Message-ID: <49742E74.9090502@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am experimenting with raid6 on 4 drives on 2.6.27.11. The problem I am
having is that no matter what chunk size I use, the write benchmark
always comes out at single drive speed, although I should be seeing
double drive speed (read speed is at near 4x as expected). Is there some
hidden setting that I am overlooking, or is this a current known
limitation of raid6? In contrast if I make a raid5 on these 4 drives, I
get the expected 3xdrive write speed, and occasionally 4xdrive linear
read speed.

When the write test is running, I get about 14% of system cpu a sporadic
40% of iowait and the rest idle at all times (machine is in runlevel 1
so not to screw with results). Anyone has any ideas?

Thank you.
