From: Hannes Reinecke <hare@suse.de>
Subject: Re: LSI RAID
Date: Tue, 28 Feb 2017 10:06:01 +0100
Message-ID: <73fdfb90-4bdc-a452-d785-eb270ad987e2@suse.de>
References: <CAJH6TXj+766Xj4w8BAOoq9wQ_Vym_JD66pbqRgpXriNguG6zTQ@mail.gmail.com>
 <CAJH6TXhwfoWKM2=0v0+qhUWp=WppF5qO7zm5Y1-vS4zWQHA5WA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJH6TXhwfoWKM2=0v0+qhUWp=WppF5qO7zm5Y1-vS4zWQHA5WA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 02/27/2017 05:02 PM, Gandalf Corvotempesta wrote:
> anyone?
> 
> 2017-02-13 11:33 GMT+01:00 Gandalf Corvotempesta
> <gandalf.corvotempesta@gmail.com>:
>> Hi to all
>> silly question: i've read that LSI/PERC Hardware controller supports DDF.
>>
>> Would be possible, for mdadm, to use a RAID created with an LSI/PERC
>> controller supporting DDF ?
Sure.
The recent mdadm should be able to create DDF metadata.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
