From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: emergency call for help: raid5 fallen apart
Date: Thu, 25 Feb 2010 18:42:51 -0800
Message-ID: <4877c76c1002251842g1a3b2f91ka7a825fd99a4ec18@mail.gmail.com>
References: <4B853DB7.1060406@xunil.at>
	 <20100224152228.GB11039@cthulhu.home.robinhill.me.uk>
	 <4B85467C.5020008@xunil.at> <4B855621.5010000@xunil.at>
	 <4B855987.1010605@xunil.at> <4B855B8C.8080802@xunil.at>
	 <4B862F2C.5030302@texsoft.it> <4B86A943.3040804@anonymous.org.uk>
	 <adf93d751002250941t4ba2a222ua0406bc3c95e90@mail.gmail.com>
	 <4B86C207.6030304@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4B86C207.6030304@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Feb 25, 2010 at 10:31 AM, John Robinson
<john.robinson@anonymous.org.uk> wrote:
> On 25/02/2010 17:41, Dawning Sky wrote:
>>
>> On Thu, Feb 25, 2010 at 8:45 AM, John Robinson
>> <john.robinson@anonymous.org.uk> wrote:
>>>
>>> On 25/02/2010 08:05, Giovanni Tessore wrote:
>>> [...]
>>> I do think we urgently need the hot reconstruction/recovery feature=
, so
>>> failing drives can be recovered to fresh drives with two sources of=
 data,
>>> i.e. both the failing drive and the remaining drives in the array, =
giving
>>> us
>>> two chances of recovering every sector.
>>
>> I was one of those 4 cases in the part month. =A0I would have certai=
nly
>> benefited from this when I tried to replace a failing drive on my ol=
d
>> raid-5. =A0But =A0I think actually the redundancy you desired can be
>> achieved by running a raid-6 at the degraded mode (with 1 missing
>> drive).
>>
>> Do I miss something? =A0If this is the case, shouldn't we all
>> be doing this instead of using the raid-5?
>
> I think you must be missing something, yes. RAID-6 with one drive mis=
sing
> would have 2 chances of recovering each sector, but then so does RAID=
-5 with
> no drives missing. In either case, lose a drive and you need every se=
ctor on
> the remaining drives to be good to complete the reconstruction and ke=
ep the
> array up.
>
> Cheers,
>
> John.
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

No, what they're saying is that often drives don't /totally/ fail.
They have segments that go bad first, and we are often catching them
in that state.  To use the segments that /are/ successfully returned
there is a good chance that multiple 'not full member' drive could
provide a complete, or usefully very near complete with known 'dead'
areas set to store on fresh devices.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
