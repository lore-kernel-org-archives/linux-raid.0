From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Split RAID: Proposal for archival RAID using incremental batch
 checksum
Date: Wed, 29 Oct 2014 12:32:35 +0500
Message-ID: <20141029123235.56910b68@natsu>
References: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK-d5dbdF160hoa1==jWxEQZRpwQ7Sa76=9MREmp2V6Y24U8Kw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Anshuman Aggarwal <anshuman.aggarwal@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 29 Oct 2014 12:45:34 +0530
Anshuman Aggarwal <anshuman.aggarwal@gmail.com> wrote:

> I'm outlining below a proposal for a RAID device mapper virtual block
> device for the kernel which adds "split raid" functionality on an
> incremental batch basis for a home media server/archived content which
> is rarely accessed.

> Existing solutions considered:

Some of the already-available "home media server" setup schemes you did not
mention:

http://linuxconfig.org/prouhd-raid-for-the-end-user
a smart way of managing MD RAID given multiple devices of various sizes;

http://louwrentius.com/building-a-raid-6-array-of-mixed-drives.html
what to do with a set of mixed-size drives, in simpler terms;

https://romanrm.net/mhddfs
File-level "concatenation" of disks, with smart distribution of new files;

-- 
With respect,
Roman
