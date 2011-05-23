From: =?ISO-8859-15?Q?Stefan_/*St0fF*/_H=FCbner?=
	<stefan.huebner@stud.tu-ilmenau.de>
Subject: Re: HBA Adaptor advice
Date: Mon, 23 May 2011 07:30:19 +0200
Message-ID: <4DD9F0EB.5040801@stud.tu-ilmenau.de>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <4DD99FF2.2030609@fnarfbargle.com> <4DD9A558.7000802@fnarfbargle.com>
Reply-To: stefan.huebner@stud.tu-ilmenau.de
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD9A558.7000802@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 23.05.2011 02:07, schrieb Brad Campbell:
> On 23/05/11 07:44, Brad Campbell wrote:
>> He used WD commodity drives on a "hardware" RAID enclosure that needed
>> TLER. The RAID-5 kicked out 4
>> drives in a short period of time, so he power cycled it and
>> re-initialised the array and it came up
>> fine, but blank (as it would as he re-initialised it).
>>
> 
> Just to clarify that as it was somewhat muddled. The initial failure was
> on an unspecified array with unspecified drives and resulted in a blank
> array. The backup failure was TLER related using WD GP drives on a
> hardware array and was left unresolved.
> 
> That's still not concrete evidence of those drives failing, it's just
> using the wrong tool for the wrong job.

Just to clarify a bit more: the elder WD20EADS (notice the 'D') worked
very well and until Nov 2009 they were TLER capable (which means: ERC
timeouts could be set to non-zero, the setting was preserved over
power-cycles).  Short after the Firmware-Patch that removed the
TLER-ability those WD20EARS (notice 'R') appeared.  From that moment on
our WD-failure-rates started to climb noticeably and has not fallen
again, since.

We also noticed that WD started to do the same mistake (customer-wise)
as Seagate.  More than 50% of their "certified repaired" disks (those
which you get back after sending in defective drives for RMA) died soon
after putting them back into work.  I will not comment further on this
statement.

We sell 200+ drives a week from our "at that time preferred"
Manufacturer.  That was WD from 2008 till the beginning of 2010.  But
since the climb of wd failure rates we're at "Hitachi" and have
astounding failure rates of less than one percent.  I hope this will
stay the case even after WD bought Hitachi GST...

Conclusion about this university-storage-failure: wrong drives for this
scenario.  It would've been OK to use the cheap WDs for backup (if the
backup was at least RAID6 and sends error-mails to the admin).  But the
primary storage was a big fail.  You do not use this kind of storage for
data which is worth much time (and by that much money).

Just a few pro-cents,
Stefan
