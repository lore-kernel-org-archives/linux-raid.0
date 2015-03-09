From: Stefan Lamby <webmaster@peter-speer.de>
Subject: Re: Raid 10 Issue - Swapping Data from Array to Array [SOLVED]
Date: Mon, 9 Mar 2015 09:51:32 +0100 (CET)
Message-ID: <1389629216.43118.1425891092329.JavaMail.open-xchange@app04.ox.hosteurope.de>
References: <1888475554.226351.1425578160090.JavaMail.open-xchange@app09.ox.hosteurope.de> <54F8B792.9060206@turmel.org> <1315687872.8638.1425636591443.JavaMail.open-xchange@app04.ox.hosteurope.de> <54F9A421.2020907@turmel.org>
Reply-To: Stefan Lamby <webmaster@peter-speer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54F9A421.2020907@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi Phil.
I did what you suggested and ended up with a working raid 10 array.

Thank you so much for your support and time.
God blees you.
Stefan


> Phil Turmel <philip@turmel.org> hat am 6. M=C3=A4rz 2015 um 13:57 ges=
chrieben:
>
>
> On 03/06/2015 05:09 AM, Stefan Lamby wrote:
> >
> >
> > This is what I got right now.
> > What do you recommend to do?
>
> 1) pvcreate on the new array
> 2) vgextend to add the new array to the volume group
> 3) pvmove to get the data into the new array
> 4) vgreduce to disconnect the old array from lvm
> 5) pvremove to wipe the old array's lvm meta
> 6) stop the old array
> 7) mdadm --zero-superblock to clear the old members
> 8) mdadm --add to put those members into the new array
>
> Regards,
>
> Phil Turmel
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at http://vger.kernel.org/majordomo-info.html
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
