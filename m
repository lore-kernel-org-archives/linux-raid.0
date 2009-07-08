From: "Tirumala Reddy Marri" <tmarri@amcc.com>
Subject: RE: Question on RAID-5 using ADMA
Date: Wed, 8 Jul 2009 15:55:14 -0700
Message-ID: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087FE@SDCEXCHANGE01.ad.amcc.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com> <e9c3a7c20907081548r7e7a476difd1970b749987c13@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-class: urn:content-classes:message
In-Reply-To: <e9c3a7c20907081548r7e7a476difd1970b749987c13@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I enabled the test. But I don't know how to run it. I have my own versi=
on of XOR test which verify the XOR operation. In general regular RADI-=
5 creation and creating file system works fine. Then I was doing some d=
estructive tests to verify the stability that is where I am running int=
o this issue.
Thanks,
Marri




-----Original Message-----
=46rom: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On B=
ehalf Of Dan Williams
Sent: Wednesday, July 08, 2009 3:48 PM
To: Tirumala Reddy Marri
Cc: linux-raid@vger.kernel.org
Subject: Re: Question on RAID-5 using ADMA

On Wed, Jul 8, 2009 at 2:37 PM, Tirumala Reddy Marri<tmarri@amcc.com> w=
rote:
> Hi,
> =A0I am having issue with following sequence of steps.
>
> 1. Start raid-5 =A0" mdadm -C /dev/md0 -f -z30000000 -c64 -l5 -n3
> /dev/sd[a-c] -assume -clean"
> 2. mkfs.ext3 /dev/md0
> 3. mount /dev/md0 /mnt/tmpmnt
> 4. mdadm -a /dev/md0 /dev/sdd (adding a spare disk)
> 5. mdadm -f /dev/smd0 /dev/sda (fail disk /dev/sda)
>
> When I do ls -l /mnt/tmpmnt I am seeing the errors end of the email.
>

Have you confirmed that your driver can run the xor tests from the
dmatest module without issue?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
