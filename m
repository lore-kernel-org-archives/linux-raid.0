From: Doug Ledford <dledford@redhat.com>
Subject: Re: Port Multipliers
Date: Tue, 15 Sep 2009 13:56:36 -0400
Message-ID: <B1A260D7-B6A2-40D3-83FF-9571D80B66B8@redhat.com>
References: <c268e4660909100556x14b48207w32017a59be889f@mail.gmail.com>  <70ed7c3e0909100911q926fa9cs9185854b15dd8764@mail.gmail.com>  <c268e4660909101135w4b933cbaj3e6a18e6b586fd62@mail.gmail.com> <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>
Mime-Version: 1.0 (Apple Message framework v936)
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha1; boundary="Apple-Mail-20--147709903"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909101144u2c42a1b2scf69e83df931035d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: Drew <drew.kay@gmail.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--Apple-Mail-20--147709903
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit

On Sep 10, 2009, at 2:44 PM, Majed B. wrote:
> The maximum throughput you'll get is the PCI bus's speed. Make sure to
> note which version your server has.
>
> The silicon image controller will be your bottleneck here, but I don't
> have any numbers to say how much of a loss you'll be at. You'd have to
> search around for those who already benchmarked their systems, or
> buy/request a card to test it out.

I've actually been doing some of those benchmarks here.  Given a  
Silicon Image 3124 card in a x1 PCI-e slot, my maximum throughput  
should be about 250MB/s (PCI-e limitation).  My drives behind the pm  
are all capable of about 80MB/s, and I have 4 drives.  What I've found  
is that when accessing one drive by itself, I get 80MB/s.  When  
accessing more than one drive, I get a total of about 120MB/s, but  
it's divided by however many drives I'm accessing.  So, two drives is  
roughly 60MB/s each, 3 drives about 40MB/s each, and 4 drives about  
30MB/s each.

This is then complicated by whether or not you have motherboard ports  
in the same raid array.  As the motherboard ports all get simultaneous  
drive speed more or less (up to 500MB/s aggregate in my test machine  
anyway), it's worth noting that the motherboard drives slow down to  
whatever speed you are getting on the drives behind the pm whenever  
they are combined.  So, even if 5 drives on the motherboard could do  
500MB/s total, 100MB/s each, if they are combined with 4 drives behind  
a pm at 30MB/s each, they switch down to 30MB/s each as well, and the  
combined total would then become 9 * 30MB/s for 270MB/s, considerably  
slower than just the 5 drives on the motherboard by themselves.   
However, if all your drives are behind pms, then I would expect to get  
a fairly linear speed increase as you increase the number of pms.  You  
can then control how fast the overall array is by controlling how many  
drives are behind each pm up to the point that you reach PCI bus or  
memory or CPU bottlenecks.

> If you do get a card and test it, make sure that you report back to us
> and update the wiki: http://linux-raid.osdl.org/index.php/Performance
>
> On Thu, Sep 10, 2009 at 9:35 PM, Drew<drew.kay@gmail.com> wrote:
>>> If you're looking at port multipliers, you need to find PCI-Express
>>> modules if you want them to be fast. The PCI ones are gonna be very
>>> slow when you have more than 2 disks per card.
>>
>> I'm definitely going to use the PCIX/PCIe slots for the Host Adapter.
>>
>> What I'm wondering is if I use a HBA and Port Multiplier that support
>> FIS based switching, say a Sil 3124 & 3726, how much of a loss in  
>> data
>> transfer rate can I expect from the RAID array built off the PM as
>> opposed to each disk plugged in separately?
>>
>> An example configuration I'm looking at is a Sil3124 4 port HBA with
>> three of the ports having Sil3726 5to1 PMs attached. Each PM then has
>> four disks hung off the PM. If I create a RAID5 array for example on
>> each PM, what sort of speed degradation would I be looking at  
>> compared
>> to making a RAID5 off just the 3124?
>>
>> --
>> Drew
>>
>> "Nothing in life is to be feared. It is only to be understood."
>> --Marie Curie
>>
>
>
>
> -- 
>       Majed B.
> --
> To unsubscribe from this list: send the line "unsubscribe linux- 
> raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--

Doug Ledford <dledford@redhat.com>

GPG KeyID: CFBFF194
http://people.redhat.com/dledford

InfiniBand Specific RPMS
http://people.redhat.com/dledford/Infiniband





--Apple-Mail-20--147709903
content-type: application/pgp-signature; x-mac-type=70674453;
	name=PGP.sig
content-description: This is a digitally signed message part
content-disposition: inline; filename=PGP.sig
content-transfer-encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG/MacGPG2 v2.0.12 (Darwin)

iEYEARECAAYFAkqv1VUACgkQg6WylM+/8ZQQtACglbO4W9wvoVduLxNrREPIsrtG
QFIAnj9gN1F/HSrlX9YeWtzwTZ/WWTJq
=FRct
-----END PGP SIGNATURE-----

--Apple-Mail-20--147709903--
