From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: Question on RAID-5 using ADMA
Date: Wed, 8 Jul 2009 15:48:09 -0700
Message-ID: <e9c3a7c20907081548r7e7a476difd1970b749987c13@mail.gmail.com>
References: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AC5E1C3367E37D44970B81A6ADD1DA2C07B087D1@SDCEXCHANGE01.ad.amcc.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tirumala Reddy Marri <tmarri@amcc.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

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
