From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Questions
Date: Tue, 16 Feb 2016 12:33:17 -0600
Message-ID: <CAPpdf59tqGtusx5F4_qj942M=mpRf+fFM8O-9xE7L4YXTFd8NQ@mail.gmail.com>
References: <CAPpdf58O+=Re1dBe1Rmj7jb=9iJkMZZBuZfEX4S32wMXcv6uWQ@mail.gmail.com>
	<56C0200B.8030606@websitemanagers.com.au>
	<CAPpdf5_JBJB19B7wG5iuTt_aDZ6Zg0=kgQJtR_REU9JfDN1CxA@mail.gmail.com>
	<AE031459-5104-437F-8353-ACF855CB02CC@websitemanagers.com.au>
	<CAPpdf59u6SPD3=sv1XmKR09jzt6OL8TYLgOj==i3G4775fqbhg@mail.gmail.com>
	<56C22C20.9090002@youngman.org.uk>
	<CAPpdf5-LRMk0pcsBrp_nwmrNmPKt5jeo0_zjbH5cMZqA0+LtRQ@mail.gmail.com>
	<56C24B9C.2070506@websitemanagers.com.au>
	<CAPpdf598JjWbDFs93XU=Ph2EehNkw2qjXthUnGH+8cFs4N=64Q@mail.gmail.com>
	<56C32B7E.2070204@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56C32B7E.2070204@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Feb 16, 2016 at 8:00 AM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:
>snip
>>
>> A major reason as to why the drives are getting replaced. Back in early
>> 2012
>> when I setup the machine there was no obvious information that the ERC
>> type drives were needed so I just bought vanilla drives.
>>>
>>> Essentially, your current disks might be fine, but if you don't have the
>>> right settings, they could be "failing" regularly putting your data at
>>> risk.
>>> You should fix any issue here before you attempt to replace your drives.
>>
>> I now have 2 long term drives which are likely still good and 2 cheap
>> drives that
>> are quite new but which I don't trust for long term reliability,
>> therefore the push
>> to change them all.
>
>
> Note, most drives either still support it, or else can be worked around to
> avoid the timeout mismatch. You should do this before continue to replace
> the drives, as you want to avoid this happening in the middle of replacing
> drives.
snip
>>>
>>> I would suggest replacing one at a time.
>>
>> There is no way to do them one after another copying over all four and
>> then
>> only needing to shut the box down once or failing that doing the process 2
>> times
>> necessitating only 2 shutdowns instead of 4 is there? The external USB box
>> does have room for 2 drives at once.
>
>
> Put two blank drives into the USB, replace first one, replace second one
> (would suggest second drive as non-matching pair). Shutdown, move two new
> drives internal, place two new drives into drive bay, and repeat for the
> last two drives.

How do I determine exactly which are the matching pairs?

Raid 10 means striped and mirrored so I have 2 pairs (AIUI).
I'm thinking its sde and sdf as a pair and then sdb and sdc as the other so if
that's true then I would start with say sde and sdc for the first set
and then do
sdf and sdb for the second.
>
> I would suggest adding a bitmap for at least the time you are doing the
> replacements, then if you have a failure on the USB enclosure during the 2nd
> or 4th drive, at least the 1st or 3rd will re-sync quickly.

Sorry - - - a bitmap - - - not sure what you mean?

Thanking you for your assistance.

Dee
