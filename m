From: Thomas Jarosch <thomas.jarosch@intra2net.com>
Subject: Re: ANNOUNCE: mdadm 2.6.2 - A tool for managing Soft RAID under Linux
Date: Tue, 29 May 2007 18:29:54 +0200
Message-ID: <200705291829.54274.thomas.jarosch@intra2net.com>
References: <18001.9765.808761.531809@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18001.9765.808761.531809@notabene.brown>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Neil,

On Monday, 21. May 2007, you wrote:
> I am pleased to announce the availability of
>    mdadm version 2.6.2

Thanks for releasing mdadm 2.6.2. It contains a fix for "--test"
I was looking for right at the moment :-)

mdadm fails to compile if you enable "-O2" using gcc 4.1.1 because of -Werror:

cc1: warnings being treated as errors
sysfs.c: In function 'sysfs_read':
sysfs.c:97: warning: value computed is not used
sysfs.c:119: warning: value computed is not used
sysfs.c:127: warning: value computed is not used
sysfs.c:133: warning: value computed is not used
sysfs.c:139: warning: value computed is not used
sysfs.c:178: warning: value computed is not used


Cheers,
Thomas
