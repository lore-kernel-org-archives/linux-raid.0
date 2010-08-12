From: Tobias Gunkel <tobias.gunkel@qumido.de>
Subject: Re: weird SparesMissing event
Date: Thu, 12 Aug 2010 09:57:51 +0200
Message-ID: <4C63A97F.3040706@qumido.de>
References: <4C624B80.9030304@qumido.de>	<20100811175711.40cb75c9@notabene>	<4C62716E.1090902@qumido.de> <20100811210928.2785f92b@notabene>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100811210928.2785f92b@notabene>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 11.08.2010 13:09, schrieb Neil Brown:

> As I thought, mdadm.conf says to expect 2 spares, but there is really only
> one.  Just edit the file and the message will stop.

Yes, now it's all fine, thanks!

But mdadm --examine --scan --verbose still shows spares=2:

ARRAY /dev/md2 level=raid1 num-devices=2
UUID=7aa24776:9d6e8d24:54307b3d:1949437b
   spares=2
devices=/dev/sdc3,/dev/sdc,/dev/sdb3,/dev/sdb,/dev/sda3,/dev/sda

...although mdadm.conf was updated:

grep -A1 md2 /etc/mdadm/mdadm.conf
ARRAY /dev/md2 UUID=7aa24776:9d6e8d24:54307b3d:1949437b
   spares=1


Tobi
