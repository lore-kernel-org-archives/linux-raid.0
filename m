From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Questions
Date: Mon, 15 Feb 2016 19:50:56 +0000
Message-ID: <56C22C20.9090002@youngman.org.uk>
References: <CAPpdf58O+=Re1dBe1Rmj7jb=9iJkMZZBuZfEX4S32wMXcv6uWQ@mail.gmail.com>
 <56C0200B.8030606@websitemanagers.com.au>
 <CAPpdf5_JBJB19B7wG5iuTt_aDZ6Zg0=kgQJtR_REU9JfDN1CxA@mail.gmail.com>
 <AE031459-5104-437F-8353-ACF855CB02CC@websitemanagers.com.au>
 <CAPpdf59u6SPD3=sv1XmKR09jzt6OL8TYLgOj==i3G4775fqbhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf59u6SPD3=sv1XmKR09jzt6OL8TYLgOj==i3G4775fqbhg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>, Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/02/16 12:12, o1bigtenor wrote:
> I am looking at replacing ALL the drives in the array so that I can
> reduce the likelihood of these kind of issues for a longer period than
> a few months.
> 
> Would you be able to tell me what steps should I be taking to replace
> the entire array?
> 
> Should I replace the drives one at a time (sort of just like I did
> this time) using the same commands?

If you have a spare SATA (I presume they're sata drives) slot, then
definitely not. It might be worth buying an add-in card to give you an
extra slot, they're only a few quid.

Look up "mdadm --replace". That'll keep the old drive in the array until
the new one has replaced it, keeping the array fully functional all the
time.

Doing --fail, --remove, --add places the array in danger until the
entire sequence is complete, and if you're doing it several times then
you're massively increasing the chances of trouble.

In fact, if you get an add-in card, you might be able to replace several
drives at once - I don't know - read up and see if it's supported (or not).

Cheers,
Wol
