From: Luca Berra <bluca@comedia.it>
Subject: Re: RAID-6 mdadm disks out of sync issue (more questions)
Date: Tue, 16 Jun 2009 05:38:28 +0200
Message-ID: <20090616033828.GA9370@maude.comedia.it>
References: <200906132027.n5DKRquL067127@cjb.net> <200906140710.n5E7A5o7074412@cjb.net> <b95d48b03b2756869e786c0982e54f86.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <b95d48b03b2756869e786c0982e54f86.squirrel@neil.brown.name>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Jun 14, 2009 at 06:11:44PM +1000, NeilBrown wrote:
>On Sun, June 14, 2009 5:10 pm, linux-raid.vger.kernel.org@atu.cjb.net wrote:
>> So here I was thinking everything was fine.  My six disks were working
>> for hours and the other two disks were loaded as spares and the first
>> one was rebuilding, up to 30% with an ETA of 5 hours.  I left the house
>> for a few hours and when I came back, the same disk with read errors
>> before had spontaneously disconnected and reconnected three times (I
>> saw in dmesg).  It probably got around 80% of the way through the six
>> hour rebuild.
>>
>> The problem is that when the /dev/sdc disk reconnected itself after,
>> it was marked as a "Spare", and now I can't use the same command any
>> longer:
>
>This doesn't make a lot of sense.  It should not have been marked as
>a spare unless someone explicitly tried to "Add" it to the array.
>
>I've been thinking that I need to improve mdadm in this respect
>and make it harder to accidentally turn a failed drive into a spare.
>
>However you description of event suggests that this was automatic
>which is strange.

udev?

>Can I get the complete kernel logs from when the rebuild started to
>when you finally gave up?  It might help me understand.

-- 
Luca Berra -- bluca@comedia.it
         Communication Media & Services S.r.l.
  /"\
  \ /     ASCII RIBBON CAMPAIGN
   X        AGAINST HTML MAIL
  / \
