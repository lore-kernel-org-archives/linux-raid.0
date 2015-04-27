From: David Brown <david.brown@hesbynett.no>
Subject: Re: Paranoid mode for RAID-1 ?
Date: Mon, 27 Apr 2015 09:15:26 +0200
Message-ID: <553DE20E.2020605@hesbynett.no>
References: <972437107.22507366.1430116679975.JavaMail.zimbra@laposte.net> <553DDBB3.2010306@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <553DDBB3.2010306@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 27/04/15 08:48, Adam Goryachev wrote:
> On 27/04/15 16:37, Jean-Baptiste Thomas wrote:
>> I'm looking for a way to get MD to operate in a mode in which
>> reading a sector from a RAID-1 device would not succeed until it
>> got matching data from at least two components.
>>
>> Recent experience[1] suggests that a transient problem in one
>> disk can completely hose a four way RAID-1 array, which is
>> otherwise supposed to still be fine after a triple total
>> failure. I'm hoping that a paranoid mode would have prevented
>> that.
> 
> There isn't any such thing that I am aware of in Linux MD RAID. However,
> I've heard that if you want data integrity, then you could use zfs,
> which supports RAID as well as data checksums to ensure that the data
> read back matches the data you wrote....
> 
> Personally, I've never used zfs, and there might be other FS's that will
> have the feature as well (eg, btrfs etc).
> 

btrfs has data checksums like that.  Like Neil, I question the necessity
for harddisks, but such checksums are lower cost than reading the data
twice from two disks (as they are stored as part of the metadata that
you already read), and can offer some protection against serious
hardware problems.  (Checksums like this cannot easily be implemented in
a transparent block device such as md raid - it is more practical to
have them as part of the filesystem, as done with btrfs.)

> Hope that helps...
> 
> Regards,
> Adam

