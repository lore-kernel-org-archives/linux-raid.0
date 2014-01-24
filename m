From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Fri, 24 Jan 2014 12:32:22 -0700
Message-ID: <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52E2AD10.5080208@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Jan 24, 2014, at 11:12 AM, Phil Turmel <philip@turmel.org> wrote:

> On 01/24/2014 12:59 PM, Chris Murphy wrote:
>>=20
>> On Jan 24, 2014, at 10:03 AM, Phil Turmel <philip@turmel.org> wrote:
>>>> w many bits of loss occur with one URE?
>>>=20
>>> Complete physical sector.
>>=20
>>=20
>> A complete physical sector represents 512 bytes / 4096 bits, or in
>> the case of AF disks 4096 bytes / 32768 bits, of loss for one URE.
>> Correct?
>>=20
>> So a URE is either 4096 bits nonrecoverable, or 32768 bits
>> nonrecoverable, for HDDs. Correct?
>=20
> Yes.  Note that the specification is for an *event*, not for a specif=
ic
> number of bits lost.  The error rate is not "bits lost per bits read"=
,
> it is "bits lost event per bits read".

I don't understand this. You're saying it's a "1 URE event in 10^14 bit=
s read" spec? Not a "1 bit nonrecoverable in 10^14 bits read" spec?

It seems that a nonrecoverable read error rate of 1 in 2 would mean, 1 =
bit nonrecoverable per 2 bits read. Same as 512 bits nonrecoverable per=
 1024 bits read. Same as 1 sector nonrecoverable per 2 sectors read.



>> At the moment a Poisson distribution is out of scope because m
>> questions have nothing to do with how often, when, or how many, such
>> URE's will occur. At the moment I only want complete utter clarity o=
n
>> what a URE/nonrecoverable error (not even the rate) is in terms of
>> quantity. That's my main problem.
>=20
> Ok, but the earlier arguments in this thread over the relative merits=
 of
> raid5 versus raid6 very much depend on the error rate.

Absolutely. But if I get the much earlier math wrong, then my understan=
ding of the risk will be one or more orders of magnitude wrong. Whether=
 underestimating or overestimating the risk, there are bad consequences=
=2E



>=20
>>> Note that a statement about the rate of a randomly occurring error
>>> is implicitly stating an average.
>>=20
>> Except that it has only one limiter, with the next notch a whole
>> order magnitude less error. So I don't see how you get an average
>> unless you're willing to just make assumptions about the bottom end.
>> It doesn't make sense that a manufacturer would state a maximum erro=
r
>> rate of X and then target that as an average. The average is
>> certainly well below the max.
>=20
> You are confused. =20

Be specific, because=85.


> The specification is a maximum of an average.

Stating the average rate is below the max specified rate, is consistent=
 with the spec being a maximum of an average. I don't see where you're =
getting the average from when there isn't even an X < Y < Z published. =
All we have is X < Z.


>  An
> average that changes with time, and cannot be measured from single ev=
ents.

On that point we agree. But with identical publish error rate specs we =
routinely see model drives give us more problems than others, even amon=
g the same manufacturer, even sometimes within a model varying by batch=
=2E So obviously the spec has a rather massive range to it.


Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
