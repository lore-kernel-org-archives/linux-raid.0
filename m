From: Mario <mgiammarco@gmail.com>
Subject: It is possible to put write cache on ssd?
Date: Fri, 4 Jun 2010 08:52:50 +0000 (UTC)
Message-ID: <loom.20100604T102522-67@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
I have seen that the only hardware raid controllers that can go faster than
linux md raid are the controllers with BBU unit.

Infact thanks to the battery the controllers can have a more aggressive write
caching without the risk of losing data.

Obviously in a standard pc there is not BBU to use with linux software raid.

Now I see that latest hardware raid controllers exchange battery AND ram with a
little flash disk.

So I ask: if I add a fast (with little size) ssd to a linux server is there a
way for linux md raid to use it as a cache to have safer writes and faster raid?

Thanks in advance for interest.

Mario  



