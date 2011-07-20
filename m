From: "Naruszewicz, Maciej" <maciej.naruszewicz@intel.com>
Subject: RE: [PATCH] mdadm.8: Disk coercion with IMSM metadata.
Date: Wed, 20 Jul 2011 13:54:17 +0100
Message-ID: <8E4BA8CF4D51C54CA1EBF236665899BD52B1D75E30@irsmsx502.ger.corp.intel.com>
References: <20110713101702.26642.74636.stgit@maciek.naruszewicz>
	<20110714122649.5bd2c91e@notabene.brown>
 <CAA9_cmfxqpqdpQoKAOgNUzuGNQTm3J2fARmht6vp4Umtqdx=bg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmfxqpqdpQoKAOgNUzuGNQTm3J2fARmht6vp4Umtqdx=bg@mail.gmail.com>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>, NeilBrown <neilb@suse.de>
Cc: "Kwolek, Adam" <adam.kwolek@intel.com>, "Wojcik, Krzysztof" <krzysztof.wojcik@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Grabowski, Grzegorz" <grzegorz.grabowski@intel.com>
List-Id: linux-raid.ids

> -----Original Message-----
> From: dan.j.williams@gmail.com [mailto:dan.j.williams@gmail.com] On Behalf Of Dan Williams
> Sent: Saturday, July 16, 2011 3:10 AM
> To: NeilBrown
> Cc: Naruszewicz, Maciej; Neubauer, Wojciech; Kwolek, Adam; Wojcik, Krzysztof; Ciechanowski, Ed; linux-raid@vger.kernel.org
> Subject: Re: [PATCH] mdadm.8: Disk coercion with IMSM metadata.
>
> On Wed, Jul 13, 2011 at 7:26 PM, NeilBrown <neilb@suse.de> wrote:
>> On Wed, 13 Jul 2011 12:17:02 +0200 "maciej.naruszewicz"
>> <maciej.naruszewicz@intel.com> wrote:
>>
>>> From: maciej.naruszewicz <maciej.naruszewicz@intel.com>
>>>
>>> Actual sizes of disks from different producers may vary,
>>> even though they are claimed to have the same amount of
>>> space
>>
>> Are you sure about this?
>>
>> It was my understanding that some industry association has arranged an
>> agreement so that this does not happen.
>>
>> http://www.idema.org/wp-content/plugins/download-monitor/download.php?id=1223
>>
>> Do you have actual evidence that different drives from different
>> manufacturers have similar but not identical sizes?
>>
>
> Hmm, seemed to be a case that needed handling when requirements were
> being gathered, but perhaps recent drives don't do this any more?
>
> Probably the more important part of this commit is that the man page
> currently says that --size can not be used with container metadata...
> but now that I have taken two seconds to think about it the light bulb
> goes off...
>
> --size is indeed irrelevant for:
>    mdadm --create /dev/md/imsm /dev/sd[a-d] -e imsm
>
> but my first reading of comment was that:
>   mdadm --create /dev/md/vol0 /dev/md/imsm --size=$size
> ...is somehow not valid.
>
> How about something like "For CONTAINER metadata --size is valid when
> creating and growing subarrays, when creating a new container set
> --size is irrelevant"
>
> --
> Dan


>
> Do you have actual evidence that different drives from different
> manufacturers have similar but not identical sizes?
>

I'm afraid I do... For instance I have two disks, first one from Western Digital (model WDC WD2500YS-01SHB1), the second one from Seagate (model ST3250410AS). Both are said to have 250 GB maximum data space- however, the OS doesn't agree. LBA count for WD is 490234752, while for ST it's 488397168- that makes 251000193024 against 250059350016 bytes, nearly 1GB of difference!

I'm not sure when those disks were produced- maybe newest disks are manufactured according to the IDEMA standard, but this example shows that there definitely are differences.

>
> How about something like "For CONTAINER metadata --size is valid when
> creating and growing subarrays, when creating a new container set
> --size is irrelevant"
>

Indeed, the --size option is irrelevant for containers and valid for subarrays in the container; however, the manpage stated: "This value cannot be used with .B CONTAINER metadata such as DDF and IMSM.". By "this", the author meant that "--grow --size" cannot be used, he / she didn't mean the "--size" alone. This sentence is deleted in the patch I sent earlier and explained more clearly in its description. Of course, we could add the information Dan mentioned to make it even more understandable.

Best wishes
Maciek

_______________________________________________________________________________

Intel Technology Poland sp. z o.o.
z siedziba w Gdansku
ul. Slowackiego 173
80-298 Gdansk

Sad Rejonowy Gdansk Polnoc w Gdansku, 
VII Wydzial Gospodarczy Krajowego Rejestru Sadowego, 
numer KRS 101882

NIP 957-07-52-316
Kapital zakladowy 200.000 zl
