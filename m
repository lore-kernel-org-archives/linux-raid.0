From: "Alex" <alexcos@nights.ro>
Subject: Fw: Raid1 questions (devel)
Date: Thu, 16 Sep 2004 00:20:56 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <001601c49b69$e4e809e0$6400a8c0@alex>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > Hello..
> >
> > I'm not sure if you are still developing the raid1 module for linux
kernel , but I'll give a shot.
> >
> > Checking the source code of linux.2.6.8.1 , in raid1.c , at line 411 I
found this:
> >     "Don't change to another disk for sequential reads"
> >
> > Well , my question is this:
> >
> >     If there is a sequential read , but there are other disks in the
array which are idle , isn't it a better way to read in chunks from all the
disks ?  I think the transfer rate will be much improved from reading from
more disks , rather the using only one  (altough is sequential read)
> >
> >
> > Thanks
> >     Alex
>

