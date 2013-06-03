From: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: RAID-10 keeps aborting
Date: Sun, 02 Jun 2013 21:05:09 -0700
Message-ID: <51AC15F5.9090903@zytor.com>
References: <51AC1440.7020505@zytor.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51AC1440.7020505@zytor.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 06/02/2013 08:57 PM, H. Peter Anvin wrote:
> Hello,
> 
> I have a brand new server with a RAID-10 array.  The drives are a SAS
> JBOD (mptsas) which I'm driving using Linux mdraid raid10.
> 
> Unfortunately, although the server did burn-in fine, once put in
> production I have so far had multiple cases (about once every 24 hours)
> of the raid10 failing, with a mirror pair dropping out in very short
> succession:
> 
> Jun  2 20:23:05 terminus kernel: [83595.614689] md/raid10:md4: Disk
> failure on sdb6, disabling device.
> Jun  2 20:23:05 terminus kernel: [83595.614689] md/raid10:md4: Operation
> continuing on 3 devices.
> Jun  2 20:23:05 terminus kernel: [83595.703106] md/raid10:md4: Disk
> failure on sdc6, disabling device.
> Jun  2 20:23:05 terminus kernel: [83595.703106] md/raid10:md4: Operation
> continuing on 2 devices.
> Jun  2 20:23:05 terminus kernel: [83595.789234] md4: WRITE SAME failed.
> Manually zeroing.
> 

For the record, this is kernel 3.8.13 (-100.fc17 from Fedora).

	-hpa


