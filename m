From: <peter.greis@ubs.com>
Subject: nolargeio=1 ?
Date: Mon, 14 Mar 2005 09:36:02 +0100
Message-ID: <6F9171BE257CA742BFBCFA87B8F20F8D030E4380@NZURC900PEX1.ubsgs.ubsgroup.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
content-class: urn:content-classes:message
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Greetings,

I found that for reisfer filesystems sometimes the option nolargeio=1 is added to the fstab entry. At first blush this seems to be a workaround for a kernel bug. Does anyone have any more information ? I am running reiser -> lvm2 -> raid5 currently.

regards,

-Peter
