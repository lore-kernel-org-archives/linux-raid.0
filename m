From: Michal Soltys <msoltyspl@yandex.pl>
Subject: Re: Assemblin journaled array fails
Date: Sat, 9 May 2020 13:32:59 +0200
Message-ID: <b50213d9-771f-be8e-4183-659a0b4ebce5@yandex.pl>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 20/05/09 12:54, Michal Soltys wrote:
> # At this point mdadm confirmed everything went fine
> 
> After the reboot I'm in the situation as outlined above. Any suggestion 
> how to assemble this array now ?

To expand on this: "after reboot" means a few days later - the array was 
operating fine during that time.

Attempting to assembly the arrary manually from early initramfs (before 
any udev/etc. and with manually loaded modules), e.g.:

mdadm -A /dev/md/r5_big /dev/sd[efgh]1 /dev/md/r1_journal_big

shows:

md/raid:md126: device sde1 operational as raid disk 0
md/raid:md126: device sdh1 operational as raid disk 3
md/raid:md126: device sdg1 operational as raid disk 2
md/raid:md126: device sdf1 operational as raid disk 1
md/raid:md126: raid level 5 active with 4 out of 4 devices, algorithm 2

But then mdadm is left hanging for good.
