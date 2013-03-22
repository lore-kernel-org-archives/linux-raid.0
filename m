From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: Need help with my raid5
Date: Fri, 22 Mar 2013 07:06:08 -0500
Message-ID: <CAAMCDed0Pvs_+c6o5BvpVNi5ATZeu1abR1xeW=ikR8O9W5HJ1Q@mail.gmail.com>
References: <loom.20130322T084406-543@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20130322T084406-543@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mirko <mirko76@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 22, 2013 at 2:57 AM, Mirko <mirko76@arcor.de> wrote:

>
>     Number   Major   Minor   RaidDevice State
>        0       8       49        0      active sync   /dev/sdd1
>        1       8        1        1      active sync   /dev/sda1
>        3       8       81        2      active sync   /dev/sdf1
>        3       0        0        3      removed
>        5       8       65        4      active sync   /dev/sde1
>        6       8       17        5      active sync   /dev/sdb1
>        7       8       33        -      spare   /dev/sdc1
>
> What can i do to rescue my data?
>
> Thx
>
> --

According to the above you removed device 3 not device 7....device 3
is missing...device 7 is still there and is a spare.

Put what you though was 7 back...note that properly determining which
device is which is pretty difficult unless you have a commercial grade
wired enclosure from a tier 1 vendor that is actually labeled and
wired correctly (don't always count on that).

I have self wired hot swap enclosures and my method is to read from
the array and see which disk does not light up (confirm all others are
active) and then cancel that read and go back and read from the bad
disk to confirm which device that is, and if I want to be really save
cancel that read make sure that disk stops then read again just to
confirm I know what is what, no matter what you have, no matter how it
is incorrectly labeled/wired this method should always work right.
