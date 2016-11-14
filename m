From: Phil Turmel <philip@turmel.org>
Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in
 RAID1
Date: Mon, 14 Nov 2016 11:14:19 -0500
Message-ID: <d8179a84-6af9-a513-d298-0e8bcb34cce1@turmel.org>
References: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
 <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk>
 <CAHy4j_7F=gN9=7mEH-TsdVJR0YFxBzJK98WeJfuwtANoDEy93w@mail.gmail.com>
 <5828D5DA.1070406@youngman.org.uk>
 <bdd9358d-2141-eb4f-e765-52177b1ec852@turmel.org>
 <CAHy4j_6q2mmQ_y-xkh1Zx6CrP1vByQMadCXLJwibeeO85T3JgQ@mail.gmail.com>
 <1c3c5ce1-a26e-878d-9863-399efe6825e1@turmel.org>
 <CAHy4j_7gwMmeRhQo2qvgMpOu2-m=BN_=VKbBXZc413PCyWSJuw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHy4j_7gwMmeRhQo2qvgMpOu2-m=BN_=VKbBXZc413PCyWSJuw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bruce Merry <bmerry@gmail.com>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 11/14/2016 11:09 AM, Bruce Merry wrote:
> On 14 November 2016 at 18:01, Phil Turmel <philip@turmel.org> wrote:
>> In the meantime, run a "repair" scrub instead of a "check" scrub to
>> affirmatively force no mismatches.  (Writes first member of mirrors to
>> the others.)
> 
> I think that's good news. I wasn't sure which direction "repair" would
> copy, but the good drive is the first member ("Device Role : Active
> device 0"). I'll give that a go once the current scrub is done.

Direction is truly immaterial, as any bad sectors on device 0 will be
reconstructed from the other.  Neil Brown has a blog entry on this topic
that applies here:

http://neil.brown.name/blog/20100211050355

Phil

