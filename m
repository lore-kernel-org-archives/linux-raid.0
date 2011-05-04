From: Liam Kurmos <quantum.leaf@gmail.com>
Subject: mdadm raid1 read performance
Date: Wed, 4 May 2011 01:07:45 +0100
Message-ID: <BANLkTim8Ehn0fANtibg7X1cMVvOgt7CNMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: neilb@suse.de
List-Id: linux-raid.ids

Hi,

I've been testing mdadm (great piece of software btw) however all my
test show that reading from raid1 is only the same speed as reading
from a single drive.

Is this a known issue? or is there something seriously wrong with my
system? i have tried v2.8.1 and v.3.2.1 without difference and several
benchmarking methods.

best regards,

Liam
