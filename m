From: Jon Lewis <jlewis@lewis.org>
Subject: Re: Monitoring hardware raid
Date: Mon, 2 Oct 2006 10:09:30 -0400 (EDT)
Message-ID: <Pine.LNX.4.61.0610021007440.2498@soloth.lewis.org>
References: <45210B8D.5070501@afn.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45210B8D.5070501@afn.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mauricio Tavares <raub@afn.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2 Oct 2006, Mauricio Tavares wrote:

> 	I have here a full tower full of drives that is a self-standing
> hardware raid which is connected to a redhat 9 box through a scsi cable.

With hardware SCSI-attached RAID, odds are, if there are any monitoring 
utilities, they'll be proprietary to that hardware RAID device, so you'll 
need to see if the manufacturer has tools for Linux, or search the net and 
see if any 3rd party has figured out how to talk to the device.

----------------------------------------------------------------------
  Jon Lewis                   |  I route
  Senior Network Engineer     |  therefore you are
  Atlantic Net                |
_________ http://www.lewis.org/~jlewis/pgp for PGP public key_________
