From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: Recovery of failed RAID 6 and LVM
Date: Wed, 28 Sep 2011 13:42:25 -0600
Message-ID: <201109281342.25388.thomas@fjellstrom.ca>
References: <4E7EDE58.3000804@yazzy.org> <201109281256.10312.thomas@fjellstrom.ca> <4E8374DF.1030101@yazzy.org>
Reply-To: thomas@fjellstrom.ca
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E8374DF.1030101@yazzy.org>
Sender: linux-raid-owner@vger.kernel.org
To: lists@yazzy.org
Cc: stan@hardwarefreak.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On September 28, 2011, Marcin M. Jessa wrote:
> On 9/28/11 8:56 PM, Thomas Fjellstrom wrote:
> > On September 28, 2011, Marcin M. Jessa wrote:
> >> On 9/28/11 6:12 PM, Stan Hoeppner wrote:
> >>> On 9/28/2011 2:10 AM, Marcin M. Jessa wrote:
> >>>> On 9/28/11 4:50 AM, Stan Hoeppner wrote:
> >>>>> Reading the thread, and the many like it over the past months/years,
> >>>>> may yield a clue as to why you wish to move on to something other
> >>>>> than Linux RAID...
> >>>>> 
> >>>> :) I will give it another chance.
> >>>> 
> >>>> In case of failure FreeBSD and ZFS would be another option.
> >>> 
> >>> I was responding to Neil's exhaustion with mdadm. I was speculating
> >>> that help threads such as yours may be a contributing factor,
> >>> requesting/requiring Neil to become Superman many times per month to
> >>> try to save some OP's bacon.
> >> 
> >> That's what mailing lists are for. And more will come as long as there
> >> is no documentation on how to save your behind in case of failures like
> >> that. Or if the docs with examples available online are utterly useless.
> > 
> > I think that those of us that have been helped on the list should think
> > about contributing some wiki docs, if there's one we can edit.
> 
> I have a site, ezunix.org (a bit crippled since the crash) where I
> document anything I come across that can be useful.
> But after all the messages I still don't know what to do if you lose 3
> drives in a 5 drive RAID6 setup ;)
> I was told I was doing it wrong but never how to do it right.
> And that's the case of all the mailing lists I came across before I
> found that wikipedia site with incorrect instructions.

I think they did mention how to do it right. something like: mdadm --assemble 
--force

since 3 drives at once likely means the drives are fine. I recently lost ALL of 
the drives in my 7 drive raid5 array. First one was kicked, then the rest fell 
offline at the same time. Because the 6 drives all fell offline at the same time, 
their metadata all agreed on the current state of the array, so nothing other 
than some data that was stuck in the page cache was gone. In my case, after I 
ran: `mdadm --assemble --verbose /dev/md1 /dev/sd[fhijedg]`  only one drive 
was left out, which was the first drive to go. Then I ran: `mdadm --re-add 
/dev/md1 /dev/sdi` to add that drive back, and since I use the very nice 
bitmap feature, it only too my array a few minutes to resync.

-- 
Thomas Fjellstrom
thomas@fjellstrom.ca
