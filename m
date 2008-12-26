From: Robert Hancock <hancockr@shaw.ca>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Fri, 26 Dec 2008 16:15:51 -0600
Message-ID: <49555797.3080009@shaw.ca>
References: <87f94c370812261344s3f70de25r4d132101d2247e00@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370812261344s3f70de25r4d132101d2247e00@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

Greg Freemyer wrote:
> All,
> 
> On the mdraid list, there was a recent thread about using raid
> functionality to detect / repair silent corruption.
> 
> The issues brought up were that a lot of silent data corruption occurs
> when cables, controllers, power supplies, ram, cache, etc. goes bad.
> 
> It made me think about another option for detecting silent corruption
> I have not seen discussed, but maybe I missed it.
> 
> Aiui, the ATA spec allows for the reading of a long sector as well as
> the normal 512 byte sector.  When you get a long sector you also get
> the CRC (or whatever checksum data there is on the disk that allows
> the drive itself to detect media errors).
> 
> I don't have any idea how easy or hard it would be to do, but I would
> like to see the entire block subsystem enhanced to optionally allow
> long sector reads to be used in a "paranoid" fashion.
> 
> Effectively it would be:
> 
> 1) Read long sector from drive:  verify CRC in kernel.  This tests
> most everything on the i/o path.
> 
> 2) maintain CRC type information in block subsystem.  Verify no
> corruption just before handing off to userspace.  This would
> potentially identify CPU/cache/RAM failures.

Even if the drive supports those commands the problem is the CRC/ECC 
data is in a vendor-specific format, so it couldn't be processed 
generically.

