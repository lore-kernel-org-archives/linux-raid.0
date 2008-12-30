From: Mark Lord <liml@rtr.ca>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Tue, 30 Dec 2008 08:48:33 -0500
Message-ID: <495A26B1.1070004@rtr.ca>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no> <fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no> <49580061.9060506@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <49580061.9060506@yahoo.com>
Sender: linux-raid-owner@vger.kernel.org
To: Sitsofe Wheeler <sitsofe@yahoo.com>
Cc: Greg Freemyer <greg.freemyer@gmail.com>, Redeeman <redeeman@metanurb.dk>, piergiorgio.sartor@nexgo.de, neilb@suse.de, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sitsofe Wheeler wrote:
> Mark Lord wrote:
> 
>> There's a separate effort, involving drive vendors and kernel hackers,
>> to provide end-to-end CRC protection of data.  I forget what it was 
>> called,
>> but that's the future of this stuff for high-reliability requirements.
> 
> Are you thinking of BLK_DEV_INTEGRITY which tries to support T10/SCSI 
> Data Integrity Field or the T13/ATA External Path Protection?
..

One or both of those, I think.  Bad memory here, though!  :)
