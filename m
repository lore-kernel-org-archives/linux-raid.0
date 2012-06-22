From: Ramon Hofer <ramonhofer@bluewin.ch>
Subject: Re: Stacked array data recovery
Date: Fri, 22 Jun 2012 14:37:08 +0000 (UTC)
Message-ID: <js1vuk$9k8$2@dough.gmane.org>
References: <js083q$kdu$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, I hit the wrong button.On Thu, 21 Jun 2012 22:44:10 +0000, Ramon 
Hofer wrote:

> Is it possible to start md1 again to be able to start the linear array
> md0 so that I can accesss the data?

Stan will probably be angry with me but I did the following:

I found the recovery page in your wiki:
https://raid.wiki.kernel.org/index.php/RAID_Recovery

So I followed the process there.
This is what I did:

~$ mdadm --examine /dev/sd[abcd] > raid.status.md1

~$ mdadm --create --assume-clean -c 128 --level=5 --raid-devices=4 /dev/
md1 /dev/sda /dev/sdb /dev/sdc /dev/sdd

It was up and clean.

~$ mdadm --examine /dev/md[12] > raid.status.md0

~$ mdadm -C --assume-clean -n2 -l linear /dev/md0 /dev/md[12]

Now I could mount md0 and all my data is still there :-D

Thanks for this great wiki page!


Best regards
Ramon

