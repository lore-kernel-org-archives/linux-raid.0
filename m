From: Norman Schmidt <norman.schmidt@ratnet.stw.uni-erlangen.de>
Subject: making new device names with mknod
Date: Tue, 10 Sep 2002 23:12:00 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3D7E6020.8030402@ratnet.stw.uni-erlangen.de>
Reply-To: schmidt@naa.net, schmidt@naa.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi!

Can somebody tell me how to make new device names in /dev?
I have installed two additional ide controllers and want to make md
devices out of partitions on devices /dev/hde, /dev/hdg, /dev/hdi and
/dev/hdk. In /dev, there are only devices up to hdh. In addition to
that, I would need to make the /dev entries for the partitions.

Is it possible to use more than 16 md devices, how can I make /dev/md16
and so on?

I am using Debian Woody, so no makedev, only mknod is available.

I hope, I am not too off-topic, thanks, Norman.


