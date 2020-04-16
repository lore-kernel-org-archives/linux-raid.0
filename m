From: "David C. Rankin" <drankinatty@suddenlinkmail.com>
Subject: Re: Setup Recommendation on UEFI/GRUB/RAID1/LVM
Date: Wed, 15 Apr 2020 20:58:00 -0500
Message-ID: <c457c321-b250-c145-b72c-7e599562ac66@suddenlinkmail.com>
References: <fc12df3c-aac9-4aa8-a596-f13225161e22@peter-speer.de>
 <5E95C698.1030307@youngman.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5E95C698.1030307@youngman.org.uk>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: mdraid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 04/14/2020 09:20 AM, Wols Lists wrote:
> Again, personally, I'd make /tmp a tmpfs rather than a partition of its
> own, the spec says that the system should *expect* /tmp to disappear at
> any time and especially on reboot... while tmpfs defaults to half ram,
> you can specify what size you want, and it'll make use of your swap space.

Agreed, but keep in mind that what is written to /tmp on tmpfs will be stored
in RAM (reducing your available RAM by that amount).

This only becomes an issue if you are running something that makes heavy use
of /tmp (some databases can use huge amounts of temporary storage for queries,
joins, etc...) Or if you are a budding programmer that routinely (or may
accidentally) write very large files to /tmp. If you fall into this category,
you may want to specify that large temporary files are created elsewhere.

I put /tmp on tmpfs for all normal installations and haven't had an issue.

-- 
David C. Rankin, J.D.,P.E.
