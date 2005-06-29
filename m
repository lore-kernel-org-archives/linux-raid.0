From: Ken Walker <ken.walker@manchester.ac.uk>
Subject: RE: problems creating my first  raid 1 on Debian
Date: Wed, 29 Jun 2005 19:16:45 +0100
Message-ID: <60F5F1E2B94AD4119F0B00B0D0215FFF01A69ECF@bsc.tt.umist.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-8"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have a problem with the latest releases including Knoppix 3.9, mandrake
9.1 and mandrake 10.1, they all hang installing the scsi module.

I have found that only mandrake 8.2 and Debian 3.0 vanilla kernel see my
scsi cards. 


The standard Debian 3.0 install hang at 5% when loading the scsi module, it
sees it correctly but goes no further.

I have two scsi cards, one is a Adaptec AHA2940 and the other is a Advansys
ABP940-UW, both can be seen with Debian or mandrake latest installers and
say their loading the same modules as mandrake 8.2 but hang. Even though
mandrake 8.2 fly's strait thought the module install and continues.

so i installed with vanilla which is 

Samba3:/etc# uname -a
Linux Samba3 2.2.20 #1 Sat Apr 20 11:45:28 EST 2002 i686 GNU/Linux

I don't know how to proceed with the latest installers

:o(


Many thanks for your reply
:o)

-----Original Message-----
From: Mitchell Laks [mailto:mlaks@verizon.net]
Sent: 29 June 2005 7:20 pm
To: linux-raid@vger.kernel.org
Subject: Re: problems creating my first raid 1 on debian


On Wednesday 29 June 2005 08:05 am, you wrote:
> I've been using Mandrake Linux for a few years now, and always preferred
> LM8.2 because it was supposed to be the most stable version they have
> produce to date. But i got hacked and the main problem was updating
> packages no longer supported by Mandrake.
>
> I don't like their end of product life expectancy, similar to windows.
>
> I'm now starting with Debian, because there more interested in stability
> than adding everything before its been fully tested.

You are using an out of date Debian. The latest debian stable is Sarge.
Download the new sarge installer and you should be ok....
I have used Sarge for over 6 months on servers....

Regards,
Mitchell
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
