From: =?ISO-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Subject: Re: pata_via with software raid1: "attempt to access beyond end of
 device"
Date: Thu, 19 Jul 2007 15:23:18 -0300
Message-ID: <mpm4n4-dr3.ln1@tux.abusar.org>
References: <dju2n4-lcf.ln1@tux.abusar.org>
	<18078.57482.951240.250360@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Jul 2007 13:54:50 +1000
Neil Brown <neilb@suse.de> wrote:

> The resierfs filesystem is trying to access beyond the end of the
> raid1 array.  Maybe some indexing information in the array is
> corrupted.
> Did you recreate the array (mdadm --create) after changing to the new
> drivers?  If so, could you have accidentally made it a little smaller?
> 
> Possibly try running fsck and see if it finds anything to fix.

	Hi Neil, I recreated the array after changing to libata. I
checked the whole filesystem with reiserfsck --rebuild-tree, then
started it again and the problem happens suddenly.

	And regarding the size of array, I just added the whole
partition to the array:

Filesystem           1K-blocks      Used Available Use% Mounted on
/dev/md1              77639736  30127524  47512212  39% /

     Array Size : 77642048 (74.05 GiB 79.51 GB)
  Used Dev Size : 77642048 (74.05 GiB 79.51 GB)

	Can I compare both values (77639736 with 77642048)? If so,
there is a difference, if not, I don't know.

	Thank you!

	Ps: the error is difficult to appear, but I'll keep looking on
it and try to ellaborate a more detailed report. 

-- 
Linux 2.6.22: Holy Dancing Manatees, Batman!
http://www.lastfm.pt/user/danielfraga
http://u-br.net

