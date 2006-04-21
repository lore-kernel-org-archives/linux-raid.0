From: Mike Tran <mhtran@us.ibm.com>
Subject: Re: data recovery on raid5
Date: Fri, 21 Apr 2006 18:31:03 -0500
Message-ID: <44496B37.6040501@us.ibm.com>
References: <8867c2a014b34d9c11ce162c4f5860af@coraid.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8867c2a014b34d9c11ce162c4f5860af@coraid.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Hopkins <sah@coraid.com>
Cc: linux-raid@vger.kernel.org, jrs@abhost.net, support@coraid.com
List-Id: linux-raid.ids

Sam Hopkins wrote:

>Hello,
>
>I have a client with a failed raid5 that is in desperate need of the
>data that's on the raid.  The attached file holds the mdadm -E
>superblocks that are hopefully the keys to the puzzle.  Linux-raid
>folks, if you can give any help here it would be much appreciated.
>
># mdadm -V
>mdadm - v1.7.0 - 11 August 2004
># uname -a
>Linux hazel 2.6.13-gentoo-r5 #1 SMP Sat Jan 21 13:24:15 PST 2006 i686 Intel(R) Pentium(R) 4 CPU 2.40GHz GenuineIntel GNU/Linux
>
>Here's my take:
>
>Logfiles show that last night drive /dev/etherd/e0.4 failed and around
>noon today /dev/etherd/e0.0 failed.  This jibes with the superblock
>dates and info.
>
>My assessment is that since the last known good configuration was
>0 <missing>
>1 /dev/etherd/e0.0
>2 /dev/etherd/e0.2
>3 /dev/etherd/e0.3
>
>then we should shoot for this.  I couldn't figure out how to get there
>using mdadm -A since /dev/etherd/e0.0 isn't in sync with e0.2 or e0.3.
>If anyone can suggest a way to get this back using -A, please chime in.
>
>The alternative is to recreate the array with this configuration hoping
>the data blocks will all line up properly so the filesystem can be mounted
>and data retrieved.  It looks like the following command is the right
>way to do this, but not being an expert I (and the client) would like
>someone else to verify the sanity of this approach.
>
>Will
>
>mdadm -C /dev/md0 -n 4 -l 5 missing /dev/etherd/e0.[023]
>
>do what we want?
>
>Linux-raid folks, please reply-to-all as we're probably all not on
>the list.
>
>  
>
Yes, I would re-create the array with 1 missing disk.  mount read-only, 
verify your data.  If things are ok, remount read-write and remember to 
add a new disk to fix the degrade array.

With the "missing" keyword, no resync/recovery, thus the data on disk 
will be intact.

--
Regards,
Mike T.

