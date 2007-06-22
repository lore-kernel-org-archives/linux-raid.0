From: David Greaves <david@dgreaves.com>
Subject: Re: Degraded array on every reboot
Date: Fri, 22 Jun 2007 14:15:52 +0100
Message-ID: <467BCB88.9000603@dgreaves.com>
References: <4755.10.3.3.3.1182516663.squirrel@swilver.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4755.10.3.3.3.1182516663.squirrel@swilver.dyndns.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Hendrikx <hjohn@xs4all.nl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Hendrikx wrote:
> I'm not sure why this keeps going wrong, but I do know I made a mistake
> when initially reconstructing the array.  What I did was the following:
> 
> # mdadm /dev/md1 --add /dev/hde
> 
> Releazing that I didn't want to add the complete drive (/dev/hde) but only
> one of its partitions (/dev/hde1) I then did (while it was still
> rebuilding):
> 
> # mdadm /dev/md1 --fail /dev/hde
> # mdadm /dev/md1 --remove /dev/hde

I'm not 100% sure but it *may* have rebuilt the superblock.

do:
  mdadm --examine /dev/hde
  mdadm --examine /dev/hde1

If hde has a superblock then that could be picked up before the hde1 one.

(ah, read more of your email and you were on the right tracks :) )

To fix this do:
  mdadm --zero-superblock /dev/hde

Once all this is done you may want to run a check on the array.

There's probably other stuff going on with partition table caches too - blockdev 
-rereadpt may make a difference... but I suspect the --zero-superblock will just 
fix it all on the next boot.

David
