From: Asdo <asdo@shiftmail.org>
Subject: Re: Typical RAID5 transfer speeds
Date: Mon, 21 Dec 2009 12:30:34 +0100
Message-ID: <4B2F5C5A.7070702@shiftmail.org>
References: <B26AD6F5-45F6-4CC6-AE63-E4253E60076C@mac.com>
 <4B2D4731.3090702@gmail.com>
 <4877c76c0912192021s2c3da63au57f5dcb0391b3eb3@mail.gmail.com>
 <4B2E6CDB.3000707@gmail.com>
 <4877c76c0912201718l6d7ab948q4c57a07109678cb5@mail.gmail.com>
 <4B2ED47C.7010307@sauce.co.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <4B2ED47C.7010307@sauce.co.nz>
Sender: linux-raid-owner@vger.kernel.org
To: Richard Scobie <richard@sauce.co.nz>
Cc: Michael Evans <mjevans1983@gmail.com>, Roger Heflin <rogerheflin@gmail.com>, Matt Tehonica <matt.tehonica@mac.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Richard Scobie wrote:
> Or use dumb LSI SAS controllers (sas3442e-r with IT firmware loaded, 
> $200) and port expander based chassis that allow considerable 
> flexibility regarding md RAID and number of SAS/SATA drives attached.

The problem then becomes choosing the port expander chassis...
I know nothing about this topic :-(
Does the brand/model make difference in performance or reliability?
Do you have any recommendation? Even just one "known good"...
(These chassis are also quite expensive for what I can see.)

Up to 24 and maybe even 48 drives you can find monolithic solutions (one 
chassis for mainboard and disks), but then not many brands make 16-24 
ports controllers. LSI does not seem to make them, am I correct?

Also in a monolithic storage you only have to check that the controller 
declares compatibility with the drives (sometimes there are indeed 
issues) while for port-replicator based storage I don't know if I should 
check the Compatibility List for drives against controllers, or for 
drives against port replicator, or for controller against port 
replicator...?
