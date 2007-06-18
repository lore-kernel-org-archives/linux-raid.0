From: david@lang.hm
Subject: Re: limits on raid
Date: Mon, 18 Jun 2007 11:40:58 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0706181138210.12717@asgard.lang.hm>
References: <18034.479.256870.600360@notabene.brown>
 <Pine.LNX.4.64.0706142034400.29630@asgard.lang.hm> <18034.3676.477575.490448@notabene.brown>
 <20070616020320.GB2002@animx.eu.org> <18035.23867.576212.859440@notabene.brown>
 <Pine.LNX.4.64.0706160037220.7557@asgard.lang.hm> <4676BEC2.7090809@redhat.com>
 <Pine.LNX.4.64.0706181026170.12717@asgard.lang.hm> <20070618180327.GP10008@csclub.uwaterloo.ca>
 <Pine.LNX.4.64.0706181111020.12717@asgard.lang.hm> <20070618183324.GL10006@csclub.uwaterloo.ca>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S932200AbXFRSnc@vger.kernel.org>
In-Reply-To: <20070618183324.GL10006@csclub.uwaterloo.ca>
Sender: linux-kernel-owner@vger.kernel.org
To: Lennart Sorensen <lsorense@csclub.uwaterloo.ca>
Cc: Brendan Conoboy <blc@redhat.com>, Neil Brown <neilb@suse.de>, Wakko Warner <wakko@animx.eu.org>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 18 Jun 2007, Lennart Sorensen wrote:

> On Mon, Jun 18, 2007 at 11:12:45AM -0700, david@lang.hm wrote:
>> simple ultra-wide SCSI to a single controller.
>
> Hmm, isn't ultra-wide limited to 40MB/s?  Is it Ultra320 wide?  That
> could do a lot more, and 220MB/s sounds plausable for 320 scsi.

yes, sorry, ultra 320 wide.

>> I didn't realize that the rate reported by /proc/mdstat was the write
>> speed that was takeing place, I thought it was the total data rate (reads
>> + writes). the next time this message gets changed it would be a good
>> thing to clarify this.
>
> Well I suppose itcould make sense to show rate of rebuild which you can
> then compare against the total size of tha raid, or you can have rate of
> write, which you then compare against the size of the drive being
> synced.  Certainly I would expect much higer speeds if it was the
> overall raid size, while the numbers seem pretty reasonable as a write
> speed.  4MB/s would take for ever if it was the overall raid resync
> speed.  I usually see SATA raid1 resync at 50 to 60MB/s or so, which
> matches the read and write speeds of the drives in the raid.

as I read it right now what happens is the worst of the options, you show 
the total size of the array for the amount of work that needs to be done, 
but then show only the write speed for the rate pf progress being made 
through the job.

total rebuild time was estimated at ~3200 min

David Lang
