From: Jes Sorensen <Jes.Sorensen@redhat.com>
Subject: tests/03r5assemV1 issues
Date: Mon, 02 Jul 2012 15:24:43 +0200
Message-ID: <wrfjtxxqcn38.fsf@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

I am trying to get the test suite stable on RHEL, but I see a lot of
failures in 03r5assemV1, in particular between these two cases:

mdadm -A $md1 -u $uuid $devlist
check state U_U
eval $tst

mdadm -A $md1 --name=one $devlist
check state U_U
check spares 1
eval $tst

I have tested it with the latest upstream kernel as well and see the
same problems. I suspect it is simply the box that is too fast, ending
up with the raid check completing inbetween the two test cases?

Are you seeing the same thing there? I tried playing with the max speed
variable but it doesn't really seem to make any difference.

Any ideas for what we can be done to make this case more resilient to
false positives? I guess one option would be to re-create the array
inbetween each test?

Cheers,
Jes
