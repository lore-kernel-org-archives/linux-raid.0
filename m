From: "T. Ermlich" <pelegrine@gmx.net>
Subject: Re: Broken harddisk
Date: Sun, 30 Jan 2005 00:12:48 +0100
Message-ID: <41FC1870.1090102@gmx.net>
References: <41FAD73F.1070504@gmx.net> <Pine.LNX.4.56.0501291218200.25299@lion.drogon.net> <41FBAD0B.2080408@gmx.net> <Pine.LNX.4.56.0501291538270.25299@lion.drogon.net> <41FBBE1B.7060406@gmx.net> <41FBD35E.2020404@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41FBD35E.2020404@gmx.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Got it up and running again.

I had to delete /dev/md0 & /dev/md1, and create them new.
Due to my backups no single file was lost ... :-)

But now I get these messages when booting the system (I don't know if 
the came up in the past, too ... I never noticed them):

   ...
   <6>md: Autodetecting RAID arrays.
   <3>md: could not bd_claim sda5.
   <3>md: could not bd_claim sda6.
   <3>md: could not bd_claim sdb5.
   <3>md: could not bd_claim sdb6.
   <3>md: could not bd_claim sdb7.
   <3>md: could not bd_claim sdb8.
   <6>md: autorun ...
   ...
   Disk /dev/md0 does not contain a valid partition table
   Disk /dev/md1 does not contain a valid partition table
   Disk /dev/md2 does not contain a valid partition table
   Disk /dev/md3 does not contain a valid partition table

What else does I have to do?

Thanks a lot!!
Torsten

T. Ermlich scribbled on 29.01.2005 19:18:

[...]

