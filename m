From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Bug with RAID1 hot spares?
Date: Tue, 24 Oct 2006 21:41:24 -0400
Message-ID: <453EC0C4.2040006@tmr.com>
References: <200610202046.43033.chase.venters@clientec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200610202046.43033.chase.venters@clientec.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chase Venters <chase.venters@clientec.com>
Cc: linux-raid@vger.kernel.org, jason.meinzer@gmail.com
List-Id: linux-raid.ids

Chase Venters wrote:

>Greetings,
>	I was just testing a server I was about to send into production on kernel 
>2.6.18.1. The server has three SCSI disks with "md1" set to a RAID1 with 2 
>mirrors and 1 spare.
>
I have to ask, why? If the array is mostly written you might save a bit 
of bus time, but for reads having another copy of the data to read 
(usually) helps the performance by reducing wait for read occurences.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

