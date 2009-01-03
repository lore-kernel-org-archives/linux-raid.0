From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Sat, 03 Jan 2009 13:20:34 +0000
Message-ID: <495F6622.9010103@anonymous.org.uk>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>	<fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>	<49580061.9060506@yahoo.com>	<87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com> <yq13ag174af.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq13ag174af.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/01/2009 22:04, Martin K. Petersen wrote:
[...]
> I wrote something akin to DIF in software by doing 64 512-byte blocks +
> 512 bytes of checksums.  The disadvantage there is having to do
> read-modify-write for small writes.  I tried several other approaches
> sacrificing both space and locality but performance was still anemic.

Excuse me if I'm being dense - and indeed tell me! - but RAID 4/5/6 
already suffer from having to do ready-modify-write for small writes, so 
is there any chance this could be done at relatively little additional 
expense for these?

Cheers,

John.

