From: Anton Starikov <A.Starikov@utwente.nl>
Subject: Re: Support for PATA in Promise 378 driver
Date: Fri, 27 Feb 2004 20:45:15 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040227204515.54c847a0@hantst.kabel.utwente.nl>
References: <20040223141636.20fed6ba@hantst.kabel.utwente.nl>
	<20040223133539.GO6255@hvs.envisage.co.za>
	<20040223144519.45741d5a@hantst.kabel.utwente.nl>
	<403F92ED.8040500@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <403F92ED.8040500@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Hendrik Visage <hvisage@envisage.co.za>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Yes. I'm using this driver with 2.4

BUT, in order to compile it with 2.6 it should be fixed a lot.
I fixed it, but didn't  try yet. (I'm to lazy to reboot this days :))

Anton

On Fri, 27 Feb 2004 13:56:45 -0500
Jeff Garzik <jgarzik@pobox.com> wrote:

> Anton Starikov wrote:
> > But what about driver from Promise? 
> > Nobody yet forbid reverse engineering :)
> > It could be a not a big fun of course...
> > 
> > Two facts make me optimistic:
> > 1) There open-source driver from Promise
> > 2) There is driver in FreeBSD (it use cam also as I understand), I
> > have feeling that driver from BSD has support for PATA port, am I
> > right?
> 
> 
> BTW the GPL'd "SCSI" driver from Promise supports the PATA port...
> 
> 	Jeff
> 
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"
> in the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
