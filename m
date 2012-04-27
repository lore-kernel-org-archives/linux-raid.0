From: likewhoa <likewhoa@weboperative.com>
Subject: Re: raid10 issues after reorder of boot drives.
Date: Fri, 27 Apr 2012 19:26:57 -0400
Message-ID: <4F9B2B41.1010303@weboperative.com>
References: <4F9AFBC6.7070803@weboperative.com> <20120428080355.70585026@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120428080355.70585026@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

note this strange problem which doesn't seem related.

> cat /proc/mdstat
Personalities : [raid10]
md127 : inactive sdb3[8](S) sdf3[13](S) sda3[11](S) sdc3[9](S)
sdd3[12](S) sdg3[10](S) sde3[15](S)
      3160477768 blocks super 1.0
      
md0 : active raid10 sdd2[12] sdh2[0] sdb2[8] sdf2[13] sdg2[10] sda2[11]
sde2[14] sdc2[9]
      143358976 blocks super 1.0 256K chunks 2 near-copies [8/8] [UUUUUUUU]
     
unused devices: <none>

> mdadm -S /dev/md127
mdadm: error opening /dev/md127: No such file or directory


