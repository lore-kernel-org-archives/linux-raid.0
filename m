From: =?UTF-8?B?VG9tw6HFoSBEdWzDrWs=?= <dulik@unart.cz>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Thu, 15 Apr 2010 15:11:18 +0200
Message-ID: <4BC71076.4090603@unart.cz>
References: <4BBA1289.4010705@redhat.com>	<20100407113035.3ca437f2@notabene.brown>	<4BBBE7D2.6090608@redhat.com>	<20100409093153.690ea963@notabene.brown>	<20100409103330.37d9dff5@notabene.brown>	<4BC43938.2020109@unart.cz>	<4BC4BCC2.7040605@redhat.com>	<4BC5ADB2.2060705@unart.cz> <20100415152416.4339c7e6@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100415152416.4339c7e6@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Doug Ledford <dledford@redhat.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Neil Brown napsal(a):
> This is not corrrect.  You can removed disconnected devices with:
>
>   mdadm /dev/mdx --fail detached --remove detached
>
> will fail, then remove, all component devices on /dev/mdx which
> have been detached from the system.
> This has been possible since about 2.6.2.
>   
Well, this is another great thing I overlooked in the manual.
Using this feature and some tiny scripts, I am now able to do fully 
automatic hot-unplug even with the old mdadm which came with my 
distribution:
https://raid.wiki.kernel.org/index.php/Hotplug#Fully_automated_hotplug_and_hot-unplug_using_UDEV_rules

Very cool, thanks for your help!

Tomas

