From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Thu, 23 Apr 2009 08:09:38 +0200
Message-ID: <20090423060937.GB29487@maude.comedia.it>
References: <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090421181519.GA4114@lazy.lzy> <1240416414.10178.1.camel@cichlid.com> <9A77DB27-C12A-4BA2-94C4-D59B7DAFF32C@redhat.com> <20090423055132.GA29487@maude.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090423055132.GA29487@maude.comedia.it>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Apr 23, 2009 at 07:51:32AM +0200, Luca Berra wrote:
> On Wed, Apr 22, 2009 at 09:20:49PM -0400, Doug Ledford wrote:
>> On Apr 22, 2009, at 12:06 PM, Andrew Burgess wrote:
>>> On Tue, 2009-04-21 at 20:15 +0200, Piergiorgio Sartor wrote:
>>>
>>>> This might be a Fedora 10 issue, so maybe Doug would like
>>>> to comment.
>>>>
>>>> After reboot, someone, I guess udev, tries to automagically
>>>> start a RAID, so it assembles /dev/md_d127 with one of the
>>>> two components of /dev/md/boot (randomly, it seems).
>>>> Later, when /dev/md/boot is assembled, one drive is "busy",
>>>> because it belongs to /dev/md_d127, and the array is put
>>>> together degraded, i.e. with the other disk only.
>>>
>>> Just a "me too". I also started seeing this after upgrading to fedora
>>> 10. I had to create a startup script to stop md_d0 and reassemble
>>> everything else.
>>
>>
>> Yeah, I found the cause for this while working on F11.  The problem is a 
>> race condition between udev and a call to mdadm -As in the rc.sysinit.  
>> For F11, I solved this by making udev not process devices using 
>> incremental mode if we are still in the rc.sysinit script.  You can change 
>> /etc/udev/rules.d/70-mdadm.rules (I think that's the right name, it might 
>> be slightly off) to read something like this:
>>
>> # This file causes block devices with Linux RAID (mdadm) signatures to
>> # automatically cause mdadm to be run.
>> # See udev(8) for syntax
>>
>> SUBSYSTEM=="block", ACTION=="add", ENV{ID_FS_TYPE}=="linux_raid_member", \
>> 	IMPORT{program}="/sbin/mdadm --examine --export $tempnode", \
>> 	RUN+="/bin/bash -c '[ ! -f /dev/.in_sysinit ] && mdadm -I $env{DEVNAME}'"
>>
>>
>
> i believe i saw this as well, but not at startup, it was when i manually
> run mdadm -As, so while your hack to prevent udev from assembling
> devices while in sysinit may not be a full solution.
>
> my solution was "rm -f /etc/udev/rules.d/70-mdadm.rules",
> works like a charm :P
>
> probably the best solution is preventing concurrent mdadm rules with a
> lock.
s/rules/runs

> Regards,
> L.
>
>
>
>
> -- 
> Luca Berra -- bluca@comedia.it
>         Communication Media & Services S.r.l.
>  /"\
>  \ /     ASCII RIBBON CAMPAIGN
>   X        AGAINST HTML MAIL
>  / \
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
