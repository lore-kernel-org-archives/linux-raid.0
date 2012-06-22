From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Stacked array data recovery
Date: Fri, 22 Jun 2012 14:32:32 +0000 (UTC)
Message-ID: <js1vm0$9k8$1@dough.gmane.org>
References: <js083q$kdu$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 21 Jun 2012 22:44:10 +0000, Ramon Hofer wrote:

> Is it possible to start md1 again to be able to start the linear array
> md0 so that I can accesss the data?

Stand will probably be angry with me but I did the following:

I found the recovery page in your wiki:
https://raid.wiki.kernel.org/index.php/RAID_Recovery

So I followed the process there.

~$ mdadm --examine /dev/sd[abcd] > raid.status.md1

~$ mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md1 /dev/
sda /dev/sdb /dev/sdc /dev/sdd

~$

~$


