From: Albert Pauw <albert.pauw@gmail.com>
Subject: Version 3.2.5 and ddf issues (bugreport)
Date: Sat, 28 Jul 2012 13:46:06 +0200
Message-ID: <5013D0FE.3020906@gmail.com>
References: <4D8A4780.2030401@gmail.com> <20110324090837.689c5a0e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110324090837.689c5a0e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

Hi Neil,

After a hiatus of 1.5 year (busy with all sorts) I am back and tried the 
ddf code to see how things improved.

I build a VM Centos 6.3 system with 6 extra 1GB disks for testing.
I found several issues in the standard installed 3.2.3 version of mdadm 
relating to ddf, but installed the
3.2.5 version in order to work with recent code.

However, while version 3.2.3 is able to create a ddf container with 
raidsets in it, I found a problem with the 3.2.5 version.

After initially creating the container:

mdadm -C /dev/md127 -e ddf -l container /dev/sd[b-g]

which worked, I created a raid (1 or 5 it doesn't matter in this case) 
in it:

mdadm -C /dev/md0 -l raid5 -n 3 /dev/md127

However, it stays on resync=PENDING and readonly, and doesn't get build.

So I tried to set it to readwrite:

mdadm --readwrite  /dev/md0

Unfortunately, it stays on readonly and doesn't get build.

As said before, this did work in 3.2.3.

Are you already on this problem?

Kind regards,

Albert

P.S. My idea was, because the ddf code is not that much used, to create 
a test/validate script for ddf.


