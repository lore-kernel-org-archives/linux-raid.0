From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Thu, 23 Apr 2009 23:31:55 +0200
Message-ID: <20090423213155.GA7993@maude.comedia.it>
References: <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com> <20090423055132.GA29487@maude.comedia.it> <F296B205-3CE7-4130-813D-66D63D78AE89@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <F296B205-3CE7-4130-813D-66D63D78AE89@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 23, 2009 at 07:05:04AM -0400, Doug Ledford wrote:
>>> # This file causes block devices with Linux RAID (mdadm) signatures to
>>> # automatically cause mdadm to be run.
>>> # See udev(8) for syntax
>>>
>>> SUBSYSTEM=="block", ACTION=="add", ENV{ID_FS_TYPE}=="linux_raid_member", 
>>> \
>>> 	IMPORT{program}="/sbin/mdadm --examine --export $tempnode", \
>>> 	RUN+="/bin/bash -c '[ ! -f /dev/.in_sysinit ] && mdadm -I 
>>> $env{DEVNAME}'"
>>>
>>>
>>
>> i believe i saw this as well, but not at startup, it was when i manually
>> run mdadm -As, so while your hack to prevent udev from assembling
>> devices while in sysinit may not be a full solution.
>
> No, it is.  In your situation, the rules line must have read 
> ACTION="add|change".  The fact that the incremental assembly rule would 
you are probably right about that, i tried with your ruleset and it
looks like the problem was due to the change ACTION
just out of curiosity what is the use of the IMPORT statement, is it
needed by some other rule?

>> my solution was "rm -f /etc/udev/rules.d/70-mdadm.rules",
>> works like a charm :P
>>
>> probably the best solution is preventing concurrent mdadm rules with a
>> lock.

do you think the last suggestion of having mdadm protect from itself
would be of use?
I think it might still happen when stacking arrays
i.e. mirror of stripes
running mdadm -As would activate the first striped md and generate and 'add'
event, then while it is assembling the second one udev will trigger and
create a degraded mirror containing only the first one.

Regards,
L.



-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
