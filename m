From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid1 sector size
Date: Sun, 06 Feb 2011 16:30:11 -0600
Message-ID: <4D4F20F3.5050709@hardwarefreak.com>
References: <AANLkTikA=Qe1iwLMkB3V6RLdzRU0p4PB0xmFxJ7907Ez@mail.gmail.com> <AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinwowg1evk44=46VO+Eni1B=G5Mr_X1r32GO5eF@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Roberto Spadim put forth on 2/6/2011 10:49 AM:

> [root@myhost block]# dd if=/dev/sda of=/dev/zero bs=8196

> [root@myhost block]# dd if=/dev/md0 of=/dev/zero bs=8196

/dev/zero is a read source, not a write target.  I'm surprised this doesn't bomb
out.  Use /dev/null for output.

-- 
Stan
