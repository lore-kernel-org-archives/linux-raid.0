From: Pol Hallen <raid1@fuckaround.org>
Subject: Re: standard performance (write speed 65Mb/s)
Date: Fri, 22 Jul 2011 13:34:56 +0200
Message-ID: <201107221334.56823.raid1@fuckaround.org>
References: <201107181403.49563.raid1@fuckaround.org> <201107211957.16493.raid1@fuckaround.org> <4E28C32C.1020701@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E28C32C.1020701@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> *Put a filesystem on md0* and do:
> ~$ dd if=/dev/zero of=/some/dir/test.dd bs=4096 count=2621440
> And why on earth would you bother running this test while the array is
> still building?  Again, the resulting figure is worthless to everyone.

Ok.. I waiting finish rebuild and done new test:
 
dd if=/dev/zero of=/some/dir/test.dd bs=4096 count=2621440

Pol
