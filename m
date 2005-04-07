From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: How to move a singleton raid1 drive from raid1 /dev/md2 to /dev/md1
Date: Thu, 7 Apr 2005 15:41:05 +1000
Message-ID: <16980.51185.391624.438300@cse.unsw.edu.au>
References: <200504070125.09062.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mitchell Laks on Thursday April 7
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday April 7, mlaks@verizon.net wrote:
> Hi Software Raid Gurus!:
> 
> I have 
> 
> A1:~# cat /proc/mdstat
> Personalities : [raid1]
> md0 : active raid1 hdb1[0] hdg1[1]
>       244195904 blocks [2/2] [UU]
> 
> md1 : active raid1 hdc1[0]
>       244195904 blocks [1/1] [U]
> 
> md2 : active raid1 hde1[0]
>       244195904 blocks [1/1] [U]
> 
> Now I want to take /dev/hde1 and get rid of /dev/md2 and add /dev/hde1 
> to /dev/md1.

md1 is a 1-drive array.  You to make it a 2-drive array you need a
recent 2.6 kernel and a recent release of mdadm.  If you have these,
then

  mdadm -S /dev/md2  # shutdown md2 and release hde1
  mdadm /dev/md1 -a /dev/hde1 # add hde1 as a spare in md1
  mdadm -G -n2 /dev/md1 # grow md1 to have two devices.

If you don't have 2.6, then you will have to recreate md1 with
the desired number of components, which will require unmounting it.

   mdadm -S /dev/md2
   mdadm -S /dev/md1
   mdadm -C /dev/md1 -l1 -n2 /dev/hdc1 missing

   mdadm /dev/md1 -a /dev/hde1

NeilBrown
