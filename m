From: Tim Small <tim@seoss.co.uk>
Subject: Re: a general question re. linux-raid stability
Date: Tue, 21 Sep 2010 10:27:19 +0100
Message-ID: <4C987A77.7050903@seoss.co.uk>
References: <1284774145-14543-1-git-send-email-tmarri@apm.com> <20100918210920.E05AE157D71@gemini.denx.de> <7707889dee57e97ad50b4ce5c7697466@mail.gmail.com> <4C97DFB4.1010705@meetinghouse.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C97DFB4.1010705@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 20/09/10 23:27, Miles Fidelman wrote:
> Folks,
>
> I've been watching patch after patch go by on this list, which leads 
> me to wonder - how stable are the basic raid kernel modules, and 
> mdadm, as included in major linux distributions (in my case, Debian 
> Lenny)?

Pretty good - we use it on a few tens of servers.  Overall we find it 
easier to manage, and more reliable than hardware RAID...

Debian definitely gets updates - although the Debian team could probably 
do with more help keeping tabs on them.  Two good cross-reference 
sources are probably this list, and the RHEL kernel update changelogs.....

tim@zebedee:~$ cat /etc/debian_version
5.0.6
tim@zebedee:~$ zgrep -i raid 
/usr/share/doc/linux-image-2.6.26-2-amd64/changelog.Debian.gz | egrep -v 
'(aacraid|megaraid|cpq|5c1|dm|DM|cciss|LVM|sym)'
   * raid456: Fix two bugs in handling of degraded states (Closes: #581392)
     - Prevent reshaping of doubly-degraded RAID4
     - Enable error-correction on singly-degraded RAID6
     - md: fix raid5 'repair' operations
     - Fix sparc64 niagara optimized RAID xor asm
     - md: raid5: fix clearing of biofill operations
     - raid5: fix unending write sequence
     - md: handle writes to broken raid10 arrays gracefully
     - md: raid10: fix use-after-free of bio
     - md: Avoid overflow in raid0 calculation with large components.
     - md/raid1 to a filesystem.
     - md: Fix raid10 recovery problem.
     - Fix various bugs with aligned reads in RAID5.
   * Fix raid1 recovery (closes: #406181)
     - Set a default raid level on a volume that either does not support
   * Enable raid456 for mips/mipsel qemu kernel.
     - md: Fix calculation of ->degraded for multipath and raid10
     - MD: Fix a potential NULL dereference in md/raid1
     - md: Avoid oops when attempting to fix read errors on raid10


Tim.

-- 
South East Open Source Solutions Limited
Registered in England and Wales with company number 06134732.
Registered Office: 2 Powell Gardens, Redhill, Surrey, RH1 1TQ
VAT number: 900 6633 53  http://seoss.co.uk/ +44-(0)1273-808309

