From: Wolfgang Denk <wd@denx.de>
Subject: Re: device and partition alignment
Date: Sun, 06 Jun 2010 00:11:39 +0200
Message-ID: <20100605221139.D066814E867@gemini.denx.de>
References: <000b01cb04f0$dbcf7720$936e6560$@woodlea.com> <4C0AC6E4.4080408@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4C0AC6E4.4080408@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: st0ff@npl.de, =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?= <stefan.huebner@stud.tu-ilmenau.de>
Cc: Graham Mitchell <gmitch@woodlea.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Dear Stefan,

In message <4C0AC6E4.4080408@stud.tu-ilmenau.de> you wrote:
> 
> I guess you couldn't find much about this as it has more to do with
> common sense than magic formulae.  If you have 4k-sector drives, align
> everything at multiples of 4k, use filesystem-units of multiples of 4k.
>  As I read and it also seems very logical from the ATA / SCSI point of
> view, a stripe size of 256k seems most straight forward.  This is the
> largest amount of data (a.t.m.) that can be read or written with a
> single command to a disk.

And why would that be optimal, in general?

For example, in a file system I have here (with some 15 millions
files) we see the following distribution of file sizes:

	65%   are smaller than  4 kB
	80%   are smaller than  8 kB
	90%   are smaller than 16 kB
	96%   are smaller than 32 kB
	98.4% are smaller than 64 kB 

With many write accesses going on, a stripe size of 16 KiB gives much
better performance.

I think you cannot recommend a stripe size or other specific tuning
measures without exactly knowing the characteristics of the load.

Best regards,

Wolfgang Denk

-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-10 Fax: (+49)-8142-66989-80 Email: wd@denx.de
Accident: A condition in which presence of mind is good, but  absence
of body is better.
