From: =?ISO-8859-1?Q?Kristleifur_Da=F0ason?= <kristleifur@gmail.com>
Subject: Re: Resize RAID-0?
Date: Fri, 12 Mar 2010 11:36:52 +0000
Message-ID: <73e903671003120336m36718a31m1c4ce760c42dbc75@mail.gmail.com>
References: <23986fd91003111939w102813c6r8d1b51a387784a71@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <23986fd91003111939w102813c6r8d1b51a387784a71@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Patrick J. LoPresti" <lopresti@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Mar 12, 2010 at 3:39 AM, Patrick J. LoPresti <lopresti@gmail.co=
m> wrote:
> From reading the documentation and source code, I gather "mdadm
> --grow" is not supported for RAID-0 devices.
>
> In my application, I am using md RAID-0 to stripe among several
> (identical) hardware RAID-0 chassis. =A0I would like to extend my set=
up
> by adding another chassis, but apparently, I cannot (?).
>
> The next time I build a system like this, is there any way to get wha=
t
> I want using Linux? =A0That is, striping among devices, no parity, bu=
t
> with the ability to grow in the future?

I agree with others on the list - I believe that LVM will perform well
as a flexible stripe wrangler on top of mdadm arrays. For instance
some LVM striping over mdadm parity-based stuff underneath.

Do you want to add a whole new stripe device, so changing the
coarse-scale layout, or grow the underlying data containers?

I had a problem related to growing underlying containers which was
solved on the list a few weeks ago. I had two largish RAID6 arrays and
an mdadm stripe-set over those. I added some disks to both RAID6
subarrays and wanted to expand the stripe-array to use the space
gained. Here's a copy of the thread, "raid0 not growable?":
http://www.issociate.de/board/post/501375/raid0_not_growable?.html

But perhaps you wanted to do something like add a 3rd stripe to a
two-stripe array? (I myself don't know if that's possible or not.)

As you are running striped, I assume that the data is either
perishable or backed up. I'd suggest you look into moving to LVM. (LVM
has its quirks - so look before you leap, perhaps :) ) I suggest you
play a little with LVM in a virtual-machine; In the gas-lit and
magical world of open-source RAID management, there's nothing like
direct experience to tell you what's possible and what doesn't work.
The tools and the power are out there, but you have to do a little
hunting in the forest.

Best of luck!

-- Kristleifur
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
