From: "Wesley W. Terpstra" <wesley@terpstra.ca>
Subject: Re: BUG drivers/md/md.c: data-offset reshape renders array unloadable
Date: Thu, 5 Feb 2015 09:17:32 +0100
Message-ID: <CAA-O0Xj0su7yFBKEZVLaFHiMwc98Ra=4VKy8evuaZ1=dhXTcyw@mail.gmail.com>
References: <CAA-O0Xjustt5=nNoDzXukY=f-7OwRk=yqug8MCpxcXCt4MdiTw@mail.gmail.com>
	<CAA-O0XgXc0H4H__8ygLzt_BBW3NpEseG9NZBTZ_syMdir8D=mA@mail.gmail.com>
	<CAA-O0Xjw8H1nPsi+MsQnrLxv=gC2tj3=W=t3aMnCE6ESUHMF8w@mail.gmail.com>
	<20150205171402.7dc2f394@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150205171402.7dc2f394@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Feb 5, 2015 at 7:14 AM, NeilBrown <neilb@suse.de> wrote:
> A v1.2 array normally has data from the data_offset all the way to the end of
> the device (maybe rounded  down to chunk size).

Right. So in my case there were 5120 sectors unused at the start.
Unfortunately, I do not know whether the array initially had a 'size'
that included the trailing 3072 sectors or not.

What I do know: before reshape I had a chunk size of 512K and 4 disks
in raid5. When I created the array, tools at the time did not support
--data-offset, but I probably specified all the options I could find
saying I wanted 4M alignment. I reshaped the array from 1 disk to 2 to
3 to 4 as I added disks.

Unfortunately, I do not have a record of what 'mdadm -E' said before I
started the reshape.

Before I fixed the superblock:
 Avail Dev Size : 5842897920 (2786.11 GiB 2991.56 GB)
     Array Size : 8764342272 (8358.33 GiB 8974.69 GB)
  Used Dev Size : 5842894848 (2786.11 GiB 2991.56 GB)
    Data Offset : 8192 sectors

After I fixed the superblock:
 Avail Dev Size : 5842894848 (2786.11 GiB 2991.56 GB)
     Array Size : 8764342272 (8358.33 GiB 8974.69 GB)
    Data Offset : 8192 sectors

> So you normally wouldn't be able to increase the data_offset from 5120 to
> 8192 unless you first reduced the --size of the array (having reduced the
> size of any filesystem first).

Well, it let me do it.

> Did you do that?  That should have reduced sb->data_size appropriately.

No. I just went ahead and increased the data offset.

> If you did --grow the --size first, that should have reduced sb->data_size.

I did not do this step.

> If you didn't the --grow --data-offset should have failed.

I did this directly, and it let me. I had a slightly older kernel when
I started the reshape. 3.17.7 and mdadm 3.3.2.
