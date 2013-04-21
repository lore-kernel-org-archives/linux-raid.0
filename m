From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: md RAID5: Disk wrongly marked "spare", need to force re-add it
Date: Sun, 21 Apr 2013 15:23:49 +0800
Message-ID: <51739405.1060805@fnarfbargle.com>
References: <516869D2.9030506@bucksch.org> <516B3077.9020507@schinagl.nl> <516B590C.5060807@bucksch.org> <516AE7A0.4070504@schinagl.nl> <516BD5E0.4040007@bucksch.org> <516FF25B.4000907@bucksch.org> <516FFC13.2030803@ultratux.net> <5171CB91.1040708@bucksch.org> <5171EED3.8030505@bucksch.org> <5171F52D.4040701@bucksch.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5171F52D.4040701@bucksch.org>
Sender: linux-raid-owner@vger.kernel.org
To: Ben Bucksch <linux.news@bucksch.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/04/13 09:53, Ben Bucksch wrote:
> Ben Bucksch wrote, On 20.04.2013 03:26:
>> I can read my files again, without problem, all is happy.
>
> Actually, no. XFS filesystem structure is not sane. I must have done
> something wrong. (If possible, please let me know what, all data should
> be posted.)
>
> At first, it looked OK, as if only one recently written directory was
> broken. I unmounted one of the FS, did xfs_repair, and after
> re-mounting, almost all directories are gone. Almost 100% dataloss. I
> can't describe how upset I am against md.

As others have already told you, md does not go randomly kicking drives 
from arrays. Your system had a failure of some kind which caused the 
loss of two drives. You tried to recover it and managed to get a drive 
into the spare state. After much troubleshooting, you used the canon of 
last resort "assume-clean" after which (without properly verifying your 
drives were in the correct order) you ran a terribly destructive write 
to the disks and have almost certainly ruined any chance you had at 
recovering your data.

I fail to see where the fault lies with md.

Had you searched or asked a little more, you would have found a number 
of people who have written permutation scripts which would have iterated 
every possible arrangement of drives to allow you to run a read-only 
fsck on each one, which would have positively identified the correct 
order of your disks.

Your best bet now is to post on the xfs list to find out if there is 
_any_ way of undoing what you just did, or working around it (backup 
superblocks or whatever) and then running a permutation on your drives 
to see if any combination shows you any valid data.

