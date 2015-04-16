From: Thomas MARCHESSEAU <marchesseau@gmail.com>
Subject: Re: RAID 5 "magicaly" become a RAID0
Date: Thu, 16 Apr 2015 10:53:55 +0200
Message-ID: <D1554172.8F19F%marchesseau@gmail.com>
References: <D150B36B.8EE37%marchesseau@gmail.com>
 <552B0B58.8050102@turmel.org>
 <D15148A7.3B83B%marchesseau@gmail.com>
 <552BA12C.3010506@turmel.org>
 <D1517793.3D82D%marchesseau@gmail.com>
 <D151DEA1.8EEA1%marchesseau@gmail.com>
 <552D08C0.1010106@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <552D08C0.1010106@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
Cc: Roger Heflin <rogerheflin@gmail.com>
List-Id: linux-raid.ids

Hi Team ,

>
>Very good to hear this.
It crashed once , but after a reboot and re-assemble ,  i=B9ve backuped
_everything_
=20
-> Thank you very much for you support !
>
>Yes, just --add a spare device to the array, then --grow --level=3D6 t=
o
>start a live reshape.

I tryed , but it failed with many buffer I/O error , ( mostly on the  l=
ast
4 drives , ( not sure , but seems hosted on the same chipset)
And now , i have tons of :
Buffer I/O error on device sdf , logical block 12
=8A  logical block 11 =8A and so on

Same on SDH =20

>


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
