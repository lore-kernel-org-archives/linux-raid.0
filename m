From: maarten van den Berg <maarten@ultratux.net>
Subject: Re: Is my RAID 5 array working OK?
Date: Mon, 5 Jul 2004 00:26:11 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200407050026.11400.maarten@ultratux.net>
References: <1483.192.168.1.2.1088970622.squirrel@192.168.1.2> <1638.192.168.1.2.1088974283.squirrel@192.168.1.2>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1638.192.168.1.2.1088974283.squirrel@192.168.1.2>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sunday 04 July 2004 22:51, Robin Bowes wrote:
> On Sun, July 4, 2004 20:50, Robin Bowes said:

> Unfortunately, I now see this:


>     Number   Major   Minor   RaidDevice State
>        0       8        2        0      active sync   /dev/sda2
>        1       0        0       -1      removed
>        2       8       34        2      active sync   /dev/sdc2
>        3       8       50        3      active sync   /dev/sdd2
>        4       8       66        4      active sync   /dev/sde2
>        5       0        0       -1      removed
>        6       8       82        5      spare   /dev/sdf2
>        7       8       18       -1      faulty   /dev/sdb2
>            UUID : 2464f7cb:7f57ffdb:fe2dcd80:fc896946
>          Events : 0.819771

This is weird, if you ask me.  When sdb was set faulty, the spare sdf should 
have kicked in, and should now be syncing.  In your previous mail, you 
mentioned you did not expect there to be a spare.  And I notice the missing 
(removed) device number 5.  So something went wrong, the spare was unwanted 
according to you, and is not doing what it's supposed to do anyway.
Maybe someting is botched in the config...?
I'm not exactly sure where the fault lies, though.

Apart from that, yes, sdb sure sounds like it's broken... 

Maarten

-- 
When I answered where I wanted to go today, they just hung up -- Unknown

