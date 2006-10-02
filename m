From: Joshua Baker-LePain <jlb17@duke.edu>
Subject: Re: Monitoring hardware raid
Date: Mon, 2 Oct 2006 09:20:26 -0400 (EDT)
Message-ID: <Pine.LNX.4.62.0610020919210.11748@chaos.egr.duke.edu>
References: <45210B8D.5070501@afn.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <45210B8D.5070501@afn.org>
Sender: linux-raid-owner@vger.kernel.org
To: Mauricio Tavares <raub@afn.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, 2 Oct 2006 at 8:52am, Mauricio Tavares wrote

> 	I have here a full tower full of drives that is a self-standing
> hardware raid which is connected to a redhat 9 box through a scsi cable.
> Without knowing much more (I am trying to learn more about it like
> what it is up to), is there a raid monitoring package for linux I can
> use to find out what is on its mind? Clicking the buttons besides the
> LCD on the raid box is just not me. And, as I implied, unfortunately I
> do not know much about that raid (like manufacturer, cards used, and so
> on) as of now. It is a bit of a black box... literally.

Generally those sorts of boxes have a serial port you can talk to to get 
status and the like.  They may also have an out-of-band ethernet port for 
the same thing.

All of this is very manufacturer dependent though, *and* has nothing 
whatsoever to do with linux-raid...

-- 
Joshua Baker-LePain
Department of Biomedical Engineering
Duke University
