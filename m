From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: I have a failed disk need help!
Date: Thu, 27 Mar 2003 19:20:27 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16002.46155.437541.288281@notabene.cse.unsw.edu.au>
References: <2999.204.250.25.205.1048753161.squirrel@webmail.bwkip.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from danfisher@bwkip.com on Thursday March 27
To: danfisher@bwkip.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 27, danfisher@bwkip.com wrote:
> We were preforming system updates on the system and had pulled the master
> out to keep a backup incase of disaster.  And so disaster hit and we want
> to reraid the master to the slave - Not so easy.  The kernel keeps wanting
> to use hdb but we want to mark hdb as failed and get it to boot to hda when
> hdb is in the mirror.

boot with kernel parameters:
   raid=noautodetect md=0,/dev/hda1 root=/dev/md0

(I assume /dev/hda1 is mirrored with /dev/hdb1 to form /dev/md0.  If
not, give more details, or just make obvious changes).

Then once you have booted, you can

  mdadm /dev/md0 -a /dev/hdb1
to add in /dev/hdb1.

If normally autodetect several partitions, you might want:

   raid=noautodetct md=0,/dev/hda1 md=1,/dev/hda2 md=2,/dev/hda3  .... root=/dev/md0

NeilBrown
