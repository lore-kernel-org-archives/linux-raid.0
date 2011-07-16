From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] mdadm.8: Disk coercion with IMSM metadata.
Date: Fri, 15 Jul 2011 18:10:12 -0700
Message-ID: <CAA9_cmfxqpqdpQoKAOgNUzuGNQTm3J2fARmht6vp4Umtqdx=bg@mail.gmail.com>
References: <20110713101702.26642.74636.stgit@maciek.naruszewicz>
	<20110714122649.5bd2c91e@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110714122649.5bd2c91e@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "maciej.naruszewicz" <maciej.naruszewicz@intel.com>, wojciech.neubauer@intel.com, adam.kwolek@intel.com, krzysztof.wojcik@intel.com, ed.ciechanowski@intel.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Jul 13, 2011 at 7:26 PM, NeilBrown <neilb@suse.de> wrote:
> On Wed, 13 Jul 2011 12:17:02 +0200 "maciej.naruszewicz"
> <maciej.naruszewicz@intel.com> wrote:
>
>> From: maciej.naruszewicz <maciej.naruszewicz@intel.com>
>>
>> Actual sizes of disks from different producers may vary,
>> even though they are claimed to have the same amount of
>> space
>
> Are you sure about this?
>
> It was my understanding that some industry association has arranged an
> agreement so that this does not happen.
>
> http://www.idema.org/wp-content/plugins/download-monitor/download.php?id=1223
>
> Do you have actual evidence that different drives from different
> manufacturers have similar but not identical sizes?
>

Hmm, seemed to be a case that needed handling when requirements were
being gathered, but perhaps recent drives don't do this any more?

Probably the more important part of this commit is that the man page
currently says that --size can not be used with container metadata...
but now that I have taken two seconds to think about it the light bulb
goes off...

--size is indeed irrelevant for:
   mdadm --create /dev/md/imsm /dev/sd[a-d] -e imsm

but my first reading of comment was that:
   mdadm --create /dev/md/vol0 /dev/md/imsm --size=$size
...is somehow not valid.

How about something like "For CONTAINER metadata --size is valid when
creating and growing subarrays, when creating a new container set
--size is irrelevant"

--
Dan
