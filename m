From: Neil Brown <neilb@suse.de>
Subject: Re: RFC: Removal of hash table for Linear RAID
Date: Sun, 17 May 2009 17:07:45 +1000
Message-ID: <18959.47041.529196.102021@notabene.brown>
References: <37d33d830905162310w1b90e8b2h185202643331342@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from SandeepKsinha on Sunday May 17
Sender: linux-raid-owner@vger.kernel.org
To: SandeepKsinha <sandeepksinha@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sunday May 17, sandeepksinha@gmail.com wrote:
> Hi all,
> 
> I suggest the removal of the hashing table and various other members
> associated with it from the struct linear_private_data, which are used
> majorly for faster searching of devices.
> 
> struct linear_private_data
>   {
>           struct linear_private_data *prev;       /* earlier version */
> -          dev_info_t              **hash_table;
> -          sector_t                spacing;
>           sector_t                array_sectors;
> -          int                     sector_shift;   /* shift before dividing
> -                                                  * by spacing
> -                                                   */
>           dev_info_t              disks[0];
>   };
> 

I'm in two minds about this...

One the one hand, the simplification is good, just like it was for
raid0.

However the argument that we used for raid0 does not apply exactly to
linear.

For raid0, we observed that the list we would need to search would
never be longer than the number of devices, and would usually be
shorter, often just one entry (when all devices are the same size).
Optimising for an array with lots of different sized drives didn't
seem to be sensible.

However with linear, the list that needs to be searched is always
exactly the same length as the number of devices, even if they are all
the same size.

So I feel that I would still like something the accelerate the search
a bit.
Some options that have occur to me are:
  - do a binary search.  I have read that this can be slower than a
     linear search for very short lists, but if the code turns out to
     be really really simple, that might be a good option.
  - fixed size hash table with power-of-2 spacing.  It might be that
     lots of the current complexity can disappear if we just make the
     table a bit simpler - choose a size that allows shifts instead of
     divides, or something like that.

> 
> 
> The reason for the same being that use of sector_div, spacing and
> sector_shift involves lots of computations, which can be easily
> avoided and we can achieve the same in a simpler way.
> 
> Also, in an environment where we hold a restriction to have a maximum
> of 27 devices. I believe that a linear search would be faster or
> atleast equal in time, if you take into consider the (time taken for
> computations + search) while using the hash table as well.

The limit of 27 devices per array only applies with v0.90 metadata
with v1.x, you can have many more, certainly hundreds.  Whether anyone
would want to is a separate question.

> 
> Other than making the code simpler, IMO, this should also help shrink
> the struct linear_private_data which might further help caching as
> well.

It is really the data structures which a duplicated as in an array
that benefit from shrinking.  So making dev_info smaller might help.
Making linear_private_data smaller isn't likely to make an important
difference.
The important thing is keeping related data close together.  By
shrinking the members of an array, we bring the start and end closer
together, which is a good thing.

Removing num_sectors from dev_info would be a good idea.

> 
> Another enhancement to this can be to add a new member "nr_devices" (
> number of devices ) to struct linear_private_data and use the same to
> perform a binary search for the lokkup, as we know the sectors would
> always be increasing as per we move ahead with devices.
> 
> Something like,
> 
> struct linear_private_data
>   {
>           struct linear_private_data *prev;       /* earlier version */
>           sector_t                array_sectors;
>           int                        nr_devices;
>           dev_info_t              disks[0];
>   };
> 
> 
> And accordingly, which_dev( ) can use the same to make the search
> faster and better.

Yes, that is certainly worth a try.

NeilBrown
