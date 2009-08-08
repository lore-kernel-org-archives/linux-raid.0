From: "NeilBrown" <neilb@suse.de>
Subject: Re: Draft Mirrored Linux Mini How-to
Date: Sat, 8 Aug 2009 11:41:28 +1000 (EST)
Message-ID: <24aa235266d4cb2161954c4d49ed8ebe.squirrel@neil.brown.name>
References: <4A78292A.5000607@in.ibm.com> <1249421223.18245.36.camel@pasglop>
    <4A794E26.8080207@in.ibm.com> <1249465934.18245.54.camel@pasglop>
    <4A7ADBB1.3050906@in.ibm.com> <1249595469.24311.5.camel@pasglop>
    <4A7B708F.4050406@uga.edu>
    <20090807035303.GA31754@musti.tarvainen.info>
    <87vdkzp0rk.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87vdkzp0rk.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: Tapani Tarvainen <raid@tapanitarvainen.fi>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sat, August 8, 2009 11:11 am, Goswin von Brederlow wrote:
> Tapani Tarvainen <raid@tapanitarvainen.fi> writes:
>
>> On Thu, Aug 06, 2009 at 08:08:47PM -0400, Harold Pritchett
>> (harold@uga.edu) wrote:
>>
>>> Mirrored Linux Mini How-to
>>
>> A few quick observations:
>>
>>> Install linux on two identical disk drives in such a way that the
>>> failure
>>> of either of the drives will allow the system to be recovered without
>>> any
>>> loss of data
>>>
>>> Both of the drives are partitioned exactly the same:
>>>      1.  3 primary partitions
>>>      2.  Partition 1 - size - 1GB format as Linux Raid (fd)
>>>      3.  Partition 2 - size = real memory size, format as linux swap
>>> (82)
>>>      4.  Partition 3 = size = remainder of disk, format as linux raid
>>> (fd)
>>
>> If I read correctly, you are not only leaving swap out of lvm,
>> you are not mirroring it at all - which would make the system
>> crash if the swap disk breaks.
>> Putting swap on lvm would also allow growing it easily as needed.
>
> On the other hand don't forget that raid1 is buggy with swap and the
> page contents might change between writes to the first and second
> disk. Or has that been fixed?

There is no bug here.  The behaviour is a little unexpected
but it is perfectly "correct" in that there is never any risk to
data.

NeilBrown


>
>> Another point is that sometimes it is useful to have multiple
>> partitions separately mirrored and then combined with lvm:
>> it allows things like changing the raid configuration from
>> two-disk raid1 to three-disk raid5 without moving data
>> via backup and yet avoiding windows of vulnerability
>> to single-disk failure during the transition.
>> (Perhaps not common enough to be worth mentioning here,
>> but I've found it useful.)
>
> You can transform raid1 to raid5 without loss of redundncy so I don't
> quite see what you mean here.
>
> MfG
>         Goswin
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

