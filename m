From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: fsck on raidvolumes at boot
Date: Sun, 11 May 2003 16:39:38 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16061.61482.79132.824395@notabene.cse.unsw.edu.au>
References: <871y0ejtdf.fsf@jumper.lonesom.pp.fi>
	<Pine.OSF.4.51.0305102009550.135362@soul.helsinki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Mikael Johansson on Saturday May 10
To: Mikael Johansson <mpjohans@pcu.helsinki.fi>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Saturday May 10, mpjohans@pcu.helsinki.fi wrote:
> 
> Hello All!
> 
> When making an unclean shutdown/reset of the system, Linux normally checks
> the disk partitions at boot with fsck (e2fsck). For raided mounts this
> does not happen however, instead only a warning message of "unclean
> partition mounted" (or similar) appears, as fstab is read and, say,
> /dev/md0 gets mounted to, say, /wrk.
> 
> Is there a way to make Linux automatically check the /dev/md*'s before
> mounting them if they are dirty?

What number do you have in column 6 of /etc/fstab for these
filesystems?
If 0, make it non-zero.

NeilBrown

> 
> I'm using Debian 3.0 and raidtools2.
> 
> Have a nice weekend,
>     Mikael J.
>     http://www.helsinki.fi/~mpjohans/
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
