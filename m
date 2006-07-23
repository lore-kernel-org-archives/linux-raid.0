From: Paul Waldo <pwaldo@waldoware.com>
Subject: In Trouble--Please Help!  (was Re: Can't add disk to failed raid array)
Date: Sun, 23 Jul 2006 07:04:46 -0400
Message-ID: <200607230704.46377.pwaldo@waldoware.com>
References: <200607152056.55090.pwaldo@waldoware.com> <200607160824.04175.pwaldo@waldoware.com> <17596.29506.188695.678634@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <17596.29506.188695.678634@cse.unsw.edu.au>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Please, please! I am dead in the water!

To recap, I have a RAID6 array on a Fedora Core 5 system, using /dev/hd[acdeg]
2 and /dev/sd[ab]2.  /dev/hdd went bad so I replaced the drive and tried to 
add it back to the array.  Here is what happens:

#mdadm --assemble /dev/md1 /dev/hd[acdeg]2 /dev/sd[ab]2
mdadm: no RAID superblock on /dev/hdd2
mdadm: /dev/hdd2 has no superblock - assembly aborted

I also tried assembling without the new drive:
#mdadm --assemble /dev/md1 /dev/hd[aceg]2 /dev/sd[ab]2
mdadm: failed to RUN_ARRAY /dev/md1: Input/output error

Forgive me if the messages are not exactly correct, as I am booted into the FC 
rescue disk and I am transcribing what I see to another computer.

How can I get mdadm to use the new drive?  Am I completely fscked?  Thanks in 
advance for any help!!!!

Paul


On Tuesday 18 July 2006 01:36, Neil Brown wrote:
> On Sunday July 16, pwaldo@waldoware.com wrote:
> > Thanks for the reply, Neil.  Here is my version:
> > [root@paul log]# mdadm --version
> > mdadm - v2.3.1 - 6 February 2006
>
> Positively ancient :-)  Nothing obvious in the change log since then.
>
> Can you show me the output of
>   mdadm -E /dev/hdd2
>   mdadm -E /dev/hda2
>
> immediately after the failed attempt to add hdd2.
>
> Thanks,
> NeilBrown
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
