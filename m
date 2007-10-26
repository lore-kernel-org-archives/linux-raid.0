From: Alberto Alonso <alberto@ggsys.net>
Subject: Implementing low level timeouts within MD
Date: Fri, 26 Oct 2007 12:12:33 -0500
Message-ID: <1193418753.4771.17.camel@w100>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've been asking on my other posts but haven't seen
a direct reply to this question:

Can MD implement timeouts so that it detects problems when
drivers don't come back?

For me this year shall be known as "the year the array
stood still" (bad scifi reference :-)

After 4 different array failures all due to a single drive
failure I think it would really be helpful if the md code
timed out the driver.

Thanks,

Alberto

