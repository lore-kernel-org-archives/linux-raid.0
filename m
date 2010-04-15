From: Neil Brown <neilb@suse.de>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Thu, 15 Apr 2010 15:24:16 +1000
Message-ID: <20100415152416.4339c7e6@notabene.brown>
References: <4BBA1289.4010705@redhat.com>
	<20100407113035.3ca437f2@notabene.brown>
	<4BBBE7D2.6090608@redhat.com>
	<20100409093153.690ea963@notabene.brown>
	<20100409103330.37d9dff5@notabene.brown>
	<4BC43938.2020109@unart.cz>
	<4BC4BCC2.7040605@redhat.com>
	<4BC5ADB2.2060705@unart.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BC5ADB2.2060705@unart.cz>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?VG9tw6HFoSBEdWzDrWs=?= <dulik@unart.cz>
Cc: Doug Ledford <dledford@redhat.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 14 Apr 2010 13:57:38 +0200
Tom=C3=A1=C5=A1 Dul=C3=ADk <dulik@unart.cz> wrote:


> I have already started to write the documentation for this great feat=
ure=20
> here:
> https://raid.wiki.kernel.org/index.php/Hotplug

Great - thanks for taking the initiative with that.

However:
  All previous versions of mdadm were unable to remove disconnected or =
dead
devices from md arrays.

This is not corrrect.  You can removed disconnected devices with:

  mdadm /dev/mdx --fail detached --remove detached

will fail, then remove, all component devices on /dev/mdx which
have been detached from the system.
This has been possible since about 2.6.2.

NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
