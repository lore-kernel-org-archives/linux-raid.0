From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Fault tolerance with badblocks
Date: Tue, 9 May 2017 20:44:28 +0100
Message-ID: <59121C1C.1050101@youngman.org.uk>
References: <03294ec0-2df0-8c1c-dd98-2e9e5efb6f4f@hale.ee>
 <590B3039.3060000@youngman.org.uk>
 <84184eb3-52c4-e7ad-cd5b-5021b5cf47ee@hale.ee>
 <d2b25ec0-c401-07df-2231-a37117878589@youngman.org.uk>
 <bd917050-cf73-6922-bb20-c5ccf02ba51c@hale.ee>
 <590DC905.60207@youngman.org.uk> <87h90v8kt3.fsf@esperi.org.uk>
 <1533bba8-41cb-2c50-b28a-52786e463072@turmel.org>
 <87vapb6s9h.fsf@esperi.org.uk>
 <c5307694-034c-b610-8a27-3bf272cac380@youngman.org.uk>
 <87inla73vz.fsf@esperi.org.uk> <5911A371.3030008@hesbynett.no>
 <878tm65kyx.fsf@esperi.org.uk> <5911AED4.9030007@hesbynett.no>
 <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtSaLbp4T+j97Ds6xqPmhVwnncGU2UV2_9HEbEJyr6fy+Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, David Brown <david.brown@hesbynett.no>
Cc: Nix <nix@esperi.org.uk>, Phil Turmel <philip@turmel.org>, "Ravi (Tom) Hale" <ravi@hale.ee>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 09/05/17 18:25, Chris Murphy wrote:
> On Tue, May 9, 2017 at 5:58 AM, David Brown <david.brown@hesbynett.no> wrote:
> 
>> I thought you said that you had read Neil's article.  Please go back and
>> read it again.  If you don't agree with what is written there, then
>> there is little more I can say to convince you.
>>
>> One thing I can try, is to note that you are /not/ the first person to
>> think "Surely with RAID-6 we can correct mismatches - it should be
>> easy?".
> 
> H. Peter Anvin's RAID 6 paper, section 4 is what's apparently under discussion
> http://milbret.anydns.info/pub/linux/kernel/people/hpa/raid6.pdf
> 
> This is totally non-trivial, especially because it says raid6 cannot
> detect or correct more than one corruption, and ensuring that
> additional corruption isn't introduced in the rare case is even more
> non-trivial.

And can I point out that that is just one person's opinion? A
well-informed, respected person true, but it's still just opinion. And
imho the argument that says raid should not repair the data applies
equally against fsck - that shouldn't do any repair either! :-)
> 
> I do think it's sane for raid6 repair to avoid the current assumption
> that data strip is correct, by doing the evaluation in equation 27. If
> there's no corruption do nothing, if there's corruption of P or Q then
> replace, if there's corruption of data, then report but do not repair
> as follows:

From an ENGINEERING viewpoint, what is the probability that we get a
two-drive error? And if we do, then there's probably something rather
more serious gone wrong?
> 
> 1. md reports all data drives and the LBAs for the affected stripe
> (otherwise this is not simple if it has to figure out which drive is
> actually affected but that's not required, just a matter of better
> efficiency in finding out what's really affected.)

md should report the error AND THE DRIVE THAT APPEARS TO BE FAULTY. (Or
maybe we leave that to the below-mentioned mdfsck.)

That way, if it's a bunch of errors on the same drive we know we've got
a problem with the drive. If we've got a bunch of errors on random
drives, we know the problem is probably elsewhere.
> 
> 2. the file system needs to be able to accept the error from md
> 
> 3. the file system reports what it negatively impacted: file system
> metadata or data and if data, the full filename path.
> 
> And now suddenly this work is likewise non-trivial.

Which is why we keep the filesystem out of this. By all means make md
return a list of dud strips, which a filesystem-level utility can then
interpret, but that isn't md's problem.
> 
> And there is already something that will do exactly this: ZFS and
> Btrfs. Both can unambiguously, efficiently determine whether data is
> corrupt even if a drive doesn't report a read error.
> 
Or we write an mdfsck program. Just like you shouldn't run fsck with
write privileges on a mounted filesystem, you wouldn't run mdfsck with
filesystems in the array mounted.

At the end of the day, md should never corrupt data by default. Which is
what it sounds like is happening at the moment, if it's assuming the
data sectors are correct and the parity is wrong. If one parity appears
correct then by all means rewrite the second ...

But the current setup, where it's currently quite happy to assume a
single-drive error and rewrite it if it's a parity drive, but it won't
assume a single-drive error and and rewrite it if it's a data drive,
just seems totally wrong. Worse, in the latter case, it seems it
actively prevents fixing the problem by updating the parity and
(probably) corrupting the data.

Report the error, give the user the tools to fix it, and LET THEM sort
it out. Just like we do when we run fsck on a filesystem.

(I know I know, patches welcome :-)

Cheers,
Wol

