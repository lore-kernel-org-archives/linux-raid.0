From: Michal Soltys <soltys@ziu.info>
Subject: Re: 2.6.27.10: ata1.00: HPA detected: current 293044655, native 293046768
Date: Tue, 30 Dec 2008 16:41:33 +0100
Message-ID: <495A412D.9040603@ziu.info>
References: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.0812300657050.11356@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org, Alan Piszcz <ap@solarrain.com>
List-Id: linux-raid.ids

Justin Piszcz wrote:
> On one system, two Raptor 150s:
> 
> [    0.739402] ata1.00: HPA detected: current 293044655, native 293046768
> [    0.739491] ata1.00: ATA-7: WDC WD1500ADFD-00NLR5, 21.07QR5, max 
> 
> Why does this occur?
> 

Drives I bought on different occasions also had some of the space 
reserved, while some others didn't. You can change it with hdparm's -N 
option.
