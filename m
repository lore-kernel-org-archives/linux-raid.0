From: Phil Turmel <philip@turmel.org>
Subject: Re: Questions about bitrot and RAID 5/6
Date: Fri, 24 Jan 2014 14:57:23 -0500
Message-ID: <52E2C5A3.1050803@turmel.org>
References: <20140121171943.GC6553@blisses.org> <52DFA01E.8000301@hesbynett.no> <78DCA4D1-9386-4BE7-894C-47EF4772C431@colorremedies.com> <52E0D060.3020508@hesbynett.no> <DE020E0C-E6EC-48E9-8D7B-09F5A65A2DF5@colorremedies.com> <52E16536.2070608@turmel.org> <30218363-7819-40A1-B647-D19C1FD90548@colorremedies.com> <52E2691E.4050701@turmel.org> <0466C42D-F51E-41D1-B220-F38EB43C1A38@colorremedies.com> <52E29CEF.7030408@turmel.org> <62EB0D79-9A50-4C50-ACBF-1C507D6F449B@colorremedies.com> <52E2AD10.5080208@turmel.org> <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E222FBA0-8A1A-48EF-BEAA-BD059A8C1554@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: "linux-raid@vger.kernel.org List" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 01/24/2014 02:32 PM, Chris Murphy wrote:
>>> So a URE is either 4096 bits nonrecoverable, or 32768 bits=20
>>> nonrecoverable, for HDDs. Correct?
>>=20
>> Yes.  Note that the specification is for an *event*, not for a
>> specific number of bits lost.  The error rate is not "bits lost per
>> bits read", it is "bits lost event per bits read".
>=20
> I don't understand this. You're saying it's a "1 URE event in 10^14
> bits read" spec? Not a "1 bit nonrecoverable in 10^14 bits read"
> spec?
>=20
> It seems that a nonrecoverable read error rate of 1 in 2 would mean,
> 1 bit nonrecoverable per 2 bits read. Same as 512 bits nonrecoverable
> per 1024 bits read. Same as 1 sector nonrecoverable per 2 sectors
> read.

I don't know what more to say here.  Your "seems" is not.

[trim /]

>> You are confused.
>=20
> Be specific, because=E2=80=A6.
>=20
>> The specification is a maximum of an average.
>=20
> Stating the average rate is below the max specified rate, is
> consistent with the spec being a maximum of an average. I don't see
> where you're getting the average from when there isn't even an X < Y
> < Z published. All we have is X < Z.

I think you are also struggling with the fact the rate, on a single
drive, aside from any specification, is *itself* an average.

The manufacturer is stating that that average, which cannot be clearly
understood without grasping how a Poisson distribution works (or simila=
r
distributions), won't exceed a certain value within the warranty life (=
a
maximum).  To achieve this, the manufacturer will certainly arrange to
keep the average of these averages below the maximum.

>> An average that changes with time, and cannot be measured from
>> single events.
>=20
> On that point we agree. But with identical publish error rate specs
> we routinely see model drives give us more problems than others, even
> among the same manufacturer, even sometimes within a model varying by
> batch. So obviously the spec has a rather massive range to it.

To some extent, manufacturers have to make educated guesses about futur=
e
performance on new products.  They pay real $ penalties in warranty
claims if they err greatly in one direction, and real $ penalties in
"unnecessary" process equipment if the err greatly in the other directi=
on.

Obviously, some manufacturers have better knowledge of their own
production facilities than others.

Um, I think we're drifting off-topic now.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
