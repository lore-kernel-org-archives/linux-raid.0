From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: suns raid-z / zfs
Date: Tue, 26 Feb 2008 15:27:26 -0500
Message-ID: <47C4762E.4080700@tmr.com>
References: <20080217160403.GA15710@rap.rap.dk> <18361.1168.473685.214133@notabene.brown> <20080218053319.GA18863@rap.rap.dk> <18361.25379.998485.63488@notabene.brown> <20080218204529.GA17984@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080218204529.GA17984@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> On Mon, Feb 18, 2008 at 09:51:15PM +1100, Neil Brown wrote:
>  =20
>> On Monday February 18, keld@dkuug.dk wrote:
>>    =20
>>> On Mon, Feb 18, 2008 at 03:07:44PM +1100, Neil Brown wrote:
>>>      =20
>>>> On Sunday February 17, keld@dkuug.dk wrote:
>>>>        =20
>>>>> Hi
>>>>>
>>>>>          =20
>>>>> It seems like a good way to avoid the performance problems of rai=
d-5
>>>>> /raid-6
>>>>>          =20
>>>> I think there are better ways.
>>>>        =20
>>> Interesting! What do you have in mind?
>>>      =20
>> A "Log Structured Filesystem" always does large contiguous writes.
>> Aligning these to the raid5 stripes wouldn't be too hard and then yo=
u
>> would never have to do any pre-reading.
>>
>>    =20
>>> and what are the problems with zfs?
>>>      =20
>> Recovery after a failed drive would not be an easy operation, and I
>> cannot imagine it being even close to the raw speed of the device.
>>    =20
>
> I thought this was a problem with most raid types, while
> reconstructioning, performance is quite slow. And as there has been s=
ome
> damage, this is expected. And there probebly is no much ado about it.
>
> Or is there? Are there any RAID types that performs reasonably well
> given that one disk is under repair? The performance could be cruical
> for some applications.=20
>
>  =20
If that's a requirement, RAID1 with multiple copies would probably be=20
your best best. You could probably design a test from existing software=
=20
and a script, I'm just basing the thought on having run load on a=20
recovering 4 way mirror at one time. The load was 100-250 random=20
reads/sec, and response time stayed acceptable.
> One could think of clever arrangements so that say two disks could go
> down and the rest of the array with 10-20 drives could still function
> reasonably well, even under the reconstruction. As far as I can tell
> from the code, the reconstruction itself is not impeding normal
> performance much, as normal operation bars reconstuction operations.
>
> Hmm, my understanding would then be, for both random reads and writes
> that performance in typical raids would only be reduced by the IO ban=
dwidth
> of the failing disks.
>
> For sequential R/W performance for raid10,f would
> be hurt, downgrading its performance to random IO for the drives invo=
lved.
>
> Raid5/6 would be hurt much for reading, as all drives need to be read=
 for giving
> correct information during reconstruction.
>
>
> So it looks like, if your performance is important under a
> reconstruction, then you should avoid raid5/6 and use the mirrored ra=
id
> types. Given you have a big operation, with a load balance of a lot o=
f
> random reading and writing, it does not matter much which mirrored
> raid type you would choose, as they all perform about equal for rando=
m
> IO, even when reconstructing. Is that correct advice?
>
>  =20
>>>>> But does it stripe? One could think that rewriting stripes
>>>>> other places would damage the striping effects.
>>>>>          =20
>>>> I'm not sure what you mean exactly.  But I suspect your concerns h=
ere
>>>> are unjustified.
>>>>        =20
>>> More precisely. I understand that zfs always write the data anew.
>>> That would mean at other blocks on the partitions, for the logical =
blocks
>>> of the file in question. So the blocks on the partitions will not b=
e
>>> adjacant. And striping will not be possible, generally.
>>>      =20
>> The important part of striping is that a write is spread out over
>> multiple devices, isn't it.
>>
>> If ZFS can choose where to put each block that it writes, it can
>> easily choose to write a series of blocks to a collection of differe=
nt
>> devices, thus getting the major benefit of striping.
>>    =20
>
> I see 2 major benefits of striping: one is that many drives are invol=
ved=20
> and the other is that the stripes are  allocated adjacant, so that io
> on one drive can just proceed to the next physical blocks when one
> stripe has been processed. Dependent on the size of the IO operations
> involved, first one or more disks in a stripe is processed, and then =
the
> following stripes are processed. ZFS misses the second part of the
> optimization, In think.
>  =20


--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
