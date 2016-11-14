From: Bruce Merry <bmerry@gmail.com>
Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in RAID1
Date: Mon, 14 Nov 2016 17:52:35 +0200
Message-ID: <CAHy4j_7aC+DCqMRkmK12HPP-wY5kAmLf7W3UG_Nn=TK7ry7ARQ@mail.gmail.com>
References: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
 <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk> <CAHy4j_7F=gN9=7mEH-TsdVJR0YFxBzJK98WeJfuwtANoDEy93w@mail.gmail.com>
 <5828D5DA.1070406@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5828D5DA.1070406@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 13 November 2016 at 23:06, Wols Lists <antlists@youngman.org.uk> wrote:
> Sounds like that drive could need replacing. I'd get a new drive and do
> that as soon as possible - use the --replace option of mdadm - don't
> fail the old drive and add the new.

Would you mind explaining why I should use --replace instead of taking
out the suspect drive? I guess I lose redundancy for any writes that
occur while the rebuild is happening, but I'd plan to do this with the
filesystem unmounted so there wouldn't be any writes.

What I'd quite like to do is treat the "good" drive as the source for
all the data (unless it turns out to have bad sectors too...), even if
the other drive doesn't have a read error; which I'd achieve by
failing the "bad" drive. I want to do this because after doing one
scrub and starting on a second, I'm still seeing non-zero
mismatch_cnt. Does --replace do anything clever about using the old
drive only when it must, or does it just read from the whole array
like normal, which might mean taking the mismatched data from the bad
drive?

Thanks
Bruce
-- 
Dr Bruce Merry
bmerry <@> gmail <.> com
http://www.brucemerry.org.za/
http://blog.brucemerry.org.za/
