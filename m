From: Luca Berra <bluca@comedia.it>
Subject: Re: Should I Start Over?
Date: Wed, 7 Jul 2004 16:51:05 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040707145105.GA30207@percy.comedia.it>
References: <1147.66.230.1.97.1088603162.squirrel@exitwound.org> <20040630165540.GA1099@percy.comedia.it> <1775.66.230.1.97.1088620939.squirrel@exitwound.org> <20040706210654.GB17694@percy.comedia.it> <1165.66.230.1.97.1089206618.squirrel@exitwound.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1165.66.230.1.97.1089206618.squirrel@exitwound.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 07, 2004 at 08:23:38AM -0500, Stephen Hargrove wrote:
>Luca Berra said:
>>
>> you can try to see if you can read your data by recreating the array in
>> degraded mode, so it does not rebuild.
>>
>> like:
>> mdadm --create /dev/md0 --level=5 /dev/hdc1 /dev/hdd1 missing
>> try substituting the word missing for each of the drives
>> and see if you can mount the filesystem
>> if you do find your data use:
>> mdadm /dev/md0 -a <the device you replaced with missing>
>> to have it added to the array again
>>
>
>
>Ok, I did the following:
>
># mdadm --create /dev/md0 --level=5 --raid-devices=3 /dev/hdg1 /dev/hdd1
>/dev/hdc1
you were supposed to replace one of the disks with the word "missing", so
you could test it before resyncing and try different disc combination to
see if you could get your data back.

>So is this good or bad?  Is my data gone forever (I gave up on it a while
>back, so if it's gone, it's gone)?
>
yes, your data is gone.

L.

-- 
Luca Berra -- bluca@comedia.it
        Communication Media & Services S.r.l.
 /"\
 \ /     ASCII RIBBON CAMPAIGN
  X        AGAINST HTML MAIL
 / \
