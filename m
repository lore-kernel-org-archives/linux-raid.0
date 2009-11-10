From: "Majed B." <majedb@gmail.com>
Subject: Re: Intel Updates SSDs, Supports TRIM, Faster Writes
Date: Tue, 10 Nov 2009 21:31:26 +0300
Message-ID: <70ed7c3e0911101031q7184315g24ba345dd30e55fd@mail.gmail.com>
References: <4AF7066C.1040507@tmr.com> <f3177b9e0911090837y6f40ee6dy2a88c963465e8718@mail.gmail.com>
	<70ed7c3e0911090842i167175a0q44fc5ad50a2f1759@mail.gmail.com>
	<f3177b9e0911090859j40a87433r342d2c49b46d015c@mail.gmail.com>
	<1257846132.22155.155.camel@localhost> <f3177b9e0911100739p56a98992p26f9a42e8b689dcf@mail.gmail.com>
	<70ed7c3e0911100743y55a1eef5p5705cd9cd1f1aa51@mail.gmail.com>
	<f3177b9e0911100758n2a663d16hc15a6c90e88346b7@mail.gmail.com>
	<70ed7c3e0911100801j2880965p7a5d6e03c74248dd@mail.gmail.com>
	<f3177b9e0911100818p36cbc0d9r56c95fa1f13ef46c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <f3177b9e0911100818p36cbc0d9r56c95fa1f13ef46c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Chris,

Do you mind sharing the drive models & controllers you're using that
give you 800 MB/s?

On Tue, Nov 10, 2009 at 7:18 PM, Chris Worley <worleys@gmail.com> wrote=
:
> On Tue, Nov 10, 2009 at 9:01 AM, Majed B. <majedb@gmail.com> wrote:
>> Which disks can provide 2ms response with a read of 250 MB/s and wri=
te
>> of 170 MB/s other than SSDs?!
>
> The drives I use average <50usecs latency at 4KB packets (properly
> measured as the complete turn-around time of a single outstanding
> I/O), 800MB/s reads and >600MB/s writes at 128KB blocks.
>
>>
>> Are you saying that it doesn't matter whether we use Linux or Window=
s
>> with SSDs because the limitation is coming from the disk's controlle=
r
>> itself?
>
> To some degree, yes, when using SSD's behind a controller, the
> controller is the biggest performance issue, and given they use
> chicklets for processors, they all hamper performance given the speed
> potential of the underlying storage.
>
> As none of the enterprise distros are handling TRIM yet, W7 can claim
> it was first, and putting together a TRIM-capable kernel is manual
> currently in Linux, and given only ext4 supports it (strangely, FAT
> supported it, then the code was pulled... XFS may support it, but I
> believe that's still in the works), you have the additional problem
> that ext4 has some maturity issues. =C2=A0Porting "discard" to ext2/3=
 would
> not be too difficult, especially w/o journal considerations.
>
> Chris
>>
>> On Tue, Nov 10, 2009 at 6:58 PM, Chris Worley <worleys@gmail.com> wr=
ote:
>>> On Tue, Nov 10, 2009 at 8:43 AM, Majed B. <majedb@gmail.com> wrote:
>>>> Does that mean we won't be able to squeeze the juice out of Intel'=
s
>>>> Extreme SSDs on Linux?
>>>
>>> The limitation is in the design. =C2=A0You'll be able to get as muc=
h
>>> performance as they can offer, given the bad design (of putting SSS
>>> behind legacy controllers).
--=20
       Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
