From: Nevyn <nevynh@gmail.com>
Subject: Desperate plea for help
Date: Mon, 2 Apr 2007 15:14:37 +1200
Message-ID: <bcdb9ee50704012014o2a78fdc0pfc40060a5bf7ce20@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I've recently had a raid 5 array fail on me - 2 drives suddenly just
up and showed a failure. Of course this means that the metadata is
stuffed. I've had a look at the howto and found the mdadm --assemble
--force command but it's not working in this case. The 2 drives show
up as spares.

A friend has suggested that perhaps I could try reconstructing the
array but suggested that I should ask the question on here first.

Is there some way I can reconstruct the array at least long enough to
back the data up?
