From: SandeepKsinha <sandeepksinha@gmail.com>
Subject: Re: RFC: Removal of hash table for Linear RAID
Date: Sun, 17 May 2009 18:23:15 +0530
Message-ID: <37d33d830905170553ia08344dr28e9bb08cae2ac7c@mail.gmail.com>
References: <37d33d830905162310w1b90e8b2h185202643331342@mail.gmail.com>
	 <18959.47041.529196.102021@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18959.47041.529196.102021@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Neil,

On Sun, May 17, 2009 at 12:37 PM, Neil Brown <neilb@suse.de> wrote:
> On Sunday May 17, sandeepksinha@gmail.com wrote:
>> Hi all,
>>
>> I suggest the removal of the hashing table and various other members
>> associated with it from the struct linear_private_data, which are us=
ed
>> majorly for faster searching of devices.
>>
>> struct linear_private_data
>> =A0 {
>> =A0 =A0 =A0 =A0 =A0 struct linear_private_data *prev; =A0 =A0 =A0 /*=
 earlier version */
>> - =A0 =A0 =A0 =A0 =A0dev_info_t =A0 =A0 =A0 =A0 =A0 =A0 =A0**hash_ta=
ble;
>> - =A0 =A0 =A0 =A0 =A0sector_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spacing=
;
>> =A0 =A0 =A0 =A0 =A0 sector_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0array_se=
ctors;
>> - =A0 =A0 =A0 =A0 =A0int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 sec=
tor_shift; =A0 /* shift before dividing
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0* by spacing
>> - =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 */
>> =A0 =A0 =A0 =A0 =A0 dev_info_t =A0 =A0 =A0 =A0 =A0 =A0 =A0disks[0];
>> =A0 };
>>
>
> I'm in two minds about this...
>
> One the one hand, the simplification is good, just like it was for
> raid0.
>
> However the argument that we used for raid0 does not apply exactly to
> linear.
>
> For raid0, we observed that the list we would need to search would
> never be longer than the number of devices, and would usually be
> shorter, often just one entry (when all devices are the same size).
> Optimising for an array with lots of different sized drives didn't
> seem to be sensible.
>
> However with linear, the list that needs to be searched is always
> exactly the same length as the number of devices, even if they are al=
l
> the same size.
>
> So I feel that I would still like something the accelerate the search
> a bit.
> Some options that have occur to me are:
> =A0- do a binary search. =A0I have read that this can be slower than =
a
> =A0 =A0 linear search for very short lists, but if the code turns out=
 to
> =A0 =A0 be really really simple, that might be a good option.

In my opinion I think this would be simpler and much faster in most of
the cases.
It might be slower for some on the cases as you mentioned but those
will be rare.
Also, looking at the aspects of linear raid, I have seen potential
users having linear raid aggregates with large number of disks,
mostly.

However, as far as the code simplicity is concerned, it surely be. I
will try to send the diff once I am done with the initial testing of
it.

> =A0- fixed size hash table with power-of-2 spacing. =A0It might be th=
at
> =A0 =A0 lots of the current complexity can disappear if we just make =
the
> =A0 =A0 table a bit simpler - choose a size that allows shifts instea=
d of
> =A0 =A0 divides, or something like that.
>

If I am getting you right, a fixed sized table would again put some
kind of limitations. Someway or the other.
Also, choosing a size may be easy and be optimal for one but will that
be optimal for both equal and non-equal sized disks.
So, I would suggest to go with the binary search method.


If you don't mind, can you elaborate a bit more on what exactly you
are suggesting?


=2E
>>
>>
>> The reason for the same being that use of sector_div, spacing and
>> sector_shift involves lots of computations, which can be easily
>> avoided and we can achieve the same in a simpler way.
>>
>> Also, in an environment where we hold a restriction to have a maximu=
m
>> of 27 devices. I believe that a linear search would be faster or
>> atleast equal in time, if you take into consider the (time taken for
>> computations + search) while using the hash table as well.
>
> The limit of 27 devices per array only applies with v0.90 metadata
> with v1.x, you can have many more, certainly hundreds. =A0Whether any=
one
> would want to is a separate question.
>

Thanks I wasn't aware of this.

>>
>> Other than making the code simpler, IMO, this should also help shrin=
k
>> the struct linear_private_data which might further help caching as
>> well.
>
> It is really the data structures which a duplicated as in an array
> that benefit from shrinking. =A0So making dev_info smaller might help=
=2E
> Making linear_private_data smaller isn't likely to make an important
> difference.
> The important thing is keeping related data close together. =A0By
> shrinking the members of an array, we bring the start and end closer
> together, which is a good thing.
>
> Removing num_sectors from dev_info would be a good idea.
>

Yes, we can certainly do that and replace num_sectors uses with
conf->rdev->sectors.
num_sectors actually is redundant as we already keep this information i=
n rdev.

Is this assumption right?

>>
>> Another enhancement to this can be to add a new member "nr_devices" =
(
>> number of devices ) to struct linear_private_data and use the same t=
o
>> perform a binary search for the lokkup, as we know the sectors would
>> always be increasing as per we move ahead with devices.
>>
>> Something like,
>>
>> struct linear_private_data
>> =A0 {
>> =A0 =A0 =A0 =A0 =A0 struct linear_private_data *prev; =A0 =A0 =A0 /*=
 earlier version */
>> =A0 =A0 =A0 =A0 =A0 sector_t =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0array_se=
ctors;
>> =A0 =A0 =A0 =A0 =A0 int =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0nr_devices;
>> =A0 =A0 =A0 =A0 =A0 dev_info_t =A0 =A0 =A0 =A0 =A0 =A0 =A0disks[0];
>> =A0 };
>>
>>
>> And accordingly, which_dev( ) can use the same to make the search
>> faster and better.
>
> Yes, that is certainly worth a try.
>

Also, after thinking more on this, I feel we already have
mdded->raid_disks, which will be equal to the number of devices on the
linear array.
So, do you still suggest adding something like nr_devices.

As of now, this would only be required in which_dev( ), if we go with
binary search. One instance.
Can we not make use of mddev->raid_disks for this particular instance?

> NeilBrown
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

--=20
Regards,
Sandeep.





 =09
=93To learn is to change. Education is a process that changes the learn=
er.=94
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
