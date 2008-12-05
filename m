From: "=?ISO-8859-2?Q?Micha=B3_Przy=B3uski?=" <mikylie@gmail.com>
Subject: Re: detection/correction of corruption with raid6
Date: Fri, 5 Dec 2008 22:30:40 +0100
Message-ID: <6c4602af0812051330o4220cbf1g8b969cd4b9843d3a@mail.gmail.com>
References: <1228510833.16555.76.camel@localhost>
	 <alpine.DEB.1.10.0812051602110.17806@p34.internal.lan>
	 <1228511195.16555.78.camel@localhost>
	 <alpine.DEB.1.10.0812051607100.17806@p34.internal.lan>
	 <1228511558.16555.84.camel@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1228511558.16555.84.camel@localhost>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

2008/12/5 Redeeman <redeeman@metanurb.dk>:
> On Fri, 2008-12-05 at 16:09 -0500, Justin Piszcz wrote:
>>
>> On Fri, 5 Dec 2008, Redeeman wrote:
>>
>> > On Fri, 2008-12-05 at 16:02 -0500, Justin Piszcz wrote:
>> >>
>> >> On Fri, 5 Dec 2008, Redeeman wrote:
>> >>
>> >>> Hello.
>> >>>
>> >>> I was looking at the PDFs linked to from the wiki, and found this:
>> >>> http://kernel.org/pub/linux/kernel/people/hpa/raid6.pdf
>> >>>
>> >>> More specifically, section 4, starting on page 8.
>> >>>
>> >>> Am I understanding this correctly, in that with raid6, linux is capable
>> >>> of detecting if the content on 1 disk is corrupted, and reconstruct it
>> >>> from the remaining disks?
>> >>
>> >> I ran md/raid6 for awhile, do you mean remap the bad sector on the fly?
>> >> Linux/md raid does not do this afaik.
>> >
>> > No, i mean, if one disk does silent corruption
>>
>> What would the error look like?  Both md/Linux & in the 3ware manual
>> recommend you run a 'check' across the raid at least once a week
>> (3ware/raid-verify) and md/Linux in Debian runs a check once a month I
>> believe to eliminate these issues.
>>
>> If you are asking whether a read error of a latent sector from the one
>> disk will result it reading the data from the second disk that is a good
>> question.
>
> im asking, if one disk in a raid6 setup suddenly decides to flip a few
> bits in some bytes, will it be able to detect that in a scan, and
> correct it? i cant see how it can do it on raid5, but maybe raid6?

No, not really.
I've been investigating silent corruption for a quite a while now, and
it looks more or less like this.
During a "check" action it'll be detected. During normal operation -
it won't be detected.
Normal (non-degraded) raid5/6 reads don't read parity (or Q syndrome),
they just read data. So they have no idea that something went bad.
Now, worse news is that you cannot really fix it automagically, even
after detecting by a "check" procedure. A "repair" will overwrite
parity and Q syndrome, with new values (new = calculated from what it
seems to be data blocks).

It is possible (by the theory of Q syndrome, per the article you
linked) to detect which drive is doing a silent corruption with raid6
(and with some extra assumption, that just one drive is doing that).
But it's not implemented.

Greets,
Mike
