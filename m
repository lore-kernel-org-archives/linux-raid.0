From: Goswin von Brederlow <goswin-v-b@web.de>
Subject: Re: Draft Mirrored Linux Mini How-to
Date: Sat, 08 Aug 2009 09:59:53 +0200
Message-ID: <87ocqqvipy.fsf@frosties.localdomain>
References: <4A78292A.5000607@in.ibm.com> <1249421223.18245.36.camel@pasglop>
	<4A794E26.8080207@in.ibm.com> <1249465934.18245.54.camel@pasglop>
	<4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop>
	<4A7B708F.4050406@uga.edu>
	<20090807035303.GA31754@musti.tarvainen.info>
	<87vdkzp0rk.fsf@frosties.localdomain>
	<24aa235266d4cb2161954c4d49ed8ebe.squirrel@neil.brown.name>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <24aa235266d4cb2161954c4d49ed8ebe.squirrel@neil.brown.name>
	(NeilBrown's message of "Sat, 8 Aug 2009 11:41:28 +1000 (EST)")
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Goswin von Brederlow <goswin-v-b@web.de>, Tapani Tarvainen <raid@tapanitarvainen.fi>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

"NeilBrown" <neilb@suse.de> writes:

> On Sat, August 8, 2009 11:11 am, Goswin von Brederlow wrote:
>> Tapani Tarvainen <raid@tapanitarvainen.fi> writes:
>>
>>> On Thu, Aug 06, 2009 at 08:08:47PM -0400, Harold Pritchett
>>> (harold@uga.edu) wrote:
>>>
>>>> Mirrored Linux Mini How-to
>>>
>>> A few quick observations:
>>>
>>>> Install linux on two identical disk drives in such a way that the
>>>> failure
>>>> of either of the drives will allow the system to be recovered without
>>>> any
>>>> loss of data
>>>>
>>>> Both of the drives are partitioned exactly the same:
>>>>      1.  3 primary partitions
>>>>      2.  Partition 1 - size - 1GB format as Linux Raid (fd)
>>>>      3.  Partition 2 - size = real memory size, format as linux swap
>>>> (82)
>>>>      4.  Partition 3 = size = remainder of disk, format as linux raid
>>>> (fd)
>>>
>>> If I read correctly, you are not only leaving swap out of lvm,
>>> you are not mirroring it at all - which would make the system
>>> crash if the swap disk breaks.
>>> Putting swap on lvm would also allow growing it easily as needed.
>>
>> On the other hand don't forget that raid1 is buggy with swap and the
>> page contents might change between writes to the first and second
>> disk. Or has that been fixed?
>
> There is no bug here.  The behaviour is a little unexpected
> but it is perfectly "correct" in that there is never any risk to
> data.
>
> NeilBrown

Disk 1 writes, page is modified, disk 2 writes, page is swapped in
from disk 1, something crashes because old data is swapped in.

Or did I miss something?

MfG
        Goswin
