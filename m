From: Tom Carlson <twigathy@gmail.com>
Subject: Re: mdadm problem
Date: Sun, 21 Mar 2010 18:51:48 +0000
Message-ID: <1f0f1a961003211151l2a30b256g471c60cc61d14ec2@mail.gmail.com>
References: <4BA664BA.20505@gemmill.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BA664BA.20505@gemmill.name>
Sender: linux-raid-owner@vger.kernel.org
To: Graeme Gemmill <graeme@gemmill.name>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 21 March 2010 18:26, Graeme Gemmill <graeme@gemmill.name> wrote
some stuff....
> Some RAID expertise would be very welcome!

I'm no expert... but I think you need to do the following:
mdadm --stop /dev/md127
mdadm --zero-superblock /dev/sd[a-c]
mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/sda1 /dev/sdb1 /dev/sdc1

All the best,

T
