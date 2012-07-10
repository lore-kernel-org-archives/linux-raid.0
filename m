From: Brian Candler <B.Candler@pobox.com>
Subject: Re: Assembly failure
Date: Tue, 10 Jul 2012 19:59:27 +0100
Message-ID: <20120710185927.GA30164@nsrc.org>
References: <20120710163345.GB29855@nsrc.org>
 <4FFC5CC0.8050808@profitbricks.com> <20120710170646.GA29962@nsrc.org>
 <4FFC68AB.4010801@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4FFC68AB.4010801@profitbricks.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sebastian Riemer <sebastian.riemer@profitbricks.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Jul 10, 2012 at 07:38:51PM +0200, Sebastian Riemer wrote:
> Your kernel is similar to v3.4 mainline. Your kernel has been compiled
> one day after Linus tagged v3.4. This kernel has major issues. Please
> reboot into the old 3.2 kernel.
> 
> Your kernel has no tag in the Ubuntu Git repos!
> 
> http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-precise.git;a=tags
> http://kernel.ubuntu.com/git?p=ubuntu/ubuntu-quantal.git;a=tags
> 
> Your kernel is absolutely unstable. Who built this kernel? Can't be
> official release!

I don't know who makes ~kernel-ppa packages.

Anyway, box is now on linux-image-3.2.0-24-generic. Same problem:

brian@dev-storage1:~$ cat /proc/mdstat
Personalities : [linear] [multipath] [raid0] [raid1] [raid6] [raid5] [raid4] [raid10] 
md127 : inactive sdm[1](S) sdg[5](S) sdh[4](S) sdd[3](S) sdj[9](S) sdl[11](S) sdi[8](S) sdk[10](S) sdb[0](S) sde[7](S) sdf[6](S) sdc[2](S)
      35163186720 blocks super 1.2
       
unused devices: <none>

What's my best next step? There's nothing critical on here, but I would like
to use this as practice of recovering a broken md raid volume.

Regards,

Brian.
