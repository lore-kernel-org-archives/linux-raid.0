From: Bruce Merry <bmerry@gmail.com>
Subject: Re: What to do about Offline_Uncorrectable and Pending_Sector in RAID1
Date: Mon, 14 Nov 2016 08:50:21 +0200
Message-ID: <CAHy4j_6q2mmQ_y-xkh1Zx6CrP1vByQMadCXLJwibeeO85T3JgQ@mail.gmail.com>
References: <CAHy4j_7_nRMxOSW16VTAY7bzdW_VMap=Jeb2M0wMiNDoNXcijQ@mail.gmail.com>
 <942ab8be-cd5c-c6d1-d077-cd295b355c0c@youngman.org.uk> <CAHy4j_7F=gN9=7mEH-TsdVJR0YFxBzJK98WeJfuwtANoDEy93w@mail.gmail.com>
 <5828D5DA.1070406@youngman.org.uk> <bdd9358d-2141-eb4f-e765-52177b1ec852@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bdd9358d-2141-eb4f-e765-52177b1ec852@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Wols Lists <antlists@youngman.org.uk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14 November 2016 at 01:03, Phil Turmel <philip@turmel.org> wrote:
> Hi Bruce,
>
> On 11/13/2016 04:06 PM, Wols Lists wrote:
>> On 13/11/16 20:51, Bruce Merry wrote:
>>> On 13 November 2016 at 22:18, Anthony Youngman <antlists@youngman.org.uk> wrote:
>>>> Quick first response ...
>
>>>> https://raid.wiki.kernel.org/index.php/Timeout_Mismatch
>>>
>>> smartctl reports "SCT Error Recovery Control command not supported".
>>> Does that mean I should be worried? Is there any way to tell whether a
>>> given drive I can buy online supports it?
>
> You should be worried.  It is vital for proper MD raid operation that
> drive timeouts be shorter than the kernel timeout for that device.  If
> you can't make the drive timeout short, you *must* make the kernel
> timeout long.

Okay, I'll give that script a go to increase my kernel timeout. If I
understand correctly, it's not the end of the world if the drive
doesn't support SCTERC, provided I have a long kernel timeout (and
when things go wrong it might take much longer to recover, but I can
live with that). Is that correct?

>>> Yes, that sounds like what I need. Thanks to Google I found
>>> /usr/share/mdadm/checkarray to trigger this. It still has a few hours
>>> to go, but now the bad drive has pending sectors == 65535 (which is
>>> suspiciously power-of-two and I assume means it's actually higher and
>>> is being clamped), and /sys/block/md0/md/mismatch_cnt is currently at
>>> 1408. If scrubbing is supposed to rewrite on failed reads I would have
>>> expected pending sectors to go down rather than up, so I'm not sure
>>> what's happening.
>>>
>> Ummm....
>>
>> Sounds like that drive could need replacing. I'd get a new drive and do
>> that as soon as possible - use the --replace option of mdadm - don't
>> fail the old drive and add the new. Dunno where you're based, but 5mins
>> on the internet ordering a new drive is probably time well spent.

Oh don't worry, I wasted no time in ordering new drives already.

> You have two other possibilities:
>
> 1) Swap volumes in the raid.  These are known to drop unneeded writes
> when the data isn't needed, even if it made it to one of the mirrors.
> That makes harmless mismatches.

It won't be that - I keep have separate non-RAIDed partitions for swap.

> 2) Trim.  Well-behaved drive firmware guarantees zeros for trimmed
> sectors, but many drives return random data instead.  Zing, mismatches.
> It's often unhelpful with encrypted volumes, as even well-behaved
> firmware can't deliver zeroed sectors *inside* the encryption.

Weee, sounds like fun. I hope it's that. Is there any way to tell
which blocks mismatch, so that I can tell which files are in trouble
(assuming I can figure out how to map through LVM, LUKS and
debuge2fs).

Bruce
-- 
Dr Bruce Merry
bmerry <@> gmail <.> com
http://www.brucemerry.org.za/
http://blog.brucemerry.org.za/
