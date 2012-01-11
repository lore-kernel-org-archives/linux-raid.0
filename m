From: Bobby Kent <bpkent@wholeworldwindow.net>
Subject: RE: Meaning of "Used Dev Space" in "mdadm --detail" output for a 6
 disk RAID10 array
Date: Tue, 10 Jan 2012 19:44:42 -0500
Message-ID: <00de01cccffa$34e8afe0$9eba0fa0$@wholeworldwindow.net>
References: <007601cccf3e$72191470$564b3d50$@wholeworldwindow.net>
 <20120110140851.56f53921@notabene.brown>
 <00b901cccfcb$ab5225a0$01f670e0$@wholeworldwindow.net>
 <20120111064857.491a31b2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <20120111064857.491a31b2@notabene.brown>
Content-language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: 'NeilBrown' <neilb@suse.de>
Cc: 'linux-raid' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tuesday, January 10, 2012 14:49 On Behalf Of NeilBrown <
linux-raid-owner@vger.kernel.org> wrote:

>> Are there any other factors I should consider (e.g. kernel version 
>> compatibility)?
>
> Some newer features - such as bad-block lists - are only supported 
> for 1.x metadata.
> 
> Certainly use 1.x for new arrays, but I wouldn't bother converting 
> old arrays unless you wanted to convert to large devices (and current 
> kernel/mdadm can handle 4TB with 0.90 - the 2TB limit was a bug).

Many thanks for this and the other recommendations.  I'll be sure to add
MAGIC_SYSRQ to my kernel config in addition to LOCKUP_DETECTOR and
DETECT_HUNG_TASK.

Bobby

