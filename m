From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 00/12] Partial Parity Log for MD RAID 5
Date: Fri, 16 Dec 2016 15:24:21 -0800
Message-ID: <20161216232421.x6sb4goclzyasu6k@kernel.org>
References: <20161205153113.7268-1-artur.paszkiewicz@intel.com>
 <87fum04m0m.fsf@notabene.neil.brown.name>
 <84c59771-48b7-da47-3497-c82c6c6939c9@intel.com>
 <20161207170906.sthdxswufwk5fqhn@kernel.org>
 <wrfjy3zjq2b3.fsf@redhat.com>
 <20161214194726.4to3rnqyrqlqlx7t@kernel.org>
 <c97a46de-f88a-f8f2-4520-e3c8a57d1b3b@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <c97a46de-f88a-f8f2-4520-e3c8a57d1b3b@intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
Cc: Jes Sorensen <Jes.Sorensen@redhat.com>, NeilBrown <neilb@suse.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Dec 15, 2016 at 12:44:57PM +0100, Artur Paszkiewicz wrote:
> On 12/14/2016 08:47 PM, Shaohua Li wrote:
> > On Tue, Dec 13, 2016 at 10:25:04AM -0500, Jes Sorensen wrote:
> >> Shaohua Li <shli@kernel.org> writes:
> >>> On Wed, Dec 07, 2016 at 03:36:01PM +0100, Artur Paszkiewicz wrote:
> >>>> On 12/07/2016 01:32 AM, NeilBrown wrote:
> >>>>>
> >>>>> I would expect to see as description of what a PPL actually is and how
> >>>>> it works here... but there is none.
> >>>>>
> >>>>> The change-log for patch 06 has a tiny bit more information which is
> >>>>> just enough to be able to start trying to understand the code, but it
> >>>>> isn't much.
> >>>>> And none of this description gets into the code, or into the
> >>>>> Documentation/.  This makes it hard to review and hard to maintain.
> >>>>>
> >>>>> Remember: if you want people to review you code, it is in your interest
> >>>>> to make it easy.  That means give lots of details.
> >>>>
> >>>> Hi Neil,
> >>>>
> >>>> Thank you for taking the time to look at this and for your feedback. I
> >>>> didn't try to make it hard to review... Sometimes it's easy to forget
> >>>> how non-obvious things are after looking at them for too long :) I will
> >>>> improve the descriptions and address the issues that you found in the
> >>>> next version of the patches.
> >>>
> >>> Havn't looked at the patches yet, being busy recently, sorry! When you repost
> >>> these, I'd like to know why we need another log for raid5 considering we
> >>> already had one to fix similar issue. What's the good/bad side of this new log?
> >>> There is such feature in Intel RSTe doesn't sound like a technical reason we
> >>> should support this.
> >>
> >> Shaohua,
> >>
> >> Any further thought on these patches? I am considering doing a release
> >> of mdadm early in the new year. it would be nice to include these
> >> patches if the feature is going in.
> >>
> >> As for supporting it, if IMSM supports it and it is used in the field,
> >> then it seems legitimate for Linux to support it too. Just like we
> >> support so many other obscure pieces of hardware :)
> > 
> > Sure, I don't object to support it. Just need to understand how it works. Had a
> > brief review. The ondisk format looks good. That probably is related to mdadm
> > mostly. The disk format has alignment issue as Neil noted, which would be
> > unfriendly for non-x86 arch. Will we stick to this disk format or change it?
> > We'd make a decision.
> 
> This alignment issue will be fixed by extending the 'parity_disk' field
> to 4 bytes. The 'checksum' field will then be properly aligned and the
> size of the structure will be 24 bytes, also fixing the array alignment.
> 
> > For the implementation, I don't understand how the ppl works much, there aren't
> > many details there. Two things I noted:
> > 
> > - The code skips the log for full stripe write. This isn't good. It would means
> >   after a unclean shutdown/recovery, one disk has arbitrary data, not the old
> >   data and new data. This breaks an assumption in filesystem, after a failed
> >   write to a sector, the sector has either old or new data. Thinking about a
> >   write to superblock. The data could be old or new superblock, but it's still a
> >   superblock, not something random.
> > 
> > - From the patch 6 & 10, looks PPL only help recover unwritten disks. If one
> >   disk of a stripe is dirty (eg it's written before unclean shutdown), and it's
> >   lost in recovery, what will happen? Seems the data of lost disk will be read as
> >   0? It will break the assumption above too. If I understand the code clearly
> >   (maybe not, need clarification), this is a design flaw.
> 
> PPL is only used to update the parity for a stripe, data chunks are not
> modified at all during PPL recovery. The assumption was that it would
> protect only from silent data corruption, to eliminate the cases when
> data that was not touched by a write request could change. So if a dirty
> disk is lost, no recovery is performed for this stripe (parity is not
> updated). For full stripe write we only recalculate the parity after a
> dirty shutdown if all disks are available (like resync). So you are
> right that it is still possible to have arbitrary data in the written
> part of a stripe if that disk is lost. In such case the behavior is the
> same as in plain raid5.

Ok, this matches my understanding. This isn't a completed solution but does
help a lot. If users want to use this, there is no reason to not support it.
After you fix the alignment issue and describe the solution in details, I'll
look at it again.

Thanks,
Shaohua
