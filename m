From: Joachim Otahal <Jou@gmx.net>
Subject: Re: Swap on /dev/md1 always lost after reboot
Date: Mon, 29 Mar 2010 04:32:56 +0200
Message-ID: <4BB01158.6050109@gmx.net>
References: <4BB00EBF.7070304@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB00EBF.7070304@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Joachim Otahal schrieb:
> free says: swap active, mdstat says:
> md2 : active (auto-read-only) raid1 sda2[1] sdb2[0]
>       979840 blocks [2/2] [UU]
minor correction: the output right after creating the raid + issuing a 
mkswap is
md2 : active raid1 sda2[1] sdb2[0]
       979840 blocks [2/2] [UU]
       [=======>.............]  resync = 37.9% (372480/979840) 
finish=0.1min speed=93120K/sec

and a few second later:
md2 : active raid1 sda2[1] sdb2[0]
       979840 blocks [2/2] [UU]

mdadm.conf updated, but md2 still not there after reboot.

Joachim

