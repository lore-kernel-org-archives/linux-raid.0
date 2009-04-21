From: Luca Berra <bluca@comedia.it>
Subject: Re: [Patch] mdadm ignoring homehost?
Date: Tue, 21 Apr 2009 08:29:50 +0200
Message-ID: <20090421062950.GA13520@maude.comedia.it>
References: <20090417183952.GA6090@lazy.lzy> <20090418075436.GA2124@maude.comedia.it> <20090418083609.GA4436@lazy.lzy> <20090418101954.GA1448@maude.comedia.it> <20090418130656.GA3344@lazy.lzy> <18924.3824.677493.129885@notabene.brown> <20090420181736.GB4236@lazy.lzy> <20090420211332.GA5550@maude.comedia.it> <20090420212444.GA5193@lazy.lzy> <A52FE0A1-DC54-4786-9FE0-C0251C78C9FD@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <A52FE0A1-DC54-4786-9FE0-C0251C78C9FD@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 20, 2009 at 07:47:36PM -0400, Doug Ledford wrote:
> On Apr 20, 2009, at 5:24 PM, Piergiorgio Sartor wrote:
>> On Mon, Apr 20, 2009 at 11:13:32PM +0200, Luca Berra wrote:
>>> add --auto=md to the command line
>>> or put it in the create line in mdadm.conf
>>
>> Thanks, that did the trick!
>>
>> Interesting, it seems now I have 3 devices
>> for that raid.
>> One is /dev/md127, one is /dev/md/boot, with
>> same (major, minor) as md127, and there is a
>> third one, /dev/md_boot, which is a symbolic
>> link to /dev/md/boot.
>>
>> /proc/mdstat reports /dev/md127
>
> And so the confusion is perpetuated.  This is *not* accessing a device by 
> name.  If I give mdadm a name for my device, I don't want it doing 
> *anything* with numbers, creating numbered symlinks, or anything else.  In 
> addition, if I tell mdadm to create something in /dev/md/ (versus it 
> decided all on its own to create something there), then I do *NOT* want it 
> creating *anything* in /dev/ that I didn't ask for.  That, again, adds to 
> the confusion.  Of all of it though, the /proc/mdstat is the worst part as 
> it underscores that the kernel stack is not able to think in terms of names 
> instead of numbers.
>
and md is not even the worst case, think of device-mapper where
dm-<minor> could be anything from a multipath san storage to lvm or
encrypted partition or even a normal partition mapped via kpartx :P

I believe we should add a mdstat command that should replace 'cat
/proc/mdstat' hiding the gory details.
and device-file creation could be configurable.

L.


-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
