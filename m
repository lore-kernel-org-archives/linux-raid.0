From: David Brown <david.brown@hesbynett.no>
Subject: Re: Fault tolerance with badblocks
Date: Wed, 10 May 2017 10:41:14 +0200
Message-ID: <5912D22A.7040100@hesbynett.no>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>        <590B3039.3060000@youngman.org.uk>        <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>        <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>        <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>        <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>        <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>        <87vapb6s9h.fsf@esperi.org.uk>        <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>        <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>        <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>        <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com> <87fugd4wdv.fsf@esperi.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87fugd4wdv.fsf@esperi.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Nix <nix@esperi.org.uk>, Chris Murphy <lists@colorremedies.com>
Cc: Anthony Youngman <antlists@youngman.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/05/17 22:18, Nix wrote:
> On 9 May 2017, Chris Murphy verbalised:
> 
>> On Tue, May 9, 2017 at 5:58 AM, David Brown <david.brown@hesbynett.no> wrote:
>>
>>> I thought you said that you had read Neil's article.  Please go back and
>>> read it again.  If you don't agree with what is written there, then
>>> there is little more I can say to convince you.
> 
> The entire article is predicated on the assumption that when an
> inconsistent stripe is found, fixing it is simple because you can just
> fail whichever device is inconsistent... but given that the whole
> premise of the article is that *you cannot tell which that is*, I don't
> see the point in failing anything.

The point is that if an inconsistent stripe is found, then there is no
way to be sure how to fix it correctly.  So scrub certainly will not
touch it.  And what should "repair" do?  I see several choices:

1. It could assume the data is correct, and re-create the parities.
This is simple, and it avoids changing anything on the array from the
viewpoint of higher levels (i.e., the filesystem).

2. It could do a "smart" repair of the stripe, if it sees that there is
only one inconsistent block in the stripe.

3. It could pass the problem on to higher level tools (possibly
correcting a single inconsistency in the P or Q parities first).

At the moment, raid6 repair follows the first choice here.  Many people
seem to think the second choice is a good idea.  Personally, I would say
choice 3 is right - but unless and until higher level tools are
available, I think 1 is no worse than 2 - and it is simpler, clearer,
and works today.

Key to why I don't like choice 2 is a question of why you have a
mismatch in the first place.  Undetected read errors - the drive
returning wrong data as though it were correct data - are astoundingly
rare.  Even on huge disks, they do not occur often.  (Unrecoverable read
errors - when the drive reports a sector as unreadable - are not
uncommon.  That is what raid is for.)  If you get a mismatch, a likely
cause is a crash or power fault during a stripe write.  Another main
cause is hardware errors such as memory faults.  "Smart" repair can make
the situation worse.

Secondly, "smart" repair means changing the data on the disk.  You can't
do that while a file system is mounted (unless you want to risk chaos).
 One major reason for using raid is to minimise downtime of a system in
the event of problems - offline repair goes against that philosophy.


What do I mean about passing the problem on to higher levels?  One
example would be if there is an other raid level sitting above, such as
a raid1 pair of raid6 arrays (it would make more sense the other way
round - the same principle applies there).  The raid6 level could ask
the block layer above if that layer can re-create the correct data.  In
the case of a raid1 pair at a higher level, then it could - that way the
stripe would be written with the full known correct data, rather than
just a guess.  Perhaps the layer above is a filesystem - this could say
if that stripe is actually in use (no need to worry if it is in deleted
space), or if it can re-create the data from a BTRFS duplicate.

Failing that, a tool could interact with the filesystem to determine
what sort of data was on that stripe, and perhaps check it in some way.
 At least a tool could run a consistency check - would the filesystem be
consistent if the stripe was "smart repaired", or would it be consistent
if the stripe data was left untouched (and the P & Q parities recreated)?

A simple method here could be to mark the whole stripe as unreadable,
then run a filesystem check.  If there are higher level raids that can
re-create the lost stripe, that will happen automatically.  If not, then
the filesystem repair will ensure that the filesystem is consistent even
though data may be lost.

And of course, a higher level repair tool could be one that simply runs
a "smart repair" on the stripe.



All in all, when there is /no/ correct answer, I think we have to be
very careful about picking methods here.  Before switching to a "smart"
repair, rather than the simple method, we have to be /very/ sure that it
gives noticeably "better" results in real-world cases.  We can't just
say it sounds good - we need to know.


