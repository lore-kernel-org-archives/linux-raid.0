From: Andrew Walrond <andrew@walrond.org>
Subject: Re: raid1 fstab
Date: Tue, 7 Sep 2004 18:40:44 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200409071840.44395.andrew@walrond.org>
References: <000301c494e3$1fc92720$0801a8c0@homelinux.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <000301c494e3$1fc92720$0801a8c0@homelinux.net>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday 07 Sep 2004 15:01, Joe Pitts wrote:
> Hello,
>
> I'm running FC2 kernel-2.6.8-1.521
>
> I am converting a single disk setup to RAID1. I've been using the procedure
> in OREILLY's Managing Raid on Linux, pp239 241 - Converting to software
> raid.
> I'm at the point where I'm have to edit the /etc/fstab file and aside from
> listing the
> md devices I have'nt a clue what else I should be putting in this file.

All you need to know...

http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html

It's tells you how to setup fstab, and has a section on grub with raid1

Andrew Walrond
