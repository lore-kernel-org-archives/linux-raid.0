From: Phil Turmel <philip@turmel.org>
Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in
 RAID1
Date: Mon, 14 Nov 2016 11:01:28 -0500
Message-ID: <1c3c5ce1-a26e-878d-9863-399efe6825e1@turmel.org>
References: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
 <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk>
 <CAHy4j_7F=gN9=7mEH-TsdVJR0YFxBzJK98WeJfuwtANoDEy93w@mail.gmail.com>
 <5828D5DA.1070406@youngman.org.uk>
 <bdd9358d-2141-eb4f-e765-52177b1ec852@turmel.org>
 <CAHy4j_6q2mmQ_y-xkh1Zx6CrP1vByQMadCXLJwibeeO85T3JgQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHy4j_6q2mmQ_y-xkh1Zx6CrP1vByQMadCXLJwibeeO85T3JgQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bruce Merry <bmerry@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Bruce,

On 11/14/2016 01:50 AM, Bruce Merry wrote:

> Okay, I'll give that script a go to increase my kernel timeout. If I
> understand correctly, it's not the end of the world if the drive
> doesn't support SCTERC, provided I have a long kernel timeout (and
> when things go wrong it might take much longer to recover, but I can
> live with that). Is that correct?

Yes.

>> 2) Trim.  Well-behaved drive firmware guarantees zeros for trimmed
>> sectors, but many drives return random data instead.  Zing, mismatches.
>> It's often unhelpful with encrypted volumes, as even well-behaved
>> firmware can't deliver zeroed sectors *inside* the encryption.
> 
> Weee, sounds like fun. I hope it's that. Is there any way to tell
> which blocks mismatch, so that I can tell which files are in trouble
> (assuming I can figure out how to map through LVM, LUKS and
> debuge2fs).

The check operation doesn't log the sector addresses, unfortunately.  At
least I don't see any such operation in the code that increments
mismatch count.  Not even a tracepoint.  Hmmm.

In the meantime, run a "repair" scrub instead of a "check" scrub to
affirmatively force no mismatches.  (Writes first member of mirrors to
the others.)

Phil
