From: o1bigtenor <o1bigtenor@gmail.com>
Subject: Re: Questions
Date: Tue, 16 Feb 2016 05:46:09 -0600
Message-ID: <CAPpdf598JjWbDFs93XU=Ph2EehNkw2qjXthUnGH+8cFs4N=64Q@mail.gmail.com>
References: <CAPpdf58O+=Re1dBe1Rmj7jb=9iJkMZZBuZfEX4S32wMXcv6uWQ@mail.gmail.com>
	<56C0200B.8030606@websitemanagers.com.au>
	<CAPpdf5_JBJB19B7wG5iuTt_aDZ6Zg0=kgQJtR_REU9JfDN1CxA@mail.gmail.com>
	<AE031459-5104-437F-8353-ACF855CB02CC@websitemanagers.com.au>
	<CAPpdf59u6SPD3=sv1XmKR09jzt6OL8TYLgOj==i3G4775fqbhg@mail.gmail.com>
	<56C22C20.9090002@youngman.org.uk>
	<CAPpdf5-LRMk0pcsBrp_nwmrNmPKt5jeo0_zjbH5cMZqA0+LtRQ@mail.gmail.com>
	<56C24B9C.2070506@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <56C24B9C.2070506@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>
Cc: Wols Lists <antlists@youngman.org.uk>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Feb 15, 2016 at 4:05 PM, Adam Goryachev
<mailinglists@websitemanagers.com.au> wrote:


>
> I wanted to mention this, what drives do you have right now, and do know
> about SCT ERC?
> Maybe start here (but you probably need to read more):
> http://www.spinics.net/lists/raid/msg48199.html

A major reason as to why the drives are getting replaced. Back in early 2012
when I setup the machine there was no obvious information that the ERC
type drives were needed so I just bought vanilla drives.
>
> Essentially, your current disks might be fine, but if you don't have the
> right settings, they could be "failing" regularly putting your data at risk.
> You should fix any issue here before you attempt to replace your drives.

I now have 2 long term drives which are likely still good and 2 cheap
drives that
are quite new but which I don't trust for long term reliability,
therefore the push
to change them all.
>
>> the fail remove and add process 4 seperate times might not be a good thing
>> but I do not know of a different option. Compounding the difficulty is
>> that there
>> are no empty hard drive slots in the machine. I do have an external USB
>> 3.0
>> 2 drive holder that could be used.
>>
>> The only suggestion in all the documents I perused was to place spare
>> drives
>> into something like this external box and then add the drives into the
>> array.
>> The process was not laid out and leaves me with a number of questions.
>>
>> Is there a suggested method for replacing ALL the drives in an array (raid
>> 10
>> in this case)?
>
>
> In order to replace all drives, I would suggest that you simply replace one
> drive 4 times (different drive each time).
> The first question to ask, is your external USB drive bay reliable? If not,
> then there are other solutions that are probably less dangerous.
>
> So, add your spare drive to the external USB drive bay, it should show up as
> /dev/sdy (for example)
> Partition to match the rest of your existing drives
> Add the new partition to your existing array: mdadm --manage /dev/md0 --add
> /dev/sdx1
> Replace one of the existing drives with the new one: mdadm /dev/md0
> --replace /dev/sda1 --with /dev/sdx1
> Personally, because I distrust the external USB drive bay (don't ask me why,
> it just seems less reliable than internal sata), once the drive has finished
> being replaced, I would shutdown, remove the old drive, and install the
> replacement drive, then add another new spare, and repeat.
>
> You can see this page for some extra information:
> http://unix.stackexchange.com/questions/74924/how-to-safely-replace-a-not-yet-failed-disk-in-a-linux-raid5-array
>>
>> If I use the external box how do I do this (external box only holds 2
>> drives) so
>> that I can transfer the information on the drives from the array to
>> the new drives
>> and then just replace the drives 2 at a time into the machine without
>> there being
>> issues because in the information transfer the drives will be sdg and
>> sdh (AFAIK)
>> and later they will be some of sdb, sdc, sde, and/or sdf.
>
> I would suggest replacing one at a time.

There is no way to do them one after another copying over all four and then
only needing to shut the box down once or failing that doing the process 2 times
necessitating only 2 shutdowns instead of 4 is there? The external USB box
does have room for 2 drives at once.

TIA

Dee
