From: David Greaves <david@dgreaves.com>
Subject: Re: Two Drive Failure on RAID-5
Date: Thu, 22 May 2008 09:38:40 +0100
Message-ID: <48353110.8060602@dgreaves.com>
References: <loom.20080519T224713-779@post.gmane.org> <4832966A.3010707@dgreaves.com> <loom.20080521T140522-597@post.gmane.org> <483482E2.60300@dgreaves.com> <09ed01c8bb83$ec3f7230$9300a8c0@dcccs> <loom.20080521T210407-628@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20080521T210407-628@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Cry <cry_regarder@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cry wrote:
> Janos Haar <janos.haar <at> netcenter.hu> writes:
>>> No. /dev/sdg1 is a *partition* on your old drive.
> 
> Nope.  /dev/sda is my old drive.  It has NO partitions because I was 
> retarded 1 year ago:
> 
> Folks, I made a mistake when I created my original raid array 
> (there is a note about it in the archives of this group) that 
> I built the array on the raw drives, not on partitions.
That is not a 'problem' although it is not regarded as best practice.

> /dev/sda IS the drive.  There is no /dev/sda1.  However, the 
> replacement drive is a 750Gig (not 500 like the originals) so 
> I built a partition on the drive of the correct size: /dev/sdg1.
And you didn't think to mention this?
Maybe you thought it would be in the support file I keep for you?


When people offer suggestions they (or at least I) will probably form a picture
of what's going on - if you are going to throw tweaks into the mix then they may
throw us off. Mention them.

You have failed to answer some potentially relevant questions and, before you
get this array rebuilt you wandered off (on the same thread) into discussions
about what disk drives you might like to buy, the best type of external
enclosure and various other oddments. This is not helpful.

>The correct information should already be in /dev/sdg1 since I copied the entire
>/dev/sda there (probably overwrote stuff in /dev/sdg2 since /dev/sda was 160K
>bigger than /dev/sdg1).
Err, no. Linux doesn't randomly overwrite other partitions...

You're on 0.9 superblocks which are located at the end of the disk.

I *think* your assemble problem is that /dev/sdg1 was an old component (slot 6);
it had a superblock near the end of the partition which you didn't zero. You
copied most of /dev/sda into it but you made /dev/sdg1 too small by a few k. The
copy finished before it copied the /dev/sda superblock (I don't know why it
didn't overwrite the old superblock??). Also, at some point, md will try and
seek past the end of /dev/sdg1 and will die.

You have now dug a maze of twisty passages...

I think at this point you should enlarge /dev/sdg1, recopy /dev/sda to /dev/sdg1
and try again. That will probably work.

David

