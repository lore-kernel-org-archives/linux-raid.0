From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: accidently pulled to many devices, raid6 wont start.
Date: Thu, 05 Dec 2013 14:36:34 +0100
Message-ID: <52A08162.3080706@fastmail.fm>
References: <BLU0-SMTP16236357B62A13D8FFAC14198D70@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU0-SMTP16236357B62A13D8FFAC14198D70@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Wilson Jonathan <piercing_male@hotmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 12/05/2013 01:30 AM, Wilson Jonathan wrote:
> mdadm: /dev/sdf6 is identified as a member of /dev/md5, slot 2.
> mdadm: /dev/sde6 is identified as a member of /dev/md5, slot 1.
> mdadm: /dev/sdd6 is identified as a member of /dev/md5, slot 0.
> mdadm: /dev/sdb6 is identified as a member of /dev/md5, slot 4.
> mdadm: /dev/sda6 is identified as a member of /dev/md5, slot 3.
> mdadm: ignoring /dev/sde6 as it reports /dev/sdf6 as failed

[...]

> So tried again, with a different (valid) chunk...
>
>
> root@BorgCUBE:/mnt/datastore/wilsonjonathan# mdadm --create
> --assume-clean --level=6 --raid-devices=6
> --chunk=64 /dev/md5 /dev/sdd6 /dev/sde6
> missing /dev/sdf6 /dev/sda6 /dev/sdb6

Why are you using this order? Missing seems to be at the wrong place?


Cheers,
Bernd

