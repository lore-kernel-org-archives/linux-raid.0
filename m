From: "NeilBrown" <neilb@suse.de>
Subject: Re: RFC: detection of silent corruption via ATA long sector reads
Date: Mon, 5 Jan 2009 14:24:35 +1100 (EST)
Message-ID: <ac115cdd9ea4fb28aaec2453b57697b0.squirrel@neil.brown.name>
References: <fa.8mwKV7y4hm+Q6mvIKtp9QGoJYUU@ifi.uio.no>
    <fa.4QcsYZC0gJJwJ0eUOht3hDYaVWs@ifi.uio.no>
    <49580061.9060506@yahoo.com>
    <87f94c370901021226j40176872h9e5723c6da4afcbe@mail.gmail.com>
    <yq13ag174af.fsf@sermon.lab.mkp.net>
    <495F6622.9010103@anonymous.org.uk>
    <yq1eizj5xos.fsf@sermon.lab.mkp.net>
    <4960AC15.8030207@anonymous.org.uk>
    <yq1zli631yj.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <yq1zli631yj.fsf@sermon.lab.mkp.net>
Sender: linux-raid-owner@vger.kernel.org
Cc: John Robinson <john.robinson@anonymous.org.uk>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, January 5, 2009 1:45 pm, Martin K. Petersen wrote:
>>>>>> "John" == John Robinson <john.robinson@anonymous.org.uk> writes:
>
> John> Essentially DIF on 32k blocks instead of 512 byte ones. But
> John> perhaps this is a bad assumption and MD/DM already optimises out
> John> whole-chunk reads and writes where they're not required (for very
> John> short, less-than-one-chunk transactions), and I've no idea whether
> John> this happens a lot.
>
> I haven't looked at the RAID4/5/6 code for a long time so I'm not sure
> whether they only write dirty pages or the whole chunk + parity ditto.
> Neil?

md/RAID456 writes whole pages (aligned to the array) but not whole chunks.

If a filesystem request to write one page which is at a sector address
which is not a multiple of the page size, we will pre-read the read of
the two array-aligned pages, and when write them (and parity) back out.

Otherwise, it will just write the requested pages plus parity updates.

NeilBrown


