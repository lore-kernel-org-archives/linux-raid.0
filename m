From: Greg Freemyer <greg.freemyer@gmail.com>
Subject: Re: Adding more drives/saturating the bandwidth
Date: Tue, 31 Mar 2009 09:05:46 -0400
Message-ID: <87f94c370903310605p893c6ces5ae3ee4e274c3b22@mail.gmail.com>
References: <87eiwf81e8.fsf@frosties.localdomain>
	 <439371.59188.qm@web51306.mail.re2.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <439371.59188.qm@web51306.mail.re2.yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jon@ehardcastle.com
Cc: Goswin von Brederlow <goswin-v-b@web.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Mar 31, 2009 at 4:23 AM, Jon Hardcastle <jd_hardcastle@yahoo.co=
m> wrote:
>
> --- On Mon, 30/3/09, Goswin von Brederlow <goswin-v-b@web.de> wrote:
>
>> From: Goswin von Brederlow <goswin-v-b@web.de>
>> Subject: Re: Adding more drives/saturating the bandwidth
>> To: Jon@eHardcastle.com
>> Cc: linux-raid@vger.kernel.org
>> Date: Monday, 30 March, 2009, 4:40 PM
>> Jon Hardcastle <jd_hardcastle@yahoo.com> writes:
>>
>> > Hey guys, How do you know if your machine can handle
>> adding some more drives to it? How can you check that there
>> is enough BUS IO to handle extra sata cards and also that
>> the machine is powerful enough to support say an 8 drive
>> raid 5...
>>
>> A) Try & error.
>> B) look up the speed of the bus and half it. Any bandwidth
>> left?
>> =A0 =A0make sure the cpu isn't at 100% already as well
>>
>> MfG
>> =A0 =A0 =A0 =A0 Goswin
>
> Cheers guys, I dont think CPU will be an issue as when i looked yeste=
rday whilst copying to my 6 drive raid 5 array it was at ~10% (the only=
 time i get access issues is when i am smart checking all 6 discs and t=
rying to stream a movie of it at the same time!)
>
> As for try and error... sounds scary as once I have added a drive to =
the array I can undo the process!

What do you think the "ran out of bandwidth" error is.  You make it
sound fatal.  Not true, it is just a bottleneck.  So if you design
your system to max out the bus structure with a a random i/o load, but
then you perform a large sequential load, the sequential workload will
just under perform what you would expect based on the disk drives
themselves.

No big deal as long as you design and test based on your real world wor=
kload.

Greg
--=20
Greg Freemyer
Head of EDD Tape Extraction and Processing team
Litigation Triage Solutions Specialist
http://www.linkedin.com/in/gregfreemyer
=46irst 99 Days Litigation White Paper -
http://www.norcrossgroup.com/forms/whitepapers/99%20Days%20whitepaper.p=
df

The Norcross Group
The Intersection of Evidence & Technology
http://www.norcrossgroup.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
