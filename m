From: "Vlad Milovanovic" <vlad@webmail.co.za>
Subject: Re: Adaptec 2010s boot failure
Date: Thu, 13 Mar 2003 11:36:19 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200303130936.h2D9aIK20410@mailgate.mailbox.co.za>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: Nick DeClario <nick@guardiandigital.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Nick,

I had that same card, and it gave me countless problems and headaches.
One thing that I can remember for sure, is that I *never* managed to
get anything to boot of any disk that was connected to the card. I
don't know if I was doing somethingh wrong, but given the amount of
times I have done this sort of thing it is unlikely.

Also I remember having to pass the IRQ and the I/O of the card to the
module with insmod, but it sounds like you have done that since you
are installing fine.

Therefore it is my guess that this is not a bootable card. May I
suggest a small IDE disk for the /boot ?




On Wed, 12 Mar 2003 19:21:06 -0500 Nick DeClario
(nick@guardiandigital.com) wrote:

>Hi.  I have an Adaptec 2010s running on an Intel SE7501WV2
motherboard.
>   I can get both EnGarde Linux and RedHat Linux 8.0 to install
>perfectly but both systems fail on boot.  The RedHat system refuses
to
>load the kernel and reports "Isufficient memory" while the EnGarde
>system starts to load the kernel into memory, stops and prints 80.
>
>I have searched for quite some time for information about this card
and
>have been coming up empty handed.  I can't even find references to it
in
>the kernel.  Adaptec does list the 2010s as compatible with the Intel
>SE7501WV2 motherboard and RedHat 8.0 as well.
>
>Does anyone have any suggestions or can point me to more information?
>
>Thanks,
>     -Nick
>
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid"
in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html

//--------------------------------------
Vlad Milovanovic
vlad@webmail.co.za
_______________________________________________________________
 http://www.webmail.co.za the South-African free email service

  NetWiseGurus.Com Portal - Your Own Internet Business Today!

