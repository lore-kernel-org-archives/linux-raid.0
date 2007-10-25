From: David Greaves <david@dgreaves.com>
Subject: Re: deleting mdadm array?
Date: Thu, 25 Oct 2007 10:55:44 +0100
Message-ID: <47206820.4020005@dgreaves.com>
References: <20071025100619.3b3810be@absurd>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071025100619.3b3810be@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Janek Kozicki wrote:
> Hello,
> 
> I just created a new array /dev/md1 like this:
> 
> mdadm --create --verbose /dev/md1 --chunk=64 --level=raid5 \
>    --metadata=1.1  --bitmap=internal \
>    --raid-devices=3 /dev/hdc2 /dev/sda2 missing
> 
> 
> But later I changed my mind, and I wanted to use chunk 128. Do I need
> to delete this array somehow first, or can I just create an array
> again (overwriting the current one)?

How much later? This will, of course, destroy any data on the array (!) and
you'll need to mkfs again...


To answer the question though: just run mdadm again to create a new array with
new parameters.


I think the only time you need to 'delete' an array before creating a new one is
if you change the superblock version since it quietly writes different
superblocks to different disk locations you may end up with 2 superblocks on the
disk and then you get confusion :)
(I'm not sure if mdadm is clever about this though...)

Also, if you don't mind me asking: why did you choose version 1.1 for the
metadata/superblock version?

David

