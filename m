From: Wols Lists <antlists@youngman.org.uk>
Subject: Re: Questions
Date: Mon, 15 Feb 2016 22:09:04 +0000
Message-ID: <56C24C80.1090505@youngman.org.uk>
References: <CAPpdf58O+=Re1dBe1Rmj7jb=9iJkMZZBuZfEX4S32wMXcv6uWQ@mail.gmail.com>
 <56C0200B.8030606@websitemanagers.com.au>
 <CAPpdf5_JBJB19B7wG5iuTt_aDZ6Zg0=kgQJtR_REU9JfDN1CxA@mail.gmail.com>
 <AE031459-5104-437F-8353-ACF855CB02CC@websitemanagers.com.au>
 <CAPpdf59u6SPD3=sv1XmKR09jzt6OL8TYLgOj==i3G4775fqbhg@mail.gmail.com>
 <56C22C20.9090002@youngman.org.uk>
 <CAPpdf5-LRMk0pcsBrp_nwmrNmPKt5jeo0_zjbH5cMZqA0+LtRQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAPpdf5-LRMk0pcsBrp_nwmrNmPKt5jeo0_zjbH5cMZqA0+LtRQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: o1bigtenor <o1bigtenor@gmail.com>
Cc: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 15/02/16 21:01, o1bigtenor wrote:
> I have a present working array and with to replace its components with the
> same size but new drives (which are NAS rated). Was thinking that using
> the fail remove and add process 4 seperate times might not be a good thing
> but I do not know of a different option. Compounding the difficulty is
> that there
> are no empty hard drive slots in the machine. I do have an external USB 3.0
> 2 drive holder that could be used.

Does it have a spare PCI slot? That's what I was getting at - can you
add two more sata slots? Presumably not if it's a cage, but if it's a
computer case? As I said, a spare PCI SATA card should be dirt cheap to
add temporary extra capacity. And does it matter if the case is open and
the drives lying around temporarily?
> 
> The only suggestion in all the documents I perused was to place spare drives
> into something like this external box and then add the drives into the array.
> The process was not laid out and leaves me with a number of questions.
> 
> Is there a suggested method for replacing ALL the drives in an array (raid 10
> in this case)?

As far as I'm aware, there's just the "mdadm --replace" I mentioned -
drive by drive. Given that it's raid 10, maybe you can just add another
mirror then fail an old one.

I'd just plug in the extra drives, run mdadm --replace, and then remove
the old drives. Just make sure you get the right drives! And always use
uuids so you know which drive is which!

Get Phil's lsdrv and it will probably give you all the drives, with
serial numbers, etc etc. I haven't managed to run it so I can't be sure
:-) But it's intended to give you all the stuff you need to recover an
array so it should give you the information you need to rebuild it.
> 
> If I use the external box how do I do this (external box only holds 2 drives) so
> that I can transfer the information on the drives from the array to
> the new drives
> and then just replace the drives 2 at a time into the machine without
> there being
> issues because in the information transfer the drives will be sdg and
> sdh (AFAIK)
> and later they will be some of sdb, sdc, sde, and/or sdf.

That's why they now have uuids.

ls /dev/disk/by-id

I *think* raid uses uuids internally. So swapping the drives out won't
be a problem - the sdx names are just used as a human-readable output.
But don't take that as gospel ... However, bear in mind that the kernel
does NOT guarantee that a drive will get the same sdx name from one boot
to the next. It so happens that that is the norm, but it's not
guaranteed ... so x changing for any value of sdx shouldn't be a problem.

Regardless, you should not be using sdx. Everything should be using
uuids, my /etc/fstab is a lovely mangle with all those long uuids
everywhere :-)

Cheers,
Wol
