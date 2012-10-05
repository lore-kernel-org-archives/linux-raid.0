From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Promise SATA TX4 300 + 3TB disks?
Date: Fri, 05 Oct 2012 15:37:29 +0100
Message-ID: <506EF0A9.4080501@anonymous.org.uk>
References: <818058745.20121005012826@oudeis.org> <20121005123653.0a5398e0@natsu> <506E9E77.1080002@hardwarefreak.com> <20121005145011.673f4974@natsu> <719665592.20121005153321@oudeis.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <719665592.20121005153321@oudeis.org>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Rainer_F=FCgenstein?= <rfu@oudeis.org>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/10/2012 14:33, Rainer F=FCgenstein wrote:
> roman, stan,
>
> thanks for your input. I should have added some more information:
>
> the mainboard is an intel D510MO which has "only" one PCI slot and 2
> SATA ports. one port runs a 60GB SSD (system), the 2nd one a 3TB WD
> drive for temporary data.
> http://www.intel.com/content/www/us/en/motherboards/desktop-motherboa=
rds/desktop-board-di510mo.html
>
> the 4x 1.5TB drives are connected to the promise TX4 300 in the only
> PCI slot.

Since you already have a 3TB drive, plug it in to the Promise card and=20
see if it's recognised. Swapping drives around between adapters=20
shouldn't upset md at all here.

Cheers,

John.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
