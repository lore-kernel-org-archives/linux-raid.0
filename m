From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: Status of Promise drivers?
Date: Tue, 30 Dec 2003 15:27:04 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3FF1DF98.7000600@pobox.com>
References: <20031230200012.C14399@nettis.grimsta> <3FF1CCC1.3050304@pobox.com> <20031230202447.D14399@nettis.grimsta> <3FF1D8AE.2000107@pobox.com> <20031230202146.GL16346@hvs.envisage.co.za>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20031230202146.GL16346@hvs.envisage.co.za>
To: Hendrik Visage <hvisage@envisage.co.za>
Cc: Daniel Brahneborg <daniel.com@wtnord.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hendrik Visage wrote:
> On Tue, Dec 30, 2003 at 02:57:34PM -0500, Jeff Garzik wrote:
> 
>>Which VIA driver are you referring to?  And PATA or SATA?  You need to 
>>be more specific :)   The drivers/ide via82cxxx driver seems to work for 
>>PATA.  The sata_via ("scsi") driver and the generic IDE driver work for 
>>VIA SATA, but people have reported problems on x86-64.
> 
> 
> Hi Jeff, what type of problems have been seen on x86-64 and sata_via?
> 
> Haven't had much trouble personaly yet...


For some people it flat-out doesn't work at all :)  This might be a 
problem with the x86-64 iommu though...

Typically with sata_via, it either works 100%, or it doesn't work at 
all.  (it works for most people, but as we see with Daniel there are 
still some problems)

	Jeff



