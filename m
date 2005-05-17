From: Jay Strauss <me@heyjay.com>
Subject: Re: Raid 1 install revealed poor HD performance (I think)
Date: Tue, 17 May 2005 11:17:40 -0500
Message-ID: <428A1924.8030801@heyjay.com>
References: <428A09A3.9000802@heyjay.com> <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.56.0505171649090.32621@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Gordon Henderson <gordon@drogon.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Gordon Henderson wrote:
> On Tue, 17 May 2005, Jay Strauss wrote:
> 
> 
>>I'm very unfamiliar with options for speeding up hard drive access.
>>What might Knoppix be setting (and how would I look for it), that it's
>>getting 100% better drive performance than a plain jane Sarge install?
> 
> 
> The usual culprit is DMA. (Or lack of it in your case)
> 
> What does
> 
>   hdparm /dev/hda
> 
> give under each OS?
> 
> You can use hdparm to enable DMA, but this doesn't always work - the real
> solution is to work out what type of IDE controller you have and make sure
> it's compiled into your kernel.
> 
> Gordon
> 
> 
> 

thanks Gordon, below are the outputs from both trials.  How would I go 
about finding out the IDE controller I have?


Sarge:~# hdparm /dev/hda

/dev/hda:
  multcount    =  0 (off)
  IO_support   =  0 (default 16-bit)
  unmaskirq    =  0 (off)
  using_dma    =  1 (on)
  keepsettings =  0 (off)
  readonly     =  0 (off)
  readahead    = 256 (on)
  geometry     = 19457/255/63, sectors = 312581808, start = 0

knoppix

/dev/hda:
  multcount    = 16 (on)
  IO_support   =  0 (default 16-bit)
  unmaskirq    =  0 (off)
  using_dma    =  1 (on)
  keepsettings =  0 (off)
  readonly     =  0 (off)
  readahead    =  8 (on)
  geometry     = 19457/255/63, sectors = 312581808, start = 0