> 
> The first comment in the article is someone noting that md doesn't say
> which device is failing, what the location of the error is or anything
> else a sysadmin might actually find useful for fixing it. "Hey, you have
> an error somewhere on some disk on this multi-terabyte array which might
> be data corruption and if a disk fails will be data corruption!" is not
> too useful :( 

I haven't looked at the information you get out of the scrub, but of
course more information is better than less information.

> The fourth comment notes that the "smart" approach, given
> RAID-6, has a significantly higher chance of actually fixing the problem
> than the simple approach. I'd call that a fairly important comment...
> 
> (Neil said: "Similarly a RAID6 with inconsistent P and Q could well not
> be able to identify a single block which is "wrong" and even if it could
> there is a small possibility that the identified block isn't wrong, but
> the other blocks are all inconsistent in such a way as to accidentally
> point to it. The probability of this is rather small, but it is
> non-zero".

It is true that for some causes of mismatches, the "smart" repair has a
high chance of being correct.

> As far as I can tell the probability of this is exactly the
> same as that of multiple read errors in a single stripe -- possibly far
> lower, if you need not only multiple wrong P and Q values but *precisely
> mis-chosen* ones. If that wasn't acceptably rare, you wouldn't be using
> RAID-6 to begin with.
> 
> I've been talking all the time about a stripe which is singly
> inconsistent: either all the data blocks are fine and one of P or Q is
> fine, or both P and Q and all but one data block is fine, and the
> remaining block is inconsistent with all the rest. Obviously if more
> blocks are corrupt, you can do nothing but report it. The redundancy
> simply isn't there to attempt repair.)

Or possible mark the whole stripe as "unreadable", and punt the problem
to the higher levels.

> 
>> H. Peter Anvin's RAID 6 paper, section 4 is what's apparently under discussion
>> http://milbret.anydns.info/pub/linux/kernel/people/hpa/raid6.pdf
>>
>> This is totally non-trivial, especially because it says raid6 cannot
>> detect or correct more than one corruption, and ensuring that
>> additional corruption isn't introduced in the rare case is even more
>> non-trivial.
> 
> Yeah. Testing this is the bastard problem, really. Fault injection via
> dm is the only approach that seems remotely practical to me.

That's what the "FAULTY" raid level in md is for :-)

But what are the /realistic/ fault situations?

> 
>> I do think it's sane for raid6 repair to avoid the current assumption
>> that data strip is correct, by doing the evaluation in equation 27. If
>> there's no corruption do nothing, if there's corruption of P or Q then
>> replace, if there's corruption of data, then report but do not repair
> 
> At least indicate *where* the corruption is in the report. (I'd say
> "repair, as a non-default option" for people with a different
> availability/P(corruption) tradeoff -- since, after all, if you're using
> RAID In the first place you value high availability across disk problems
> more than most people do, and there is a difference between one bit of
> unreported damage that causes a near-certain restore from backup and
> either zero or two of them plus a report with an LBA attached so you
> know you need to do something...)

One thing to consider here is the sort of person using the raid array.
When Neil wrote his article, raid6 would only be used by an expert.  He
did not want to change existing data and make life harder for the
systems administrator doing more serious repair.

However, these days the raid6 "administrator" may be someone who owns a
NAS box and has no idea what raid, or even Linux, actually is.  In such
cases, "smart" repair is probably the best idea if the filesystem on top
is not BTRFS.

> 
>> as follows:
>>
>> 1. md reports all data drives and the LBAs for the affected stripe
>> (otherwise this is not simple if it has to figure out which drive is
>> actually affected but that's not required, just a matter of better
>> efficiency in finding out what's really affected.)
> 
> Yep.
> 
>> 2. the file system needs to be able to accept the error from md
> 
> It would probably need to report this as an -EIO, but I don't know of
> any filesystems that can accept asynchronous reports of errors like
> this. You'd need reverse mapping to even stand a chance (a non-default
> option on xfs, and of course available on btrfs and zfs too). You'd
> need self-healing metadata to stand a chance of doing anything about it.
> And god knows what a filesystem is meant to do if part of the file data
> vanishes. Replace it with \0? ugh. I'd almost rather have the error
> go back out to a monitoring daemon and have it send you an email...
> 
>> 3. the file system reports what it negatively impacted: file system
>> metadata or data and if data, the full filename path.
>>
>> And now suddenly this work is likewise non-trivial.
> 
> Yeah, it's all the layers stacked up to the filesystem that are buggers
> to deal with... and now the optional 'just repair it dammit' approach
> seems useful again, if just because it doesn't have to deal with all
> these extra layers.
> 
>> And there is already something that will do exactly this: ZFS and
>> Btrfs. Both can unambiguously, efficiently determine whether data is
>> corrupt even if a drive doesn't report a read error.
> 
> Yeah. Unfortunately both have their own problems: ZFS reimplements the
> page cache and adds massive amounts of ineffiicency in the process, and
> btrfs is... well... not really baked enough for the sort of high-
> availability system that's going to be running RAID, yet. (Alas!)

I disagree about BTRFS here.  First, raid is a good idea no matter how
"experimental" you consider your filesystem.  Second, BTRFS is solid
enough for a great many uses - I use it on laptops, desktops and servers.

/No/ storage system should be viewed as infallible - backups are
important.  So if BTRFS were to eat my data, then I'd get it back from
backups - just as I would if the server died, both disks failed, it got
stolen, or whatever.

But BTRFS on our servers means very cheap regular snapshots.  That
protects us from the biggest cause of data loss - user error.

> 
> (Recent xfs can do the same with metadata, but not data.)
> 

