From: NiftyFedora Mitch <niftyfedora@niftyegg.com>
Subject: Re: Is My Data DESTROYED?!
Date: Mon, 2 Nov 2009 14:53:54 -0800
Message-ID: <1cd4f41f0911021453t7d3bf49dsb383528e1add2dc8@mail.gmail.com>
References: <200910262115.59160.tfjellstrom@shaw.ca>
	 <295369.82915.qm@web38803.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <295369.82915.qm@web38803.mail.mud.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: adfas asd <chimera_god@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Oct 27, 2009 at 6:37 AM, adfas asd <chimera_god@yahoo.com> wrote:
> --- On Mon, 10/26/09, Thomas Fjellstrom <tfjellstrom@shaw.ca> wrote:
>> A guy I know got a SuperMicro SC846E1-R900B case. 24
>> hotswap per chassis, with
>> the capability to chain in more of them to the same SAS
>> adapter. Rather
>> impressive. I can't afford a $1200 case though, not yet.
>
> Yes, it looks like the SuperMicro 3-5 for me.
>
>

Adfas,

It seems to me reading this long thread that some design and
practice might have helped here.

First Q: did you need a raid.
Next Q: did you rehearse and practice recovery.
Next Q; did you build a set of notes on how you built your RAID
Next Q: did you write down your rehearsed recovery procedures.

For HTPC I would not have build a RAID for a big storage
resource.  I might have built it for speed.

Having made lots of typos in my life I would not have built a
RAID in lieu of  a backup tool and process.

I would have built it as a set of individual disks
and individual file systems.
   a; a-bak
   b; b-bak
   etc.
  OR
   RaidA; RaidA-bak

I would alternate between A and B on the record process
and alternate a scripted rsync or cp based backup of data.
The script is to eliminate typo errors in my environment
and provide a log of what I did "Exactly".

I would consider playback from N or N-bak depending on which
device was not busy and if my software could be that smart.

It seems to me that simplicity from the system admin point
of view would win out in the design process.  Too often
the design process ignores how difficult it is for a system
admin to get it EXACTLY correct when it is something that
is done once a year or less and depends on configuration
and setup notes that are a year old, difficult to update
or exist on the RAID itself.

The number of times I have built some system setup
that works for years and then years later needs an update
or breaks....  boggles my mind and I have done it to myself
and know better.

Knowing RCS and friends helps!





-- 
        NiftyFedora
        T o m   M i t c h e l l
