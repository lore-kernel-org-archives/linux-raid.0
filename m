From: Mitchell Laks <mlaks@verizon.net>
Subject: Re: How to move a singleton raid1 drive from raid1 /dev/md2 to /dev/md1
Date: Fri, 08 Apr 2005 00:29:39 -0400
Message-ID: <200504080029.39899.mlaks@verizon.net>
References: <200504070125.09062.mlaks@verizon.net>
 <16980.51185.391624.438300@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-8-i
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <16980.51185.391624.438300@cse.unsw.edu.au>
Content-disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thanks you Neil!!

i am running debian sarge with 1.9 and kernel 2.6.8
I followed  your instructions 

  mdadm -S /dev/md2  # shutdown md2 and release hde1
  mdadm /dev/md1 -a /dev/hde1 # add hde1 as a spare in md1
  mdadm -G -n2 /dev/md1 # grow md1 to have two devices.

and now

wustl@A1:~$ cat /proc/mdstat
Personalities : [raid1]
md0 : active raid1 hdb1[0] hdg1[1]
      244195904 blocks [2/2] [UU]

md1 : active raid1 hde1[1] hdc1[0]
      244195904 blocks [2/2] [UU]


Yay!!!

Thank you very much.

Mitchell

