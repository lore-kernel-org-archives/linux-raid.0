From: Tejun Heo <htejun@gmail.com>
Subject: Re: Linux Software RAID is really RAID?
Date: Wed, 04 Jul 2007 10:20:56 +0900
Message-ID: <468AF5F8.9060703@gmail.com>
References: <cd98e0260706261043t32fe6609ye1e4e252c722358c@mail.gmail.com>	 <46815C3F.6090204@wasp.net.au> <468A05A4.60006@gmail.com> <cd98e0260707030517y1fbb60ban29063439f2665834@mail.gmail.com> <468AD708.2010806@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <468AD708.2010806@rtr.ca>
Sender: linux-ide-owner@vger.kernel.org
To: Mark Lord <liml@rtr.ca>
Cc: Johny Mail list <maillist.johny@gmail.com>, Brad Campbell <brad@wasp.net.au>, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

Mark Lord wrote:
> I believe he said it was ICH5 (different post/thread).
> 
> My observation on ICH5 is that if one unplugs a drive,
> then the chipset/cpu locks up hard when toggling SRST
> in the EH code.
> 
> Specifically, it locks up at the instruction
> which restores SRST back to the non-asserted state,
> which likely corresponds to the chipset finally actually
> sending a FIS to the drive.
> 
> A hard(ware) lockup, not software.
> That's why Intel says ICH5 doesn't do hotplug.

OIC.  I don't think there's much left to do from the driver side then.
Or is there any workaround?

-- 
tejun
