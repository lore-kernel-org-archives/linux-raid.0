From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: Help
Date: Sun, 23 Aug 2009 21:28:25 +0100
Message-ID: <4A91A669.7000505@anonymous.org.uk>
References: <200908210627.06241.Info@quantum-sci.net> <200908220556.32856.Info@quantum-sci.net> <4A902134.2020009@anonymous.org.uk> <200908221112.35952.Info@quantum-sci.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200908221112.35952.Info@quantum-sci.net>
Sender: linux-raid-owner@vger.kernel.org
To: Info@quantum-sci.net
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 22/08/2009 19:12, Info@quantum-sci.net wrote:
> On Saturday 22 August 2009 09:47:48 John Robinson wrote:
[...]
>>> What partition type should I use rather than raid autodetect?  Or should I revert to 0.90 metadata?
>> Probably type DA, Non-FS data, though type FD will be fine even if 
>> they're not auto-detected.
> 
> It simply found 'bad magick' with FD, so that doesn't work with the newer versions.  I tried to use both newer versions, but it's not possible.  You sound not quite sure of the partition type, so I'll stick with FD and 0.90.  Thanks though John.

I said "probably" DA because that's what's been suggested by others 
previously on this list. Others have simply used 83, but that's not 
ideal because if the partitions appear to have filesystems on (e.g. the 
metadata's not at the beginning), they might get auto-mounted without md 
RAID. I'm sure FD will work fine with later metadata versions as long as 
you have mdadm in your initramfs, and while as you've noted there'll be 
a whinge in the boot log about it not being version 0.90, it's not going 
to cause the kernel to lock up or anything like that.

Cheers,

John.
