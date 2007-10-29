From: Luca Berra <bluca@comedia.it>
Subject: Re: Raid-10 mount at startup always has problem
Date: Mon, 29 Oct 2007 08:41:39 +0100
Message-ID: <20071029074139.GA15475@percy.comedia.it>
References: <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com> <47202D17.3040000@amfes.com> <1193294406.10336.76.camel@firewall.xsintricity.com> <20071026091513.GB32550@percy.comedia.it> <1193426793.10336.302.camel@firewall.xsintricity.com> <4725278E.1050306@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4725278E.1050306@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Oct 28, 2007 at 08:21:34PM -0400, Bill Davidsen wrote:
>>Because you didn't stripe align the partition, your bad.
>>   
>Align to /what/ stripe? Hardware (CHS is fiction), software (of the RAID 
the real stripe (track) size of the storage, you must read the manual
and/or bug technical support for that info.
>you're about to create), or ??? I don't notice my FC6 or FC7 install 
>programs using any special partition location to start, I have only run 
>(tried to run) FC8-test3 for the live CD, so I can't say what it might 
>do. CentOS4 didn't do anything obvious, either, so unless I really 
>misunderstand your position at redhat, that would be your bad.  ;-)
>
>If you mean start a partition on a pseudo-CHS boundary, fdisk seems to 
>use what it thinks are cylinders for that.
Yes, fdisk will create partition at sector 63 (due to CHS being braindead,
other than fictional: 63 sectors-per-track)
most arrays use 64 or 128 spt, and array cache are aligned accordingly.
So 63 is almost always the wrong choice.

for the default choice you must consider what spt your array uses, iirc
(this is from memory, so double check these figures)
IBM 64 spt (i think)
EMC DMX 64
EMC CX 128???
HDS (and HP XP) except OPEN-V 96
HDS (and HP XP) OPEN-V 128
HP EVA 4/6/8 with XCS 5.x state that no alignment is needed even if i
never found a technical explanation about that.
previous HP EVA versions did (maybe 64).
you might then want to consider how data is laid out on the storage, but
i believe the storage cache is enough to deal with that issue.

Please note that "0" is always well aligned.

Note to people who is now wondering WTH i am talking about.

consider a storage with 64 spt, an io size of 4k and partition starting
at sector 63.
first io request will require two ios from the storage (1 for sector 63,
and one for sectors 64 to 70)
the next 7 io (71-78,79-86,97-94,95-102,103-110,111-118,119-126) will be
on the same track
the 8th will again require to be split, and so on.
this causes the storage to do 1 unnecessary io every 8. YMMV.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
