From: Patrik Jonsson <patrik@ucolick.org>
Subject: Re: raid1 mysteriously switching to read-only
Date: Sun, 11 Dec 2005 15:14:39 +0100
Message-ID: <439C344F.9020408@ucolick.org>
References: <20051128102824.14498.patches@notabene>	 <1051127234104.14937@suse.de>	 <ee0ae26a0512092241v3ee5e445r@mail.gmail.com>	 <17306.31969.240202.416327@cse.unsw.edu.au>	 <ee0ae26a0512092350k43b6dc8l@mail.gmail.com>	 <17306.35737.880103.939683@cse.unsw.edu.au>	 <ee0ae26a0512100010v4d93d107k@mail.gmail.com>	 <17306.50617.458648.8740@cse.unsw.edu.au> <ee0ae26a0512110504y63589bck@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig456700270ACEEF32A50A5200"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <ee0ae26a0512110504y63589bck@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Yanggun <yang.geum.seok@gmail.com>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig456700270ACEEF32A50A5200
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

hello,

Perhaps this can answer some questions:

http://www.tldp.org/HOWTO/Software-RAID-HOWTO.html

cheers,

/Patrik

Yanggun wrote:
> Thank you very much.
> 
> Can you inform it is what difference technologically?
> 
> Yanggun
> 
> 2005/12/10, Neil Brown <neilb@suse.de>:
> 
>>On Saturday December 10, yang.geum.seok@gmail.com wrote:
>>
>>>Should I do format after make RAID-1(/dev/md0) device?
>>
>>Yes.  format (mkfs) must come AFTER make RAID1 (mdadm -C).
>>
>>>After I format disks(/dev/sda1, /dev/sdb1), do not you compose to
>>>RAID-1?
>>
>>Don't format sda1 or sdb1.  Compose the RAID-1 first, and then format
>>md0.
>>
>>NeilBrown
>>
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> !DSPAM:439c3231294002003030161!
> 

--------------enig456700270ACEEF32A50A5200
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (MingW32)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDnDRVT+KvsdUW5p8RAnxhAKCPTBUp12xK0zpQ1ow3rwmYnkkpowCgqtvP
E9hrDn0XCZ8GZoZiObiX+bQ=
=FXe+
-----END PGP SIGNATURE-----

--------------enig456700270ACEEF32A50A5200--
