From: Zhilong Liu <zlliu@suse.com>
Subject: mdadm: Apply to revert the commit of a4dcdb23
Date: Tue, 6 Jun 2017 17:25:06 +0800
Message-ID: <0010fa6f-f227-cdd8-31ef-7073ec46546a@suse.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <jes.sorensen@gmail.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi, Jes;
    Excuse me, there is one problematic commit for Detail.c,
a4dcdb23(Detail: determine array state from sysfs).
This commit does change the codes meaning and it didn't
run to the right path. This commit was result in a bug that
Detail() cannot work normally.

For example:
# ./mdadm -CR /dev/md0 -l1 -n2 /dev/loop[0-1] --assume-clean
# ./mdadm -D /dev/md0
mdadm: cannot get array detail for /dev/md0: No such file or directory

Thanks very much,
-Zhilong
