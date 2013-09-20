From: Martin Wilck <mwilck@arcor.de>
Subject: RFC: incremental container assembly when sequence numbers don't match
Date: Fri, 20 Sep 2013 22:20:13 +0200
Message-ID: <523CADFD.9050006@arcor.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>, Francis Moreau <francis.moro@gmail.com>
List-Id: linux-raid.ids

Hi,

I have spent a few days thinking about the problem of incremental
container assembly when disk sequence numbers (aka event counters) don't
match, and how mdadm/mdmon should behave in various situations.
Before I start coding on this, I'd like to get your opinion - I may be
overlooking something  important.

The scenario I look at is that sequence numbers don't match during
incremental assembly. This can occur quite easily. A disk may have been
missing the last time the array was assembled, and be added again. The
last incremental assembly may have been interrupted before all disks
were found, for whatever reason. Etc. The problems Francis reported
lately all occur in situations of this type.

A) New disk has lower seq number as previously scanned ones:
   The up-to-date meta data is the meta data previously parsed.

   For each subarray the new disk is a member in the meta data:
     A.1) If the subarray is already running, add the new disk a spare.
     A.2) check the subarray seqnum; if the subarray seqnum is equal
between existing and new disks, the new disk can be added as "clean".
(This requires implementing separate seqnums for every subarray, but
that can be done quite easily, at least for DDF).
     A.3) Otherwise, add the new disk as a spare.

   The added disk may be marked as "Missing" or "Faulty" in the meta
data. That will be handled already by existing code already AFAICS.

B) New disk has higher seq number than previously scanned ones.
   The up-to-date meta data is on the new disk. Here it gets tricky.

   B.1) If mdmon isn't running for this container:
     B.1.a) reread the meta data (load_container() will automatically
choose the best meta data).
     B.1.b) Discard previously made configurations
     B.1.c) Reassemble the arrays, starting with the new disk. When
re-adding the drive(s) with the older meta data, act as in A) above.

   B.2) If mdmon is already running for this container, it means at
least one subarray is already running, too.
     B.2.a) If the new disk belongs to a already running and active
subarray, we have encountered a fatal error. mdadm should refuse to do
anything with the new disk and emit an alert.
     B.2.b) If the new disk belongs to a already running read-only
subarray, and the subarray seqnum of the new disk is lower than that of
the existing disks, we also have a fatal error - we don't know which
data is more recent. Human intervention is necessary.
     B.2.c) Both mdadm and mdmon need to update the meta data as
described in B.1.a).
     B.2.d) If the new disk belongs to a already running read-only
subarray, and the subarray seqnum of the new disk is greater or equal to
the subarray seqnum of the existing disk(s), it might be possible to add
the new disk to the array as clean. If the seqnum isn't equal, recovery
must be started on the previously existing disk(s). Currently the kernel
doesn't allow adding a new disk as "clean" in any state except
"inactive", so this special case will not be implemented any time soon.
It's a general question whether or not mdadm should attempt to be
"smart" in situations like this.
     B.2.e) Subarrays that aren't running yet, and which the new disk is
a member of, can be reassembled as described in A)
     B.2.f) pre-existing disks that are marked missing or failed in the
updated meta data must have their status changed. This may cause the
already running array(s) to degrade or break, even if the new disk
doen't belong to them.
     B.2.g) The status of all subarrays (consistent/initialized) is
updated according to the new meta data.

Note that the really difficult cases B.2.a/b/d can't easily happen if
the Incremental assembly is done without "-R", as it should be. So it
may be reasonable to just quit with an error if any of these situation
is encountered.

An important further question is where this logic should be implemented.
This is independent of meta data type and thus most of it should be in
the generic Incremental_container() code path.

Feedback welcome.
Best regards
Martin
