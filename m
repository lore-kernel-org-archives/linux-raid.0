From: Oliver Elphick <olly@lfix.co.uk>
Subject: Re: Linux dpti driver in 2.4 kernel with Adaptec 2400A card
Date: 18 Feb 2003 12:16:51 +0000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1045570610.7296.70.camel@linda.lfix.co.uk>
References: <1041614772.19602.379.camel@linda.lfix.co.uk>
	 <3E1A10D0.7080603@etr-usa.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3E1A10D0.7080603@etr-usa.com>
To: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, 2003-01-06 at 23:27, Warren Young wrote:
> Oliver Elphick wrote [ Jan 3rd 2003]:
> > I'm trying to install Debian Linux with kernel 2.4.20 on a machine with an
> > Adaptec 2400A RAID card with 3 40Gb IDE disks attached.  
> 
> [snip]
> 
> > dpti0: Trying to reset device
> > dpti0: Device reset not supported
> > dpti0: Bus reset: SCSI Bus 0: tid: 11
> > dpti0: Bus reset success.
> > scsi: device set offline - not ready or command retry failed after bus reset: host 0 channel 0 id 0 lun 0
> > SCSI disk error:  host 0 channel 0 id 0 lun 0 return code = 30002
> >  I/O error: dev 08:00, sector 0
> >  I/O error: dev 08:00, sector 2
> >  I/O error: dev 08:00, sector 0
> >  unable to read partition table
> 
> I don't have your particular controller card (I've used the 2100S 
> before, though) or anything else particular to your system, but since no 
> one else has answered yet....
> 
> These messages say "cable problems" to me.  It appears that you have it 
> configured for RAID-5, so try asking the RAID BIOS to do a complete 
> rebuild.  This will force it to access all three disks intensely for a 
> while.  If it passes on that, forget my diagnosis. 

Just to note the solution to this problem for the record; it was not a
cable problem - the build went through without any errors, apart from
its taking several hours.  I removed the card from the machine to get
its serial number so as to call Adaptec's support; when I put it back
in, it worked perfectly!  

Thanks for your advice.

-- 
Oliver Elphick                                Oliver.Elphick@lfix.co.uk
Isle of Wight, UK                             http://www.lfix.co.uk/oliver
GPG: 1024D/3E1D0C1C: CA12 09E0 E8D5 8870 5839  932A 614D 4C34 3E1D 0C1C
                 ========================================
     "All we like sheep have gone astray; we have turned 
      every one to his own way; and the LORD hath laid on 
      him the iniquity of us all."         Isaiah 53:6 

