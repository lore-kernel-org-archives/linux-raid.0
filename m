From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: changing major/minor numbers
Date: Mon, 20 May 2002 21:27:53 +1000 (EST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15592.56761.586254.465550@notabene.cse.unsw.edu.au>
References: <56D0E60C58BF6F4C8E5AB3EBF24599DC0157CF@ruby.reldata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kirill Malkin on Thursday May 16
To: Kirill Malkin <malkin@reldata.com>
Cc: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thursday May 16, malkin@reldata.com wrote:
> Hi,
> 
> I have a basic question about Linux RAID implementation: how to recover or
> restart a RAID set when the individual disks are moved to a different SCSI
> ID, i.e. when their minor (or major or both) number(s) change?
> 
> I've experimented with a RAID-1 configuration and found that whenever I move
> one of the disks to a different SCSI ID, the set must be recovered manually
> (i.e. raidhotadd) and the kernel initiates a full copy, even if raidtab is
> manually updated (I guess the system simply looks at the superblocks as the
> first choice). Is it possible to restart the set automatically or at least
> avoid the full copy?
> 
> Another question: is there a utility that could identify RAID sets before
> they are started, such as display the superblock contents and verify whether
> any devices are missing or have been moved? There seems to be a considerable
> amount of code, both in kernel and in raidtools, that prints out the content
> of the superblocks, but only if there is a problem or debug mode is
> on.

Get mdadm.
   http://www.cse.unsw.edu.au/~neilb/source/mdadm/

(1.0.0 is recommended, 1.0.1 is experimental).

It should answer all your questions.

NeilBrown

> 
> The main reason behind these questions is the emergence of iSCSI devices
> that could be connected in a random order thus breaking RAID functionality.
> It would be nice to identify such devices up-front, make necessary
> configuration changes and restart complete RAID sets without the full copy,
> even if the disks come up as different major/minor numbers. Please let me
> know if there's been any thinking in this direction.
> 
> Thank you in advance,
> Kirill
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
