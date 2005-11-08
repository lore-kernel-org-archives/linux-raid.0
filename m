From: Neil Brown <neilb@suse.de>
Subject: Re: RAID 5 array keeps dropping drive on boot
Date: Tue, 8 Nov 2005 11:25:29 +1100
Message-ID: <17263.61561.506974.198576@cse.unsw.edu.au>
References: <2A807893-B5A6-4EF1-B862-1D6F22D71B60@fnuck.dk>
	<17263.57266.902113.362087@cse.unsw.edu.au>
	<5DD8751D-7FE2-4179-9887-853A704DE0D6@fnuck.dk>
	<17263.59743.163989.959271@cse.unsw.edu.au>
	<D8682F09-5A4D-4356-8FA6-825880F93AE4@fnuck.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Troels Bang Jensen on Tuesday November 8
Sender: linux-raid-owner@vger.kernel.org
To: Troels Bang Jensen <marvin@fnuck.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 8, marvin@fnuck.dk wrote:
> 
> All in all I have made 4 or 5 syncs now, each taking about 9 hours.  
> And I've made sure to shut down the computer cleanly afterwards.
> 

Ok.  Can you give me a complete boot log, rather than the edited
version.  There might be something important in there. 

> 
> Also, when hdc3 is marked faulty on the superblock on hda3 and hdg2,  
> shouldn't hdc3's superblock be updated? It seems to me that hdc3 gets  
> thoroughly ignored.

When hdc3 is marked faulty, it is assumed that it *is* faulty and so
md never tried to write to it again.  In particular it does not try to
write a superblock to it.  It simply writes a superblock to all
working devices, recording the hdc3 is faulty, and increasing the
event count, so that if hdc3 isn't actually completely faulty, it's
superblock will now be out of date.

> 
> Since hdc3 is in mdadm.conf I've been under the impression that mdadm  
> should at least say that it's missing.

When would it say that?  You aren't using mdadm to assemble the
arrays, you are using auto-detect.
If you use 
  mdadm --monitor ...

It will warn you about any degraded arrays, whether the device that is
missing is mentioned in mdadm.conf or not.

NeilBrown
