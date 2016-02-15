From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Questions
Date: Mon, 15 Feb 2016 15:01:06 -0600
Message-ID: <CAPpdf5-LRMk0pcsBrp_nwmrNmPKt5jeo0_zjbH5cMZqA0+LtRQ@mail.gmail.com>
References: <CAPpdf58O+=Re1dBe1Rmj7jb=9iJkMZZBuZfEX4S32wMXcv6uWQ@mail.gmail.com>
	<56C0200B.8030606@websitemanagers.com.au>
	<CAPpdf5_JBJB19B7wG5iuTt_aDZ6Zg0=kgQJtR_REU9JfDN1CxA@mail.gmail.com>
	<AE031459-5104-437F-8353-ACF855CB02CC@websitemanagers.com.au>
	<CAPpdf59u6SPD3=sv1XmKR09jzt6OL8TYLgOj==i3G4775fqbhg@mail.gmail.com>
	<56C22C20.9090002@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56C22C20.9090002@youngman.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Wols Lists <antlists@youngman.org.uk>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 15, 2016 at 1:50 PM, Wols Lists <antlists@youngman.org.uk> wrote:
> On 15/02/16 12:12, o1bigtenor wrote:
>> I am looking at replacing ALL the drives in the array so that I can
>> reduce the likelihood of these kind of issues for a longer period than
>> a few months.
>>
>> Would you be able to tell me what steps should I be taking to replace
>> the entire array?
>>
>> Should I replace the drives one at a time (sort of just like I did
>> this time) using the same commands?
>
> If you have a spare SATA (I presume they're sata drives) slot, then
> definitely not. It might be worth buying an add-in card to give you an
> extra slot, they're only a few quid.
>
> Look up "mdadm --replace". That'll keep the old drive in the array until
> the new one has replaced it, keeping the array fully functional all the
> time.
>
> Doing --fail, --remove, --add places the array in danger until the
> entire sequence is complete, and if you're doing it several times then
> you're massively increasing the chances of trouble.
>
> In fact, if you get an add-in card, you might be able to replace several
> drives at once - I don't know - read up and see if it's supported (or not).

Looked through well over a hundred different pages and only found 1 page
that even hinted at what I am trying to do and details there were sparse.

Read through the man page (likely one of the best for understandability that
I have found so far) and it doesn't address the wholesale replacement of all
the drives in an array. Most of the other pages that I found were what I would
call old, ie before 2010, as I have found that all too often the software being
discussed has changed and then the instructions given are not always useful,
occasionally there is some value in these old pages but only sometimes.

Most often the documentation was focused on replacing a faulty disc.

This is NOT what I am proposing to do.

I have a present working array and with to replace its components with the
same size but new drives (which are NAS rated). Was thinking that using
the fail remove and add process 4 seperate times might not be a good thing
but I do not know of a different option. Compounding the difficulty is
that there
are no empty hard drive slots in the machine. I do have an external USB 3.0
2 drive holder that could be used.

The only suggestion in all the documents I perused was to place spare drives
into something like this external box and then add the drives into the array.
The process was not laid out and leaves me with a number of questions.

Is there a suggested method for replacing ALL the drives in an array (raid 10
in this case)?

If I use the external box how do I do this (external box only holds 2 drives) so
that I can transfer the information on the drives from the array to
the new drives
and then just replace the drives 2 at a time into the machine without
there being
issues because in the information transfer the drives will be sdg and
sdh (AFAIK)
and later they will be some of sdb, sdc, sde, and/or sdf.

If one of the gurus on the list has an already prepared process list
with the steps
and commands that would be wonderful. I am thinking that this document would
very much be appreciated by many others out there that are not on this list.

TIA

Dee
