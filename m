From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: system hangs when failing a disk
Date: Fri, 28 Mar 2003 10:07:24 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16003.33836.695187.142156@notabene.cse.unsw.edu.au>
References: <200303271902.LAA30464@foothill.seas.ucla.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Stephen C. Woods on Thursday March 27
To: "Stephen C. Woods" <scw@seas.ucla.edu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday March 27, scw@seas.ucla.edu wrote:
>    We're working on setting up a largish raid array, but the problem
> also occurs with a small (3 disk raid 5) array.
> 
>    If a disk is failed under a heavy I/O load, where heavy can be
> recreated by untaring a couple of large tarballs from and onto the
> array, there is about a 2/3 chance that the entire array will freeze.
> This freeze occurs with forcing a failure by unpluging (hot plugable SCA
> disks) a disk, and also when the disk is failed with mdadm.
> 
>    When this happens the system becomes pretty much unresponsive (as in
> it pings but you can't rsh in,  console login sometimes works and
> sometimes doesn't but if you peek at /proc/<anything raidish> that dies
> too.
> 
>   2.4.18-19.8.0 (Redhat 8.0)

Well, it would always be worth trying a more recent kernel - 2.4.20
for example.

> 
>    Any hints (other than "don't fail disks under heavy load.")?
> 

Unplugging a drive can cause temporary poor response as each request
in the queue may be re-tried several times.  This should appear as
lots of error messages on the console.  While "temporary" this can
take a long time, depending on the SCSI driver.

However this wouldn't explain a similar symptom when using "mdadm -f"
to fail a drive as in that case all active requests are allowed to
complete normally.

Are there any console message (or in 'dmesg')?  An Oops or something
maybe?

NeilBrown


> -----
> Stephen C. Woods; UCLA SEASnet; 2567 Boelter hall; LA CA 90095; (310)-825-8614
> Unless otherwise noted these statements are my own, Not those of the 
> University of California.                      Internet mail:scw@seas.ucla.edu
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
