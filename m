From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: Spares and partitioning huge disks
Date: Sun, 9 Jan 2005 15:28:45 -0500
Message-ID: <200501092028.j09KSr918180@www.watkins-home.com>
References: <41E17117.2090500@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41E17117.2090500@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: 'Michael Tokarev' <mjt@tls.msk.ru>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It is on Neil's wish list (or to do list)!  Mine too!

From Neil Brown:

http://marc.theaimsgroup.com/?l=linux-raid&m=110055742813074&w=2

Guy


-----Original Message-----
From: linux-raid-owner@vger.kernel.org
[mailto:linux-raid-owner@vger.kernel.org] On Behalf Of Michael Tokarev
Sent: Sunday, January 09, 2005 1:00 PM
To: linux-raid@vger.kernel.org
Subject: Re: Spares and partitioning huge disks

Peter T. Breuer wrote:
> Michael Tokarev <mjt@tls.msk.ru> wrote:
> 
>>I think all modern drives support bad block remapping on both read and
write.
>>But think about it: if there's a read error, it means the drive CAN NOT
read
>>the "right" data for some reason (for some definition of "right" anyway)
--
>>ie, the drive "knows" there's some problem with the data and it can't
> 
> I really don't want RAID to fault the disk offline in this case.  I want
> RAID to read from the other disk(s) instead, and rewrite the data on the
> disk that gave the fail notice on that sector, and if that gives no error,
> then just carry on and be happy ...

There where some patches posted to this list some time ago that tries to
do just that (or a discussion.. i don't remember).  Yes, md code currently
doesn't do such things, and fails a drive after the first error -- it's
the simplest way to go ;)

/mjt
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

