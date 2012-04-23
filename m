From: Jan Ceuleers <jan.ceuleers@computer.org>
Subject: Re: dmesg deluge: RAID1 conf printout
Date: Mon, 23 Apr 2012 09:01:45 +0200
Message-ID: <4F94FE59.20307@computer.org>
References: <4F92BC43.3010603@computer.org> <20120422070041.7e4b95e7@notabene.brown> <4F943E07.8040206@computer.org> <20120423094853.15683cd6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120423094853.15683cd6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

NeilBrown wrote:
> The following should fix it.

Neil,

Since I had not been running a self-compiled kernel when I reported 
this, I first reproduced the issue on vanilla 3.3.0: git clone, git 
checkout, build (using the Ubuntu config file for 3.3.0), install, boot.

The spares were not being added to either RAID 1 set, and the logs were 
not being flooded. The behaviour however began immediately when I added 
the spares manually.

I then built a kernel with your patch on top, and upon booting the 
spares were being added automatically, and the logs are not being 
spammed. The problem therefore indeed appears to be solved.

Tested-by: Jan Ceuleers <jan.ceuleers@computer.org>

Thanks, Jan
