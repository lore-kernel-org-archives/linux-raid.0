From: Luca Berra <bluca@comedia.it>
Subject: Re: Should I Start Over?
Date: Tue, 6 Jul 2004 23:06:55 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040706210654.GB17694@percy.comedia.it>
References: <1147.66.230.1.97.1088603162.squirrel@exitwound.org> <20040630165540.GA1099@percy.comedia.it> <1775.66.230.1.97.1088620939.squirrel@exitwound.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1775.66.230.1.97.1088620939.squirrel@exitwound.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jun 30, 2004 at 01:42:19PM -0500, Stephen Hargrove wrote:
>$ mdadm --examine /dev/hd[dceg]1
>mdadm: No super block found on /dev/hdc1 (Expected magic a92b4efc, got
>00000000)
>mdadm: No super block found on /dev/hdd1 (Expected magic a92b4efc, got
>00000000)
>mdadm: No super block found on /dev/hde1 (Expected magic a92b4efc, got
>00000000)
>mdadm: No super block found on /dev/hdg1 (Expected magic a92b4efc, got
>00000000)
>
urgh,
no superblock
you can try to see if you can read your data by recreating the array in
degraded mode, so it does not rebuild.

like:
mdadm --create /dev/md0 --level=5 /dev/hdc1 /dev/hdd1 missing
try substituting the word missing for each of the drives
and see if you can mount the filesystem
if you do find your data use:
mdadm /dev/md0 -a <the device you replaced with missing>
to have it added to the array again

good luck!

L.


-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
