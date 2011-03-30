From: Steven Haigh <netwiz@crc.id.au>
Subject: Re: looking for advice on raid drives upgrade
Date: Thu, 31 Mar 2011 00:31:57 +1100
Message-ID: <4D9330CD.7090806@crc.id.au>
References: <imuu5b$gaf$1@dough.gmane.org> <imvadk$q8j$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <imvadk$q8j$1@dough.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david@westcontrol.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31/03/2011 12:14 AM, David Brown wrote:
> If you've got a spare drive slot, and plenty of time, there is another
> option that lets you keep online and redundant during the process.
> Re-shape the array to raid 6, while adding one of the new drives. Then
> you can replace each drive, one at a time, letting the raid recover in
> between. For the last drive, you just have to remove it then reshape
> back to raid 5 (although ideally you could buy an extra drive and keep
> the raid 6 layout - it's worth the cost, assuming you have the drive slot).
>
> Once everything is swapped over, you grow the array to fit the new disks.

This makes me wonder... What is recommended as the best practice... Use 
the entire disk or 1 partition per device? Assuming of course that you 
won't be booting off the RAID5/6....

-- 
Steven Haigh

Email: netwiz@crc.id.au
Web: http://www.crc.id.au
Phone: (03) 9001 6090 - 0412 935 897
Fax: (03) 8338 0299

