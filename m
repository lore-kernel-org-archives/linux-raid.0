From: Sam Bingner <sam@bingner.com>
Subject: Re: array went wonky
Date: Tue, 30 Apr 2013 06:20:43 +0000
Message-ID: <71F985BA-11B9-45E8-A17B-03F9CB5C8F52@bingner.com>
References: <474B6DA3-FED2-4674-9707-1BC43378CB90@gmail.com>
 <DC0F689B-F5E5-41F3-9CD4-74813E4A6108@bingner.com>,<F29438B9-DA12-40B1-8382-30886C95B5BD@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F29438B9-DA12-40B1-8382-30886C95B5BD@gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: Gimpbully <gimpbully@gmail.com>
Cc: "<linux-raid@vger.kernel.org>" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Apr 29, 2013, at 4:33 PM, "Gimpbully" <gimpbully@gmail.com> wrote:

> 
> On Apr 13, 2013, at 7:20 AM, Sam Bingner <sam@bingner.com> wrote:
> 
>> After that you can try to recreate the array with the proper order (sdc1, sdb1, sde1, missing, sda1) and copy data off or add the spare in again depending on if you were able to recover all the data wih GNU ddrescue.
> 
> 
> What do you mean recreate?  what's the specific command?  something like:
> mdadm --create --assume-clean --level=5 --raid-devices=5 /dev/md127 /dev/sdc1 /dev/sdb1 /sdv/sde1 missing  /dev/sda1

Don't recreate it - I said the wrong thing... You want to do an assemble on them with force if possible... Recreate is last ditch and make sure you have another copy if you do the previous command in case it doesn't work right due to offsets etc...

try:
mdadm --stop /dev/md127
mdadm --assemble --force /dev/md127 /dev/sd{c,b,e,a}1

If you DO need to recreate it, what you showed looks correct.

Sam