From: Guillaume Rousse <Guillaume.Rousse@inria.fr>
Subject: heavy problem with raid initialisation
Date: Fri, 10 Feb 2006 11:11:24 +0100
Message-ID: <43EC66CC.4080001@inria.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello.

I'm using software raid with mdadm 1.7.0 on a mandrake linux 10.1, but
I'm facing heavy initialisation troubles. The first array /dev/md0 is
automatically created and launched at startup (though mdadm -As in init
scripts), but not the second array /dev/md1.

mdadm --examine --scan --config=partitions creates the second array as
/dev/.tmp.md1, which I can then assemble using an explicit mdadm -A
/dev/sda2 /dev/sdb2 command, but this is unpractical and failproof :/

Here is my /etc/mdadm.conf:
DEVICE /dev/sda* /dev/sdb*
MAILADDR root
ARRAY /dev/md1 level=raid1 num-devices=2
UUID=e5e9302c:1844139b:d30d31e0:6f8477c3
   devices=/dev/sda2,/dev/sdb2
ARRAY /dev/md0 level=raid1 num-devices=2
UUID=99375e60:af2e538e:59f01931:f86b50f4
   devices=/dev/sda1,/dev/sdb1

And here is content of /proc/mdstat once the second array is running:

Personalities : [raid1]
md1 : active raid1 sda2[0] sdb2[1]
      78123968 blocks [2/2] [UU]

md0 : active raid1 sda1[0] sdb1[1]
      78123968 blocks [2/2] [UU]

unused devices: <none>

I've had a look at google, I found some report of similar troubles, some
of them potentially linked with udev. I found some excerpts of mdadm
code that show than this specific /dev/.tmp syntax use is volontary, but
I found no explanation for it.

Any help appreciated.
