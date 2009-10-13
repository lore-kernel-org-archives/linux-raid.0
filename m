From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: xfs > md 50% write performance drop on .30+ kernel?
Date: Wed, 14 Oct 2009 08:53:08 +1300
Message-ID: <4AD4DAA4.4080703@sauce.co.nz>
References: <66781b10910120958k4afb637ejba79e4c23900c4da@mail.gmail.com> <4AD3F64F.6070908@sauce.co.nz> <4AD454A0.3050704@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD454A0.3050704@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Asdo wrote:

> Do you think it was controller's overhead? I have heard mixed opinions 
> about 3wares. What are the fastest controllers around for MD-raid use?

The fastest setup I have found have been LSI SAS cards - LSISAS3442E-R, 
with the onboard RAID firmware replaced with the IT firmware.

This is connected to port expander based JBOD chassis loaded with either 
  SAS or SATA drives.

Regards,

Richard
