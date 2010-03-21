From: Shane W <shane-kernel@csy.ca>
Subject: Problem converting from raid5 to raid6
Date: Sat, 20 Mar 2010 20:01:07 -0700
Message-ID: <20100321030107.GA18586@csy.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello all,

I am trying to convert a 5 disk raid5 array to a 6 disk
raid6 but am having no luck. I first added the 6th disk as
a spare then
mdadm --grow /dev/md3 --level 6
mdadm level of /dev/md3 changed to raid6
mdadm: /dev/md3: Something wrong - reshape aborted
mdadm: aborting level change

dmesg doesn't show an error and neither does mdadm beyond
"something wrong". Is this supported?

mdadm 3.1.1 Linux 2.6.32.8 x86_64.

Thanks,
Shane
