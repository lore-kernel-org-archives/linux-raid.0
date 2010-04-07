From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch mdadm] Add hot-unplug support to mdadm
Date: Wed, 7 Apr 2010 07:32:55 +0200
Message-ID: <20100407053255.GB16693@maude.comedia.it>
References: <4BBA1289.4010705@redhat.com> <20100407113035.3ca437f2@notabene.brown> <4BBBE7D2.6090608@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BBBE7D2.6090608@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 06, 2010 at 10:02:58PM -0400, Doug Ledford wrote:
>On 04/06/2010 09:30 PM, Neil Brown wrote:
>> - I cannot say I like the process of hunting through /proc/mdstat for
>>   a device name that textually matches the name that udev has just
>>   removed from /dev.  It feels too indirect.
>>   I was really hoping to just use /sys/$DEVPATH/holders to find the
>>   containing arrays, but $DEVPATH has been destroyed before udev
>>   gets to run anything .. even though the final object is still in
>>   use.  That is really sad!
>
>I agree.  The fact that everything disappears before we can use it to
>remove it from the array was a bit problematic.  And I too thought that
>this was too indirect and error prone.  But, the fact remains that A) if

Is there any chance of having udev issuing a pre-remove event, before
destroying /dev and sysfs, it would be far more useful than what we have
now.

L.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
