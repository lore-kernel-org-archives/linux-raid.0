From: Michal Soltys <soltys@ziu.info>
Subject: Re: Re-assembling a software RAID in which device names have changed.
Date: Tue, 08 Apr 2008 22:19:43 +0200
Message-ID: <47FBD35F.1010205@ziu.info>
References: <fa037c550804072134w59f0f280g3d86ed76a99a271e@mail.gmail.com>	 <47FBAA76.20008@msgid.tls.msk.ru>	 <fa037c550804081055p2d2550ccs8dfab22d2edb6920@mail.gmail.com>	 <47FBBB6E.8040307@msgid.tls.msk.ru> <fa037c550804081206w6aa4db7r9b9f22202c4cca38@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <fa037c550804081206w6aa4db7r9b9f22202c4cca38@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Sean H." <silverwraithii@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Sean H. wrote:
>
>  Now, today, I wanted to determine which disk was failing, so I
> unmounted my array and unplugged drives - Specifically, three. The
> third was the culprit, and I plugged the drives back in and rebooted.
>

Just to be sure - did you do that on live array ? (it kinda looks like 
you did)

> 
> Below the first command, and separated by ten hyphens is --detail
> /dev/md0 which shows that the remaining device is marked "removed" and
> not "failed".
> 
> I thank you for your help thusfar - You've allowed me to mount the
> array and access my data. However, I would very much like to get my
> RAID 5 back to non-degraded status ASAP.
> 

You can add the drive/partition with --add option to the existing array.

It will start rebuilding then, and it can take a while.

