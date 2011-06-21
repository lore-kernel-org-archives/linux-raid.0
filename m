From: NeilBrown <neilb@suse.de>
Subject: Re: Which Disks can fail?
Date: Tue, 21 Jun 2011 21:42:25 +1000
Message-ID: <20110621214225.5f65ece0@notabene.brown>
References: <4E007154.9030107@abpni.co.uk>
	<20110621204509.6309c38f@notabene.brown>
	<4E0078E9.7070208@abpni.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E0078E9.7070208@abpni.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Tripathy <jonnyt@abpni.co.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 21 Jun 2011 11:56:41 +0100 Jonathan Tripathy <jonnyt@abpni.co.uk>
wrote:

> 
> On 21/06/2011 11:45, NeilBrown wrote:
> > On Tue, 21 Jun 2011 11:24:20 +0100 Jonathan Tripathy<jonnyt@abpni.co.uk>
> > wrote:
> >
> >> Hi Everyone,
> >>
> >> Use md's "single process" RAID10 with the standard near layout (which is
> >> apperently the same as RAID1+0 in industry), which 2 drives could fail
> >> without loosing the array?
> >>
> >> This is what I have:
> >>
> >> Number   Major   Minor   RaidDevice State
> >>          0       8        5        0      active sync   /dev/sda5
> >>          1       8       21        1      active sync   /dev/sdb5
> >>          2       8       37        2      active sync   /dev/sdc5
> >>          3       8       53        3      active sync   /dev/sdd5
> >>
> >> Thanks
> >> --
> >> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> >> the body of a message to majordomo@vger.kernel.org
> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Run
> >
> >     man 4 md
> >
> >   search for "RAID10"
> >
> >   read what you find, and if it doesn't make sense, ask again.
> >   If it does make sense, post your answer and feel free to ask for
> >   confirmation.
> >
> >
> > NeilBrown
> Sorry, it still doesn't make much sense to me I'm afraid.
> 
> In fact, it's confused me more - since I'm using "near", does that means 
> that the "copy" (I'm using near=2) of a given trunk may lie on the same 
> disk, leading to *no redundancy*??

Clearly I need to improve the man page...  (suggestions welcome).

How do you read it that the copies of a given chunk may lie on the same disk.
I read:

       When  'near'  replicas are chosen, the multiple copies of a given chunk
       are laid out consecutively across the stripes of the array, so the  two
       copies of a datablock will likely be at the same offset on two adjacent
       devices.

"laid out consecutively across the stripes of the array" might be a bit
obscure..  A stripe is one chunk on each device, so when chunks a laid out
consecutively across a stripe, they would be one chunk per device.

Then "likely be at the same offset on two adjacent devices" should make this
clearer.  It is only "likely" because if you have an odd number of devices,
then the 2 copies of one chunk could be
  a/ at offset X on the last device
  b/ at offset X+chunk on the first device

but in general, they are on "adjacent devices"

So in answer to your original question, sda5 and sdb5 will have the same
data, and sdc5 and sdd5 will also have the same data.

NeilBrown

