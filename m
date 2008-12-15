From: nterry <nigel@nigelterry.net>
Subject: Re: Raid 5 Problem
Date: Mon, 15 Dec 2008 18:07:06 -0500
Message-ID: <4946E31A.7040803@nigelterry.net>
References: <49450D04.8060703@nigelterry.net>	<4945276E.1010405@ziu.info>	<49456F94.8020100@nigelterry.net>	<49457719.4000009@ziu.info>	<49457BE3.4090200@nigelterry.net> <18758.53532.742930.802728@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18758.53532.742930.802728@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
Cc: Michal Soltys <soltys@ziu.info>
List-Id: linux-raid.ids

Neil Brown wrote:
> On Sunday December 14, nigel@nigelterry.net wrote:
>   
>> I added the DEVICE /dev/sd[bcde]1 to mdadm.conf and that apepars to have 
>> fixed the problem.  2 reboots and it worked both times.
>>     
>
> An alternate fix in this case would be
>
>   mdadm --zero-superblock /dev/sdb
>
> to remove the old superblock that is confusing things.
>
> NeilBrown
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>   
That fails as:

[root@homepc ~]# mdadm --zero-superblock /dev/sdb
mdadm: Couldn't open /dev/sdb for write - not zeroing
[root@homepc ~]#

I also discovered that /dev/sdc appears to have a superblock which maybe 
explains why # mdadm --examine --scan throws up three arrays.  Trying to 
zero the superblock on /dev/sdc gives the same error.


