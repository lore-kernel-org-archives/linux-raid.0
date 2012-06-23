From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Stacked array data recovery
Date: Sat, 23 Jun 2012 07:05:40 -0500
Message-ID: <4FE5B114.3080706@hardwarefreak.com>
References: <js083q$kdu$1@dough.gmane.org> <js1vm0$9k8$1@dough.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <js1vm0$9k8$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/22/2012 9:32 AM, Ramon Hofer wrote:
> On Thu, 21 Jun 2012 22:44:10 +0000, Ramon Hofer wrote:
> 
>> Is it possible to start md1 again to be able to start the linear array
>> md0 so that I can accesss the data?
> 
> Stand will probably be angry with me but I did the following:

Not at all.  I just wanted to make sure you had all of your post crash
ducks in a row before trying to bring the arrays back up, given the
circumstances under which they went down.

> I found the recovery page in your wiki:
> https://raid.wiki.kernel.org/index.php/RAID_Recovery
> 
> So I followed the process there.
> 
> ~$ mdadm --examine /dev/sd[abcd] > raid.status.md1
> 
> ~$ mdadm --create --assume-clean --level=5 --raid-devices=4 /dev/md1 /dev/
> sda /dev/sdb /dev/sdc /dev/sdd

-- 
Stan
