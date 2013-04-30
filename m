From: Gimpbully <gimpbully@gmail.com>
Subject: Re: array went wonky
Date: Mon, 29 Apr 2013 19:33:43 -0700
Message-ID: <F29438B9-DA12-40B1-8382-30886C95B5BD@gmail.com>
References: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com> <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Bingner <sam@bingner.com>
Cc: "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Apr 13, 2013, at 7:20 AM, Sam Bingner <sam@bingner.com> wrote:

> After that you can try to recreate the array with the proper order (sdc1, sdb1, sde1, missing, sda1) and copy data off or add the spare in again depending on if you were able to recover all the data wih GNU ddrescue.


What do you mean recreate?  what's the specific command?  something like:
mdadm --create --assume-clean --level=5 --raid-devices=5 /dev/md127 /dev/sdc1 /dev/sdb1 /sdv/sde1 missing  /dev/sda1

?