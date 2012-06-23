From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Stacked array data recovery
Date: Sat, 23 Jun 2012 07:09:55 -0500
Message-ID: <4FE5B213.5010503@hardwarefreak.com>
References: <js083q$kdu$1@dough.gmane.org> <js1vuk$9k8$2@dough.gmane.org>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <js1vuk$9k8$2@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ramon Hofer <ramonhofer@bluewin.ch>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 6/22/2012 9:37 AM, Ramon Hofer wrote:
> Sorry, I hit the wrong button.On Thu, 21 Jun 2012 22:44:10 +0000, Ramon 
> Hofer wrote:
> 
>> Is it possible to start md1 again to be able to start the linear array
>> md0 so that I can accesss the data?
> 
> Stan will probably be angry with me but I did the following:
> 
> I found the recovery page in your wiki:
> https://raid.wiki.kernel.org/index.php/RAID_Recovery
> 
> So I followed the process there.
> This is what I did:
> 
> ~$ mdadm --examine /dev/sd[abcd] > raid.status.md1
> 
> ~$ mdadm --create --assume-clean -c 128 --level=5 --raid-devices=4 /dev/
> md1 /dev/sda /dev/sdb /dev/sdc /dev/sdd
> 
> It was up and clean.
> 
> ~$ mdadm --examine /dev/md[12] > raid.status.md0
> 
> ~$ mdadm -C --assume-clean -n2 -l linear /dev/md0 /dev/md[12]
> 
> Now I could mount md0 and all my data is still there :-D

You should have run an "xfs_repair -n" before mounting.  "-n" means no
modify, making it a check operation.  If it finds errors then rerun it
without the "-n" so it can make necessary repairs.  Then remount.  Sorry
I forgot to mention this, or remind you, whichever is the case. :)

-- 
Stan
