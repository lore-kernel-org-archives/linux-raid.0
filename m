From: Bruce Merry <bmerry@gmail.com>
Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in RAID1
Date: Mon, 14 Nov 2016 18:09:55 +0200
Message-ID: <CAHy4j_7gwMmeRhQo2qvgMpOu2-m=BN_=VKbBXZc413PCyWSJuw@mail.gmail.com>
References: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
 <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk> <CAHy4j_7F=gN9=7mEH-TsdVJR0YFxBzJK98WeJfuwtANoDEy93w@mail.gmail.com>
 <5828D5DA.1070406@youngman.org.uk> <bdd9358d-2141-eb4f-e765-52177b1ec852@turmel.org>
 <CAHy4j_6q2mmQ_y-xkh1Zx6CrP1vByQMadCXLJwibeeO85T3JgQ@mail.gmail.com> <1c3c5ce1-a26e-878d-9863-399efe6825e1@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1c3c5ce1-a26e-878d-9863-399efe6825e1@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14 November 2016 at 18:01, Phil Turmel <philip@turmel.org> wrote:
> In the meantime, run a "repair" scrub instead of a "check" scrub to
> affirmatively force no mismatches.  (Writes first member of mirrors to
> the others.)

I think that's good news. I wasn't sure which direction "repair" would
copy, but the good drive is the first member ("Device Role : Active
device 0"). I'll give that a go once the current scrub is done.

Thanks
Bruce
-- 
Dr Bruce Merry
bmerry <@> gmail <.> com
http://www.brucemerry.org.za/
http://blog.brucemerry.org.za/
