From: "G. Michael Carter" <mikey@carterfamily.ca>
Subject: mdsadm -A won't assemble my array
Date: Mon, 9 Feb 2015 15:21:24 -0500
Message-ID: <CANjusZesi-8zxpZ9rCOEToSXwFoiApeN-ivO51qY=80R6_xb_g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Some time last night my machine had a kernel panic.  Two of the arrays
didn't start up.

One I managed to fix as a mdadm -E clued me in that three of the
drives were ok.  So I just reassembled the three and added the fourth.
Then it just started no problem.

My big array however I'm not so lucky.

I've got a state of


Raid level: 5
/dev/sdb: AA..   (state: clean)
/dev/sdk: AAAA   (state: active)
/dev/sdo: A.AA   (state: clean)
/dev/sdp: A.AA   (state: clean)

Thus can only get two drives to match in any config.  How do I get out
of this mess?
